{*******************************************************************************
  作者: 289525016@163.com 2017-09-10
  描述: 微信消息管理单位
*******************************************************************************}
unit UMgrWechatMsg;

{$I Link.Inc}
interface
uses
  Classes, IdTCPConnection, IdTCPClient, SyncObjs,UWaitItem;
const
  cSendWeChatMsgType_AddBill=1; //开提货单
  cSendWeChatMsgType_OutFactory=2; //车辆出厂
  cSendWeChatMsgType_Report=3; //报表
  cSendWeChatMsgType_DelBill=4; //删提货单

  c_WeChatStatusCreateCard=0;  //订单已办卡
  c_WeChatStatusFinished=1;  //订单已完成

type
  PWechatConfig = ^TWechatConfig;
  TWechatConfig = record
    FEnabled:boolean;
  end;

  PWechatMsgItem = ^TWechatMsgItem;
  TWechatMsgItem = record
    FLid:string;
    FMsgType:integer;
    FBillType:string;
    FStatus:integer;
    FWebOrderID:string;
    FSuccessed:Boolean;
    FFactoryId:string;
  end;

  TWechatMsgManager=class;

  TWechatMsgControler = class(TThread)
  private
    FOwner: TWechatMsgManager;
    //拥有者
    FBuffer: TList;
    //显示内容
    FWaiter: TWaitObject;
    //等待对象
    //推送消息到微信平台
    procedure SendMsgToWebMall(const nLid,nFactoryId:string;const MsgType:Integer;const nBillType:string);

    //发送消息
    function Do_send_event_msg(const nXmlStr: string): string;

    //修改网上订单状态
    procedure ModifyWebOrderStatus(const nLId:string;nStatus:Integer=c_WeChatStatusFinished;const AWebOrderID:string='');

    //修改网上订单状态
    function Do_ModifyWebOrderStatus(const nXmlStr: string): string;
  protected
    function DoExuecte(const nItem: PWechatMsgItem):Boolean;
    procedure Execute; override;
    //执行线程
  public
    constructor Create(AOwner: TWechatMsgManager);
    destructor Destroy; override;
    //创建释放
    procedure WakupMe;
    //唤醒线程
    procedure StopMe;
    //停止线程
  end;
    
  TWechatMsgManager = class(TObject)
  private
    FControler: TWechatMsgControler;
    FSyncLock: TCriticalSection;
    FBuffData: TList;
    FWechatConfig:TWechatConfig;
    FWeChatData: Word;
    procedure ClearBuffer(const nList: TList; const nFree: Boolean = False);
  protected
    procedure RegisterDataType;
  public
    procedure StartService;
    procedure StopService;  
    procedure LoadConfig(const nFile: string);
    constructor Create;
    destructor Destroy; override;
    procedure SendMsg(const nLid,nFactoryId:string;const nMsgType:Integer;const nBillType:string;
      nStatus:Integer=c_WeChatStatusFinished;const nWebOrderID:string='');
  end;

var
  gWechatMsgManager: TWechatMsgManager = nil;

implementation
uses
  NativeXml,SysUtils,Windows,ULibFun,USysLoger,IdGlobal,Forms,UBusinessConst,
  USysDB,UBusinessPacker,UWorkerBusiness,UMgrDBConn,
  UMgrParam,UHardBusiness,UMemDataPool;

procedure OnNew(const nFlag: string; const nType: Word; var nData: Pointer);
var nItem: PWechatMsgItem;
begin
  if nFlag = 'WeChatData' then
  begin
    New(nItem);
    nData := nItem;
  end;
end;

procedure OnFree(const nFlag: string; const nType: Word; const nData: Pointer);
var nItem: PWechatMsgItem;
begin
  if nFlag = 'WeChatData' then
  begin
    nItem := nData;
    Dispose(nItem);
  end;
end;
  
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TWechatMsgManager, '微信消息管理', nEvent);
end;
  
{ TWechatMsgControler }
constructor TWechatMsgControler.Create(
  AOwner: TWechatMsgManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;

  FBuffer := TList.Create;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 2000;
end;

destructor TWechatMsgControler.Destroy;
begin
  FOwner.ClearBuffer(FBuffer, True);
  FWaiter.Free;
  inherited;
end;

procedure TWechatMsgControler.WakupMe;
begin
  FWaiter.Wakeup;
end;

procedure TWechatMsgControler.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TWechatMsgControler.Execute;
var nStr: string;
    nIdx: Integer;
    nItem:PWechatMsgItem;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    FOwner.FSyncLock.Enter;
    try
      for nIdx:=0 to FOwner.FBuffData.Count - 1 do
        FBuffer.Add(FOwner.FBuffData[nIdx]);
      FOwner.FBuffData.Clear;
    finally
      FOwner.FSyncLock.Leave;
    end;

    if FBuffer.Count > 0 then
    begin
      try
        for nIdx := 0 to FBuffer.Count-1 do
        begin
          nItem := FBuffer.Items[nIdx];
          if not nItem.FSuccessed then
          begin
            if DoExuecte(nItem) then
            begin
              nItem.FSuccessed := True;
            end;
          end;
        end;
      finally
        for nIdx :=FBuffer.Count-1 downto 0 do
        begin
          nItem := FBuffer.Items[nIdx];
          if nItem.FSuccessed then
          begin
            gMemDataManager.UnLockData(nItem);
            FBuffer.Delete(nIdx);
          end;
        end;
      end;
    end;
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

function TWechatMsgControler.DoExuecte(const nItem: PWechatMsgItem):Boolean;
begin
  Result := False;
  if not Terminated then
  begin
    try
      ModifyWebOrderStatus(nItem.FLid,nitem.FStatus,nitem.FWebOrderID);
    except
      on E: Exception do
      begin
        WriteLog(Format('ModifyWebOrderStatus[ %s.%s ]异常:[ %s ].', [nItem.FLid,nitem.FWebOrderID,E.Message]));
        Exit;
      end;
    end;
    try
      SendMsgToWebMall(nItem.FLid,nItem.FFactoryId,nItem.FMsgType,nItem.FBillType);
      Result := True;
    except
      on E: Exception do
      begin
        WriteLog(Format('SendMsgToWebMall[ %s ]异常:[ %s ].', [nItem.FLid,E.Message]));
        Exit;
      end;
    end;
  end;
end;

procedure TWechatMsgControler.SendMsgToWebMall(const nLid,nFactoryId:string;const MsgType:Integer;const nBillType:string);
var nBills: TLadingBillItems;
    nXmlStr,nData:string;
    nIdx:Integer;
    nNetWeight:Double;
begin
  {$IFNDEF EnableWebMall}
  Exit;
  {$ENDIF}
  
  nNetWeight := 0;
  if nBillType=sFlag_Sale then
  begin
    //加载提货单信息
    if not GetLadingBills(nLid, sFlag_BillDone, nBills) then
    begin
      Exit;
    end;
  end
  else if nBillType=sFlag_Provide then
  begin
    //加载采购订单信息
    if not GetLadingOrders(nLid, sFlag_BillDone, nBills) then
    begin
      Exit;
    end;  
  end
  else begin
    Exit;
  end;
  for nIdx := Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    nNetWeight := FValue;
    nXmlStr := '<?xml version="1.0" encoding="UTF-8"?>'
        +'<DATA>'
        +'<head>'
        +'<Factory>%s</Factory>'
        +'<ToUser>%s</ToUser>'
        +'<MsgType>%d</MsgType>'
        +'</head>'
        +'<Items>'
        +'	  <Item>'
        +'	      <BillID>%s</BillID>'
        +'	      <Card>%s</Card>'
        +'	      <Truck>%s</Truck>'
        +'	      <StockNo>%s</StockNo>'
        +'	      <StockName>%s</StockName>'
        +'	      <CusID>%s</CusID>'
        +'	      <CusName>%s</CusName>'
        +'	      <CusAccount>0</CusAccount>'
        +'	      <MakeDate></MakeDate>'
        +'	      <MakeMan></MakeMan>'
        +'	      <TransID></TransID>'
        +'	      <TransName></TransName>'
        +'	      <NetWeight>%f</NetWeight>'
        +'	      <Searial></Searial>'
        +'	      <OutFact></OutFact>'
        +'	      <OutMan></OutMan>'
        +'	  </Item>	'
        +'</Items>'
        +'</DATA>';
    nXmlStr := Format(nXmlStr,[nFactoryId, FCusID, MsgType,//cSendWeChatMsgType_DelBill,
               FID, FCard, FTruck, FStockNo, FStockName, FCusID, FCusName,nNetWeight]);

    nXmlStr := PackerEncodeStr(nXmlStr);
    nData := Do_send_event_msg(nXmlStr);

    if ndata<>'' then
    begin
      WriteLog(nData);
    end;
  end;
end;

//发送消息
function TWechatMsgControler.Do_send_event_msg(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if TWorkerBusinessCommander.CallMe(cBC_WeChat_send_event_msg, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//修改网上订单状态
procedure TWechatMsgControler.ModifyWebOrderStatus(const nLId:string;nStatus:Integer;const AWebOrderID:string);
var
  nXmlStr,nData,nSql:string;
  nDBConn: PDBWorker;
  nWebOrderId:string;
  nIdx:Integer;
  FNetWeight:Double;
begin
  {$IFNDEF EnableWebMall}
  Exit;
  {$ENDIF}
  
  FNetWeight := 0;
  nWebOrderId := AWebOrderID;
  nDBConn := nil;
  if nWebOrderId='' then
  begin
    with gParamManager.ActiveParam^ do
    begin
      try
        nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
        if not Assigned(nDBConn) then
        begin
  //        WriteNearReaderLog('连接HM数据库失败(DBConn Is Null).');
          Exit;
        end;
        if not nDBConn.FConn.Connected then
        nDBConn.FConn.Connected := True;

        //查询网上商城订单
        nSql := 'select WOM_WebOrderID from %s where WOM_LID=''%s''';
        nSql := Format(nSql,[sTable_WebOrderMatch,nLId]);

        with gDBConnManager.WorkerQuery(nDBConn, nSql) do
        begin
          if recordcount>0 then
          begin
            nWebOrderId := FieldByName('WOM_WebOrderID').asstring;
          end;
        end;

        //销售净重
        nSql := 'select L_Value from %s where l_id=''%s'' and l_status=''%s''';
        nSql := Format(nSql,[sTable_Bill,nLId,sFlag_TruckOut]);
        with gDBConnManager.WorkerQuery(nDBConn, nSql) do
        begin
          if recordcount>0 then
          begin
            FNetWeight := FieldByName('L_Value').asFloat;
          end;          
        end;
        //采购净重
        if FNetWeight<0.0001 then
        begin
          nSql := 'select sum(d_mvalue) d_mvalue,sum(d_pvalue) d_pvalue from %s where d_oid=''%s'' and d_status=''%s''';
          nSql := Format(nSql,[sTable_OrderDtl,nLId,sFlag_TruckOut]);
          with gDBConnManager.WorkerQuery(nDBConn, nSql) do
          begin
            if recordcount>0 then
            begin
              FNetWeight := FieldByName('d_mvalue').asFloat-FieldByName('d_pvalue').asFloat;
            end;
          end;
        end;
      finally
        gDBConnManager.ReleaseConnection(nDBConn);
      end;
    end;
  end;

  if nWebOrderId='' then Exit;
  
  nXmlStr := '<?xml version="1.0" encoding="UTF-8"?>'
            +'<DATA>'
            +'<head><ordernumber>%s</ordernumber>'
            +'<status>%d</status>'
            +'<NetWeight>%f</NetWeight>'
            +'</head>'
            +'</DATA>';
  nXmlStr := Format(nXmlStr,[nWebOrderId,nStatus,FNetWeight]);
  nXmlStr := PackerEncodeStr(nXmlStr);

  nData := Do_ModifyWebOrderStatus(nXmlStr);
  gSysLoger.AddLog(nData);

  if ndata<>'' then
  begin
    WriteLog(nData);
  end;
end;

//修改网上订单状态
function TWechatMsgControler.Do_ModifyWebOrderStatus(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if TWorkerBusinessCommander.CallMe(cBC_WeChat_complete_shoporders, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;
{ TWechatMsgManager }
constructor TWechatMsgManager.Create;
begin
  RegisterDataType;
  inherited Create;
  FSyncLock := TCriticalSection.Create;
  FBuffData := TList.Create;
end;

destructor TWechatMsgManager.Destroy;
begin
  StopService;
  ClearBuffer(FBuffData, True);
  FSyncLock.Free;
  inherited;
end;

procedure TWechatMsgManager.LoadConfig(const nFile: string);
var
  nXML: TNativeXml;
  nNode: TXmlNode;
begin
  nXML := TNativeXml.Create;
  try
    try
      nXML.LoadFromFile(nFile);
      nNode := nXML.Root;
      FWechatConfig.FEnabled := nNode.NodeByName('enable').ValueAsString = '1';
    except
      on E: Exception do
      begin
        WriteLog('TWechatMsgManager.LoadConfig Error:'+E.Message);
      end;
    end;
  finally
    nXML.Free;
  end;
end;

procedure TWechatMsgManager.ClearBuffer(const nList: TList;
  const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx := nList.Count - 1 downto 0 do
  begin
    gMemDataManager.UnLockData(nList[nIdx]);
    nList.Delete(nIdx);
  end;

  if nFree then
    nList.Free;
  //xxxxx
end;

procedure TWechatMsgManager.StartService;
begin
  if FWechatConfig.FEnabled then
  begin
    if not Assigned(FControler) then
      FControler := TWechatMsgControler.Create(Self);
    FControler.WakupMe;
  end;
end;

procedure TWechatMsgManager.StopService;
begin
  if Assigned(FControler) then
    FControler.StopMe;
  FControler := nil;
end;

procedure TWechatMsgManager.SendMsg(const nLid,nFactoryId: string;
  const nMsgType: Integer; const nBillType: string; nStatus: Integer;
  const nWebOrderID: string);
var
  nItem:PWechatMsgItem;
begin
  FSyncLock.Enter;
  try
    nItem := gMemDataManager.LockData(FWeChatData);
    
    nItem.FFactoryId := nFactoryId;
    nItem.FSuccessed := False;
    nItem.FLid := nLid;
    nItem.FMsgType := nMsgType;
    nitem.FBillType := nBillType;
    nItem.FStatus := nStatus;
    nItem.FWebOrderID := nWebOrderID;
    FBuffData.Add(nItem);
    FControler.WakupMe;
  finally
    FSyncLock.Leave;
  end;   
end;

procedure TWechatMsgManager.RegisterDataType;
begin
  if not Assigned(gMemDataManager) then
    raise Exception.Create('WechatMsgManager Needs MemDataManager Support.');
  //xxxxx

  with gMemDataManager do
    FWeChatData := RegDataType('WeChatData', 'WechatMsgManager', OnNew, OnFree, 20);
  //xxxxx
end;

initialization
  gWechatMsgManager := nil;
finalization
  FreeAndNil(gWechatMsgManager);

end.
