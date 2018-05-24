{*******************************************************************************
  作者: dmzn@163.com 2013-12-04
  描述: 模块业务对象
*******************************************************************************}
unit UWorkerBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, ULibFun, UFormCtrl, UBase64,
  USysLoger, USysDB, UMITConst;

type
  TBusWorkerQueryField = class(TBusinessWorkerBase)
  private
    FIn: TWorkerQueryFieldData;
    FOut: TWorkerQueryFieldData;
  public
    class function FunctionName: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    function DoWork(var nData: string): Boolean; override;
    //执行业务
  end;

  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //错误码
    FDBConn: PDBWorker;
    LocalDB_zyw: string;
    //数据通道
    FDataIn,FDataOut: PBWDataBase;
    //入参出参
    FDataOutNeedUnPack: Boolean;
    //需要解包
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //出入参数
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //验证入参
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //数据业务
  public
    function DoWork(var nData: string): Boolean; override;
    //执行业务
    procedure WriteLog(const nEvent: string);
    //记录日志
  end;

  TK3SalePalnItem = record
    FInterID: string;       //主表编号
    FEntryID: string;       //附表编号
    FTruck: string;         //车牌号
  end;

  TWorkerBusinessCommander = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
    {$IFDEF UseK3SalePlan}
    FSalePlans: array of TK3SalePalnItem;
    //k3销售计划
    {$ENDIF}
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetCardUsed(var nData: string): Boolean;
    //获取卡片类型
    function Login(var nData: string):Boolean;
    function LogOut(var nData: string): Boolean;
    //登录注销，用于移动终端
    function GetServerNow(var nData: string): Boolean;
    //获取服务器时间
    function GetSerailID(var nData: string): Boolean;
    //获取串号
    function IsSystemExpired(var nData: string): Boolean;
    //系统是否已过期
    function GetCustomerValidMoney(var nData: string): Boolean;
    //获取客户可用金

    function GetZhiKaValidMoney(var nData: string): Boolean;
    //获取纸卡可用金
    function CustomerHasMoney(var nData: string): Boolean;
    //验证客户是否有钱
    function SaveTruck(var nData: string): Boolean;
    function UpdateTruck(var nData: string): Boolean;
    //保存车辆到Truck表
    function GetTruckPoundData(var nData: string): Boolean;
    function SaveTruckPoundData(var nData: string): Boolean;
    //存取车辆称重数据
    function GetStockBatcode(var nData: string): Boolean;
    //获取品种批次号
    {$IFDEF UseERP_K3}
    function SyncRemoteCustomer(var nData: string): Boolean;
    function SyncRemoteProviders(var nData: string): Boolean;
    function SyncRemoteMaterails(var nData: string): Boolean;
    function SyncRemoteSaleMan(var nData: string): Boolean;
    //同步新安中联K3系统数据
    function SyncRemoteStockBill(var nData: string): Boolean;
    //同步交货单到K3系统
    function SyncRemoteStockOrder(var nData: string): Boolean;
    //同步交货单到K3系统
    function IsStockValid(var nData: string): Boolean;
    //验证物料是否允许发货
    {$ENDIF}

    //date: 2018-08-17
    //同步新中大A3中的系统数据
    {$IFDEF XzdERP_A3}
    function SyncRemoteCustomer_zyw(var nData: string): Boolean;
    function SyncRemoteProviders_zyw(var nData: string): Boolean;
    function SyncRemoteMaterails_zyw(var nData: string): Boolean;
    function SyncRemoteSaleMan_zyw(var nData: string): Boolean;

    function SyncRemoteStockBill_zyw(var nData: string): Boolean;
    //同步销售单到新中大A3系统
    function SyncRemoteStockOrder_zyw(var nData: string): Boolean;
    //同步采购单到新中大A3系统
    {$ENDIF}

    {$IFDEF UseK3SalePlan}
    function IsSalePlanUsed(const nInter,nEntry,nTruck: string): Boolean;
    function GetSalePlan(var nData: string): Boolean;
    //读取销售计划
    {$ENDIF}
    //防伪码校验
    function CheckSecurityCodeValid(var nData: string): Boolean;

    //工厂待装查询
    function GetWaitingForloading(var nData: string):Boolean;

    //网上订单可下单数量查询
    function GetBillSurplusTonnage(var nData:string):boolean;

    //获取订单信息，用于网上下单
    function GetOrderInfo(var nData:string):Boolean;

    //获取订单信息，用于网上下单
    function GetOrderList(var nData:string):Boolean;

    //获取采购合同列表，用于网上下单
    function GetPurchaseContractList(var nData:string):Boolean;

    //获取客户注册信息
    function getCustomerInfo(var nData:string):Boolean;

    //客户与微信账号绑定
    function get_Bindfunc(var nData:string):Boolean;

    //发送消息
    function send_event_msg(var nData:string):Boolean;

    //新增商城用户
    function edit_shopclients(var nData:string):Boolean;

    //添加商品
    function edit_shopgoods(var nData:string):Boolean;

    //获取订单信息
    function get_shoporders(var nData:string):Boolean;

    //根据订单号获取订单信息
    function get_shoporderbyno(var nData:string):Boolean;

    //根据货单号获取货单信息-原材料
    function get_shopPurchasebyNO(var nData:string):Boolean;

    //修改订单状态
    function complete_shoporders(var nData:string):Boolean;    
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation
uses
  UMgrQueue, UWorkerClientWebChat;

class function TBusWorkerQueryField.FunctionName: string;
begin
  Result := sBus_GetQueryField;
end;

function TBusWorkerQueryField.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_GetQueryField;
  end;
end;

function TBusWorkerQueryField.DoWork(var nData: string): Boolean;
begin
  FOut.FData := '*';
  FPacker.UnPackIn(nData, @FIn);

  case FIn.FType of
   cQF_Bill: 
    FOut.FData := '*';
  end;

  Result := True;
  FOut.FBase.FResult := True;
  nData := FPacker.PackOut(@FOut);
end;

//------------------------------------------------------------------------------
//Date: 2012-3-13
//Parm: 如参数护具
//Desc: 获取连接数据库所需的资源
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;



  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);

    LocalDB_zyw := FDB.FID;

    if not Assigned(FDBConn) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      nData := FPacker.PackOut(FDataOut);

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;

//Date: 2012-3-22
//Parm: 输出数据;结果
//Desc: 数据业务执行完毕后的收尾操作
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: 入参数据
//Desc: 验证入参数据是否有效
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: 记录nEvent日志
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TWorkerBusinessCommander.FunctionName: string;
begin
  Result := sBus_BusinessCommand;
end;

constructor TWorkerBusinessCommander.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessCommander.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessCommander.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessCommander.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
class function TWorkerBusinessCommander.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nPacker.InitData(@nIn, True, False);
    //init
    
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2012-3-22
//Parm: 输入数据
//Desc: 执行nData业务指令
function TWorkerBusinessCommander.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;

  case FIn.FCommand of
   cBC_GetCardUsed         : Result := GetCardUsed(nData);
   cBC_ServerNow           : Result := GetServerNow(nData);
   cBC_GetSerialNO         : Result := GetSerailID(nData);
   cBC_IsSystemExpired     : Result := IsSystemExpired(nData);
   cBC_GetCustomerMoney    : Result := GetCustomerValidMoney(nData);
   cBC_GetZhiKaMoney       : Result := GetZhiKaValidMoney(nData);
   cBC_CustomerHasMoney    : Result := CustomerHasMoney(nData);
   cBC_SaveTruckInfo       : Result := SaveTruck(nData);
   cBC_UpdateTruckInfo     : Result := UpdateTruck(nData);
   cBC_GetTruckPoundData   : Result := GetTruckPoundData(nData);
   cBC_SaveTruckPoundData  : Result := SaveTruckPoundData(nData);
   cBC_UserLogin           : Result := Login(nData);
   cBC_UserLogOut          : Result := LogOut(nData);
   cBC_GetStockBatcode     : Result := GetStockBatcode(nData);

   {$IFDEF UseERP_K3}
   cBC_SyncCustomer        : Result := SyncRemoteCustomer(nData);
   cBC_SyncSaleMan         : Result := SyncRemoteSaleMan(nData);
   cBC_SyncProvider        : Result := SyncRemoteProviders(nData);
   cBC_SyncMaterails       : Result := SyncRemoteMaterails(nData);
   cBC_SyncStockBill       : Result := SyncRemoteStockBill(nData);
   cBC_CheckStockValid     : Result := IsStockValid(nData);

   cBC_SyncStockOrder      : Result := SyncRemoteStockOrder(nData);
   {$ENDIF}

   //2017-09-05
   //新中大
   {$IFDEF XzdERP_A3}
   cBC_SyncCustomer        : Result := SyncRemoteCustomer_zyw(nData);
   cBC_SyncProvider        : Result := SyncRemoteProviders_zyw(nData);
   cBC_SyncMaterails       : Result := SyncRemoteMaterails_zyw(nData);
   cBC_SyncSaleMan         : Result := SyncRemoteSaleMan_zyw(nData);

   cBC_SyncStockBill       : Result := SyncRemoteStockBill_zyw(nData);
   cBC_SyncStockOrder      : Result := SyncRemoteStockOrder_zyw(nData);
   {$ENDIF}

   {$IFDEF UseK3SalePlan}
   cBC_LoadSalePlan        : Result := GetSalePlan(nData);
   {$ENDIF}
   
   cBC_VerifPrintCode      : Result := CheckSecurityCodeValid(nData); //验证码查询
   cBC_WaitingForloading   : Result := GetWaitingForloading(nData); //待装车辆查询
   cBC_BillSurplusTonnage  : Result := GetBillSurplusTonnage(nData); //查询商城订单可用量
   cBC_GetOrderInfo        : Result := GetOrderInfo(nData); //查询云天系统订单信息
   cBC_GetOrderList        : Result := GetOrderList(nData); //查询云天系统订单列表
   cBC_GetPurchaseContractList : Result := GetPurchaseContractList(nData); //查询采购合同列表

   cBC_WeChat_getCustomerInfo : Result := getCustomerInfo(nData);   //微信平台接口：获取客户注册信息
   cBC_WeChat_get_Bindfunc    : Result := get_Bindfunc(nData);   //微信平台接口：客户与微信账号绑定
   cBC_WeChat_send_event_msg  : Result := send_event_msg(nData);   //微信平台接口：发送消息
   cBC_WeChat_edit_shopclients : Result := edit_shopclients(nData);   //微信平台接口：新增商城用户
   cBC_WeChat_edit_shopgoods  : Result := edit_shopgoods(nData);   //微信平台接口：添加商品
   cBC_WeChat_get_shoporders  : Result := get_shoporders(nData);   //微信平台接口：获取订单信息
   cBC_WeChat_complete_shoporders  : Result := complete_shoporders(nData);   //微信平台接口：修改订单状态
   cBC_WeChat_get_shoporderbyno : Result := get_shoporderbyno(nData);   //微信平台接口：根据订单号获取订单信息
   cBC_WeChat_get_shopPurchasebyNO : Result := get_shopPurchasebyNO(nData);   
   else
    begin
      Result := False;
      nData := '无效的业务代码(Invalid Command).';
    end;
  end;
end;

//Date: 2014-09-05
//Desc: 获取卡片类型：销售S;采购P;其他O
function TWorkerBusinessCommander.GetCardUsed(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr := 'Select C_Used From %s Where C_Card=''%s'' ' +
          ' or C_Card3=''%s'' or C_Card2=''%s''';
  nStr := Format(nStr, [sTable_Card, FIn.FData, FIn.FData, FIn.FData]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then
    begin
      nData := '磁卡[ %s ]信息不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    FOut.FData := Fields[0].AsString;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: 用户名，密码；返回用户数据
//Desc: 用户登录
function TWorkerBusinessCommander.Login(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  FListA.Clear;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if FListA.Values['User']='' then Exit;
  //未传递用户名

  nStr := 'Select U_Password From %s Where U_Name=''%s''';
  nStr := Format(nStr, [sTable_User, FListA.Values['User']]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then Exit;

    nStr := Fields[0].AsString;
    if nStr<>FListA.Values['Password'] then Exit;
    {
    if CallMe(cBC_ServerNow, '', '', @nOut) then
         nStr := PackerEncodeStr(nOut.FData)
    else nStr := IntToStr(Random(999999));

    nInfo := FListA.Values['User'] + nStr;
    //xxxxx

    nStr := 'Insert into $EI(I_Group, I_ItemID, I_Item, I_Info) ' +
            'Values(''$Group'', ''$ItemID'', ''$Item'', ''$Info'')';
    nStr := MacroValue(nStr, [MI('$EI', sTable_ExtInfo),
            MI('$Group', sFlag_UserLogItem), MI('$ItemID', FListA.Values['User']),
            MI('$Item', PackerEncodeStr(FListA.Values['Password'])),
            MI('$Info', nInfo)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);  }

    Result := True;
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: 用户名；验证数据
//Desc: 用户注销
function TWorkerBusinessCommander.LogOut(var nData: string): Boolean;
//var nStr: string;
begin
  {nStr := 'delete From %s Where I_ItemID=''%s''';
  nStr := Format(nStr, [sTable_ExtInfo, PackerDecodeStr(FIn.FData)]);
  //card status

  
  if gDBConnManager.WorkerExec(FDBConn, nStr)<1 then
       Result := False
  else Result := True;     }

  Result := True;
end;

//Date: 2014-09-05
//Desc: 获取服务器当前时间
function TWorkerBusinessCommander.GetServerNow(var nData: string): Boolean;
var nStr: string;
begin
  nStr := 'Select ' + sField_SQLServer_Now;
  //sql

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    FOut.FData := DateTime2Str(Fields[0].AsDateTime);
    Result := True;
  end;
end;

//Date: 2012-3-25
//Desc: 按规则生成序列编号
function TWorkerBusinessCommander.GetSerailID(var nData: string): Boolean;
var nInt: Integer;
    nStr,nP,nB: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    Result := False;
    FListA.Text := FIn.FData;
    //param list

    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, FListA.Values['Group'],
            FListA.Values['Object']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base,B_Date,%s as B_Now From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_SerialBase,
            FListA.Values['Group'], FListA.Values['Object']]);
    //xxxxx

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '没有[ %s.%s ]的编码配置.';
        nData := Format(nData, [FListA.Values['Group'], FListA.Values['Object']]);

        FDBConn.FConn.RollbackTrans;
        Exit;
      end;

      nP := FieldByName('B_Prefix').AsString;
      nB := FieldByName('B_Base').AsString;
      nInt := FieldByName('B_IDLen').AsInteger;

      if FIn.FExtParam = sFlag_Yes then //按日期编码
      begin
        nStr := Date2Str(FieldByName('B_Date').AsDateTime, False);
        //old date

        if (nStr <> Date2Str(FieldByName('B_Now').AsDateTime, False)) and
           (FieldByName('B_Now').AsDateTime > FieldByName('B_Date').AsDateTime) then
        begin
          nStr := 'Update %s Set B_Base=1,B_Date=%s ' +
                  'Where B_Group=''%s'' And B_Object=''%s''';
          nStr := Format(nStr, [sTable_SerialBase, sField_SQLServer_Now,
                  FListA.Values['Group'], FListA.Values['Object']]);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          nB := '1';
          nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);
          //now date
        end;

        System.Delete(nStr, 1, 2);
        //yymmdd
        nInt := nInt - Length(nP) - Length(nStr) - Length(nB);
        FOut.FData := nP + nStr + StringOfChar('0', nInt) + nB;
      end else
      begin
        nInt := nInt - Length(nP) - Length(nB);
        nStr := StringOfChar('0', nInt);
        FOut.FData := nP + nStr + nB;
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-05
//Desc: 验证系统是否已过期
function TWorkerBusinessCommander.IsSystemExpired(var nData: string): Boolean;
var nStr: string;
    nDate: TDate;
    nInt: Integer;
begin
  nDate := Date();
  //server now

  nStr := 'Select D_Value,D_ParamB From %s ' +
          'Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := 'dmzn_stock_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    if nStr = Fields[1].AsString then
      nDate := Str2Date(Fields[0].AsString);
    //xxxxx
  end;

  nInt := Trunc(nDate - Date());
  Result := nInt > 0;

  if nInt <= 0 then
  begin
    nStr := '系统已过期 %d 天,请联系管理员!!';
    nData := Format(nStr, [-nInt]);
    Exit;
  end;

  FOut.FData := IntToStr(nInt);
  //last days

  if nInt <= 7 then
  begin
    nStr := Format('系统在 %d 天后过期', [nInt]);
    FOut.FBase.FErrDesc := nStr;
    FOut.FBase.FErrCode := sFlag_ForceHint;
  end;
end;

{$IFDEF COMMON}
//Date: 2014-09-05
//Desc: 获取指定客户的可用金额
function TWorkerBusinessCommander.GetCustomerValidMoney(var nData: string): Boolean;
var nStr: string;
    nUseCredit: Boolean;
    nVal,nCredit: Double;
begin
  nUseCredit := False;
  if FIn.FExtParam = sFlag_Yes then
  begin
    nStr := 'Select MAX(C_End) From %s ' +
            'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
    nStr := Format(nStr, [sTable_CusCredit, FIn.FData, sFlag_Yes]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      nUseCredit := (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
                    (Fields[0].AsDateTime > Now());
    //信用未过期
  end;

  nStr := 'Select * From %s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CusAccount, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的客户账户不存在.';
      nData := Format(nData, [FIn.FData]);

      Result := False;
      Exit;
    end;

    nVal := FieldByName('A_InitMoney').AsFloat + FieldByName('A_InMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat -
            FieldByName('A_FreezeMoney').AsFloat;
    //xxxxx

    nCredit := FieldByName('A_CreditLimit').AsFloat;
    nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;

    if nUseCredit then
      nVal := nVal + nCredit;

    nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;
    FOut.FData := FloatToStr(nVal);
    FOut.FExtParam := FloatToStr(nCredit);
    Result := True;
  end;
end;
{$ENDIF}

{$IFDEF COMMON}
//Date: 2014-09-05
//Desc: 获取指定纸卡的可用金额
function TWorkerBusinessCommander.GetZhiKaValidMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nMoney,nCredit: Double;
begin
  nStr := 'Select ca.*,Z_OnlyMoney,Z_FixedMoney From $ZK,$CA ca ' +
          'Where Z_ID=''$ZID'' and A_CID=Z_Customer';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ZID', FIn.FData),
          MI('$CA', sTable_CusAccount)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的纸卡不存在,或客户账户无效.';
      nData := Format(nData, [FIn.FData]);

      Result := False;
      Exit;
    end;

    FOut.FExtParam := FieldByName('Z_OnlyMoney').AsString;
    nMoney := FieldByName('Z_FixedMoney').AsFloat;

    nVal := FieldByName('A_InitMoney').AsFloat + FieldByName('A_InMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat -
            FieldByName('A_FreezeMoney').AsFloat;
    //xxxxx

    nCredit := FieldByName('A_CreditLimit').AsFloat;
    nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;

    nStr := 'Select MAX(C_End) From %s ' +
            'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
    nStr := Format(nStr, [sTable_CusCredit, FieldByName('A_CID').AsString,
            sFlag_Yes]);
    //xxxxx

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
       (Fields[0].AsDateTime > Now()) then
    begin
      nVal := nVal + nCredit;
      //信用未过期
    end;

    nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;
    //total money

    if FOut.FExtParam = sFlag_Yes then
    begin
      if nMoney > nVal then
        nMoney := nVal;
      //enough money
    end else nMoney := nVal;

    FOut.FData := FloatToStr(nMoney);
    Result := True;
  end;
end;
{$ENDIF}

//Date: 2014-09-05
//Desc: 验证客户是否有钱,以及信用是否过期
function TWorkerBusinessCommander.CustomerHasMoney(var nData: string): Boolean;
var nStr,nName: string;
    nM,nC: Double;
begin
  FIn.FExtParam := sFlag_No;
  Result := GetCustomerValidMoney(nData);
  if not Result then Exit;

  nM := StrToFloat(FOut.FData);
  FOut.FData := sFlag_Yes;
  if nM > 0 then Exit;

  nStr := 'Select C_Name From %s Where C_ID=''%s''';
  nStr := Format(nStr, [sTable_Customer, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
         nName := Fields[0].AsString
    else nName := '已删除';
  end;

  nC := StrToFloat(FOut.FExtParam);
  if (nC <= 0) or (nC + nM <= 0) then
  begin
    nData := Format('客户[ %s ]的资金余额不足.', [nName]);
    Result := False;
    Exit;
  end;

  nStr := 'Select MAX(C_End) From %s ' +
          'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
  nStr := Format(nStr, [sTable_CusCredit, FIn.FData, sFlag_Yes]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
     (Fields[0].AsDateTime <= Now()) then
  begin
    nData := Format('客户[ %s ]的信用已过期.', [nName]);
    Result := False;
  end;
end;

//Date: 2014-10-02
//Parm: 车牌号[FIn.FData];
//Desc: 保存车辆到sTable_Truck表
function TWorkerBusinessCommander.SaveTruck(var nData: string): Boolean;
var nStr: string;
begin
  Result := True;
  FIn.FData := UpperCase(FIn.FData);
  
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, FIn.FData]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Truck, FIn.FData, GetPinYinOfStr(FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2016-02-16
//Parm: 车牌号(Truck); 表字段名(Field);数据值(Value)
//Desc: 更新车辆信息到sTable_Truck表
function TWorkerBusinessCommander.UpdateTruck(var nData: string): Boolean;
var nStr: string;
    nValInt: Integer;
    nValFloat: Double;
begin
  Result := True;
  FListA.Text := FIn.FData;

  if FListA.Values['Field'] = 'T_PValue' then
  begin
    nStr := 'Select T_PValue, T_PTime From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, FListA.Values['Truck']]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nValInt := Fields[1].AsInteger;
      nValFloat := Fields[0].AsFloat;
    end else Exit;

    nValFloat := nValFloat * nValInt + StrToFloatDef(FListA.Values['Value'], 0);
    nValFloat := nValFloat / (nValInt + 1);
    nValFloat := Float2Float(nValFloat, cPrecision);

    nStr := 'Update %s Set T_PValue=%.2f, T_PTime=T_PTime+1 Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nValFloat, FListA.Values['Truck']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2014-09-25
//Parm: 车牌号[FIn.FData]
//Desc: 获取指定车牌号的称皮数据(使用配对模式,未称重)
function TWorkerBusinessCommander.GetTruckPoundData(var nData: string): Boolean;
var nStr: string;
    nPound: TLadingBillItems;
begin
  SetLength(nPound, 1);
  FillChar(nPound[0], SizeOf(TLadingBillItem), #0);

  nStr := 'Select * From %s Where P_Truck=''%s'' And ' +
          'P_MValue Is Null And P_PModel=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, FIn.FData, sFlag_PoundPD]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr),nPound[0] do
  begin
    if RecordCount > 0 then
    begin
      FCusID      := FieldByName('P_CusID').AsString;
      FCusName    := FieldByName('P_CusName').AsString;
      FTruck      := FieldByName('P_Truck').AsString;

      FType       := FieldByName('P_MType').AsString;
      FStockNo    := FieldByName('P_MID').AsString;
      FStockName  := FieldByName('P_MName').AsString;

      with FPData do
      begin
        FStation  := FieldByName('P_PStation').AsString;
        FValue    := FieldByName('P_PValue').AsFloat;
        FDate     := FieldByName('P_PDate').AsDateTime;
        FOperator := FieldByName('P_PMan').AsString;
      end;  

      FFactory    := FieldByName('P_FactID').AsString;
      FPModel     := FieldByName('P_PModel').AsString;
      FPType      := FieldByName('P_Type').AsString;
      FPoundID    := FieldByName('P_ID').AsString;

      FStatus     := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckBFM;
      FSelected   := True;
    end else
    begin
      FTruck      := FIn.FData;
      FPModel     := sFlag_PoundPD;

      FStatus     := '';
      FNextStatus := sFlag_TruckBFP;
      FSelected   := True;
    end;
  end;

  FOut.FData := CombineBillItmes(nPound);
  Result := True;
end;

//Date: 2014-09-25
//Parm: 称重数据[FIn.FData]
//Desc: 获取指定车牌号的称皮数据(使用配对模式,未称重)
function TWorkerBusinessCommander.SaveTruckPoundData(var nData: string): Boolean;
var nStr,nSQL: string;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  AnalyseBillItems(FIn.FData, nPound);
  //解析数据

  with nPound[0] do
  begin
    if FPoundID = '' then
    begin
      TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, FTruck, '', @nOut);
      //保存车牌号

      FListC.Clear;
      FListC.Values['Group'] := sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_PoundID;

      if not CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FPoundID := nOut.FData;
      //new id

      if FPModel = sFlag_PoundLS then
           nStr := sFlag_Other
      else nStr := sFlag_Provide;

      nSQL := MakeSQLByStr([
              SF('P_ID', FPoundID),
              SF('P_Type', nStr),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', sFlag_San),
              SF('P_PValue', FPData.FValue, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_FactID', FFactory),
              SF('P_PStation', FPData.FStation),
              SF('P_Direction', '进厂'),
              SF('P_PModel', FPModel),
              SF('P_Status', sFlag_TruckBFP),
              SF('P_Valid', sFlag_Yes),
              SF('P_PrintNum', 1, sfVal)
              ], sTable_PoundLog, '', True);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end else
    begin
      nStr := SF('P_ID', FPoundID);
      //where

      if FNextStatus = sFlag_TruckBFP then
      begin
        nSQL := MakeSQLByStr([
                SF('P_PValue', FPData.FValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_PMan', FIn.FBase.FFrom.FUser),
                SF('P_PStation', FPData.FStation),
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', DateTime2Str(FMData.FDate)),
                SF('P_MMan', FMData.FOperator),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //称重时,由于皮重大,交换皮毛重数据
      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //xxxxx
      end;

      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    FOut.FData := FPoundID;
    Result := True;
  end;
end;

//Date: 2016-02-24
//Parm: 物料编号[FIn.FData];预扣减量[FIn.ExtParam];
//Desc: 按规则生成指定品种的批次编号
function TWorkerBusinessCommander.GetStockBatcode(var nData: string): Boolean;
var nStr,nP: string;
    nNew: Boolean;
    nInt,nInc: Integer;
    nVal,nPer: Double;

    //生成新批次号
    function NewBatCode: string;
    begin
      nStr := 'Select * From %s Where B_Stock=''%s''';
      nStr := Format(nStr, [sTable_StockBatcode, FIn.FData]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      begin
        nP := FieldByName('B_Prefix').AsString;
        nStr := FieldByName('B_UseYear').AsString;

        if nStr = sFlag_Yes then
        begin
          nStr := Copy(Date2Str(Now()), 3, 2);
          nP := nP + nStr;
          //前缀后两位年份
        end;

        nStr := FieldByName('B_Base').AsString;
        nInt := FieldByName('B_Length').AsInteger;
        nInt := nInt - Length(nP + nStr);

        if nInt > 0 then
             Result := nP + StringOfChar('0', nInt) + nStr
        else Result := nP + nStr;

        nStr := '物料[ %s.%s ]将立即使用批次号[ %s ],请通知化验室确认已采样.';
        nStr := Format(nStr, [FieldByName('B_Stock').AsString,
                              FieldByName('B_Name').AsString, Result]);
        //xxxxx

        FOut.FBase.FErrCode := sFlag_ForceHint;
        FOut.FBase.FErrDesc := nStr;
      end;

      nStr := MakeSQLByStr([SF('B_Batcode', Result),
                SF('B_FirstDate', sField_SQLServer_Now, sfVal),
                SF('B_HasUse', 0, sfVal),
                SF('B_LastDate', sField_SQLServer_Now, sfVal)
                ], sTable_StockBatcode, SF('B_Stock', FIn.FData), False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;
begin
  Result := True;
  FOut.FData := '';
  
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_BatchAuto]);
  
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := Fields[0].AsString;
    if nStr <> sFlag_Yes then Exit;
  end  else Exit;
  //默认不使用批次号

  Result := False; //Init
  nStr := 'Select *,%s as ServerNow From %s Where B_Stock=''%s''';
  nStr := Format(nStr, [sField_SQLServer_Now, sTable_StockBatcode, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '物料[ %s ]未配置批次号规则.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    FOut.FData := FieldByName('B_Batcode').AsString;
    nInc := FieldByName('B_Incement').AsInteger;
    nNew := False;

    if FieldByName('B_UseDate').AsString = sFlag_Yes then
    begin
      nP := FieldByName('B_Prefix').AsString;
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime, False);

      nInt := FieldByName('B_Length').AsInteger;
      nInt := Length(nP + nStr) - nInt;

      if nInt > 0 then
      begin
        System.Delete(nStr, 1, nInt);
        FOut.FData := nP + nStr;
      end else
      begin
        nStr := StringOfChar('0', -nInt) + nStr;
        FOut.FData := nP + nStr;
      end;

      nNew := True;
    end;

    if (not nNew) and (FieldByName('B_AutoNew').AsString = sFlag_Yes) then      //元旦重置
    begin
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime);
      nStr := Copy(nStr, 1, 4);
      nP := Date2Str(FieldByName('B_LastDate').AsDateTime);
      nP := Copy(nP, 1, 4);

      if nStr <> nP then
      begin
        nStr := 'Update %s Set B_Base=1 Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, FIn.FData]);
        
        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
        nNew := True;
      end;
    end;

    if not nNew then //编号超期
    begin
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime);
      nP := Date2Str(FieldByName('B_FirstDate').AsDateTime);

      if (Str2Date(nP) > Str2Date('2000-01-01')) and
         (Str2Date(nStr) - Str2Date(nP) > FieldByName('B_Interval').AsInteger) then
      begin
        nStr := 'Update %s Set B_Base=B_Base+%d Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nInc, FIn.FData]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
        nNew := True;
      end;
    end;

    if not nNew then //编号超发
    begin
      nVal := FieldByName('B_HasUse').AsFloat + StrToFloat(FIn.FExtParam);
      //已使用+预使用
      nPer := FieldByName('B_Value').AsFloat * FieldByName('B_High').AsFloat / 100;
      //可用上限

      if nVal >= nPer then //超发
      begin
        nStr := 'Update %s Set B_Base=B_Base+%d Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nInc, FIn.FData]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
      end else
      begin
        nPer := FieldByName('B_Value').AsFloat * FieldByName('B_Low').AsFloat / 100;
        //提醒
      
        if nVal >= nPer then //超发提醒
        begin
          nStr := '物料[ %s.%s ]即将更换批次号,请通知化验室准备取样.';
          nStr := Format(nStr, [FieldByName('B_Stock').AsString,
                                FieldByName('B_Name').AsString]);
          //xxxxx

          FOut.FBase.FErrCode := sFlag_ForceHint;
          FOut.FBase.FErrDesc := nStr;
        end;
      end;
    end;
  end;

  if FOut.FData = '' then
    FOut.FData := NewBatCode;
  //xxxxx
  
  Result := True;
  FOut.FBase.FResult := True;
end;

{$IFDEF UseERP_K3}
//Date: 2014-10-14
//Desc: 同步新安中联客户数据到DL系统
function TWorkerBusinessCommander.SyncRemoteCustomer(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select S_Table,S_Action,S_Record,S_Param1,S_Param2,FItemID,' +
            'FName,FNumber,FEmployee From %s' +
            ' Left Join %s On FItemID=S_Record';
    nStr := Format(nStr, [sTable_K3_SyncItem, sTable_K3_Customer]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_K3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      try
        nStr := FieldByName('S_Action').AsString;
        //action

        if nStr = 'A' then //Add
        begin
          if FieldByName('FItemID').AsString = '' then Continue;
          //invalid

          nStr := MakeSQLByStr([SF('C_ID', FieldByName('FItemID').AsString),
                  SF('C_Name', FieldByName('FName').AsString),
                  SF('C_PY', GetPinYinOfStr(FieldByName('FName').AsString)),
                  SF('C_SaleMan', FieldByName('FEmployee').AsString),
                  SF('C_Memo', FieldByName('FNumber').AsString),
                  SF('C_Param', FieldByName('FNumber').AsString),
                  SF('C_XuNi', sFlag_No)
                  ], sTable_Customer, '', True);
          FListA.Add(nStr);

          nStr := MakeSQLByStr([SF('A_CID', FieldByName('FItemID').AsString),
                  SF('A_Date', sField_SQLServer_Now, sfVal)
                  ], sTable_CusAccount, '', True);
          FListA.Add(nStr);
        end else

        if nStr = 'E' then //edit
        begin
          if FieldByName('FItemID').AsString = '' then Continue;
          //invalid

          nStr := SF('C_ID', FieldByName('FItemID').AsString);
          nStr := MakeSQLByStr([
                  SF('C_Name', FieldByName('FName').AsString),
                  SF('C_PY', GetPinYinOfStr(FieldByName('FName').AsString)),
                  SF('C_SaleMan', FieldByName('FEmployee').AsString),
                  SF('C_Memo', FieldByName('FNumber').AsString)
                  ], sTable_Customer, nStr, False);
          FListA.Add(nStr);
        end else

        if nStr = 'D' then //delete
        begin
          nStr := 'Delete From %s Where C_ID=''%s''';
          nStr := Format(nStr, [sTable_Customer, FieldByName('S_Record').AsString]);
          FListA.Add(nStr);
        end;
      finally
        Next;
      end;
    end;

    if FListA.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;
      //开启事务
    
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
      FDBConn.FConn.CommitTrans;

      nStr := 'Delete From ' + sTable_K3_SyncItem;
      gDBConnManager.WorkerExec(nDBWorker, nStr);
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2014-10-14
//Desc: 同步新安中联业务员数据到DL系统
function TWorkerBusinessCommander.SyncRemoteSaleMan(var nData: string): Boolean;
var nStr,nDept: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nDept := '1356';
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_SaleManDept]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nDept := Fields[0].AsString;
      //销售部门编号
    end;

    nStr := 'Select FItemID,FName,FDepartmentID From t_EMP';
    //FDepartmentID='1356'为销售部门

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_K3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if Fields[2].AsString = nDept then
             nStr := sFlag_No
        else nStr := sFlag_Yes;
        
        nStr := MakeSQLByStr([SF('S_ID', Fields[0].AsString),
                SF('S_Name', Fields[1].AsString),
                SF('S_InValid', nStr)
                ], sTable_Salesman, '', True);
        //xxxxx
        
        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'Delete From ' + sTable_Salesman;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-10-14
//Desc: 同步新安中联供应商数据到DL系统
function TWorkerBusinessCommander.SyncRemoteProviders(var nData: string): Boolean;
var nStr,nSaler: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nSaler := '待分配业务员';
    nStr := 'Select FItemID,FName,FNumber From t_Supplier Where FDeleted=0';
    //未删除供应商

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_K3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('P_ID', Fields[0].AsString),
                SF('P_Name', Fields[1].AsString),
                SF('P_PY', GetPinYinOfStr(Fields[1].AsString)),
                SF('P_Memo', Fields[2].AsString),
                SF('P_Saler', nSaler)
                ], sTable_Provider, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;

    if FListA.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;
      //开启事务

      nStr := 'Delete From ' + sTable_Provider;
      gDBConnManager.WorkerExec(FDBConn, nStr);

      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
      FDBConn.FConn.CommitTrans;
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2014-10-14
//Desc: 同步新安中联原材料数据到DL系统
function TWorkerBusinessCommander.SyncRemoteMaterails(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select FItemID,FName,FNumber From t_ICItem ';// +
            //'Where (FFullName like ''%%原材料_主要材料%%'') or ' +
            //'(FFullName like ''%%原材料_燃料%%'')';
    //xxxxx

    {$IFDEF YNHT}
    nStr := nStr + ' Where FDeleted=0 and ' +
            '(FParentID=''3406'' or FParentID=''3408'' or ' +
            ' FParentID=''3410'' or FParentID=''27200'')';
    {$ENDIF}

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_K3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('M_ID', Fields[0].AsString),
                SF('M_Name', Fields[1].AsString),
                SF('M_PY', GetPinYinOfStr(Fields[1].AsString)),
                SF('M_Memo', GetPinYinOfStr(Fields[2].AsString))
                ], sTable_Materails, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'Delete From ' + sTable_Materails;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;


//Date: 2014-10-14
//Desc: 获取指定客户的可用金额
function TWorkerBusinessCommander.GetCustomerValidMoney(var nData: string): Boolean;
var nStr,nCusID: string;
    nUseCredit: Boolean;
    nVal,nCredit: Double;
    nDBWorker: PDBWorker;
begin
  Result := False;
  nUseCredit := False;
  
  if FIn.FExtParam = sFlag_Yes then
  begin
    nStr := 'Select MAX(C_End) From %s ' +
            'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
    nStr := Format(nStr, [sTable_CusCredit, FIn.FData, sFlag_Yes]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      nUseCredit := (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
                    (Fields[0].AsDateTime > Now());
    //信用未过期
  end;

  nStr := 'Select A_FreezeMoney,A_CreditLimit,C_Param From %s,%s ' +
          'Where A_CID=''%s'' And A_CID=C_ID';
  nStr := Format(nStr, [sTable_Customer, sTable_CusAccount, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的客户账户不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nCusID := FieldByName('C_Param').AsString;
    nVal := FieldByName('A_FreezeMoney').AsFloat;
    nCredit := FieldByName('A_CreditLimit').AsFloat;
  end;

  nDBWorker := nil;
  try
    nStr := 'DECLARE @return_value int, @Credit decimal(28, 10),' +
            '@Balance decimal(28, 10)' +
            'Execute GetCredit ''%s'' , @Credit output , @Balance output ' +
            'select @Credit as Credit , @Balance as Balance , ' +
            '''Return Value'' = @return_value';
    nStr := Format(nStr, [nCusID]);
    
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_K3) do
    begin
      if RecordCount < 1 then
      begin
        nData := 'K3数据库上编号为[ %s ]的客户账户不存在.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      nVal := -(FieldByName('Balance').AsFloat) - nVal;
      if nUseCredit then
      begin
        nCredit := FieldByName('Credit').AsFloat + nCredit;
        nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;
        nVal := nVal + nCredit;
      end;

      nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;
      FOut.FData := FloatToStr(nVal);
      FOut.FExtParam := FloatToStr(nCredit);
      Result := True;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2014-10-14
//Desc: 获取指定纸卡的可用金额
function TWorkerBusinessCommander.GetZhiKaValidMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nMoney: Double;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  nStr := 'Select Z_Customer,Z_OnlyMoney,Z_FixedMoney From $ZK ' +
          'Where Z_ID=''$ZID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ZID', FIn.FData)]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的纸卡不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nStr := FieldByName('Z_Customer').AsString;
    if not TWorkerBusinessCommander.CallMe(cBC_GetCustomerMoney, nStr,
       sFlag_Yes, @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    nVal := StrToFloat(nOut.FData);
    FOut.FExtParam := FieldByName('Z_OnlyMoney').AsString;
    nMoney := FieldByName('Z_FixedMoney').AsFloat;
                                
    if FOut.FExtParam = sFlag_Yes then
    begin
      if nMoney > nVal then
        nMoney := nVal;
      //enough money
    end else nMoney := nVal;

    FOut.FData := FloatToStr(nMoney);
    Result := True;
  end;
end;

//Date: 2014-10-15
//Parm: 交货单列表[FIn.FData]
//Desc: 同步交货单数据到K3系统
function TWorkerBusinessCommander.SyncRemoteStockBill(var nData: string): Boolean;
var nID,nIdx: Integer;
    nVal,nMoney: Double;
    nK3Worker: PDBWorker;
    nStr,nSQL,nBill,nStockID: string;
begin
  Result := False;
  nK3Worker := nil;
  nStr := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);

  nSQL := 'select L_ID,L_Truck,L_SaleID,L_CusID,L_StockNo,L_Value,' +
          'L_Seal,L_HYDan,L_Price,L_OutFact From $BL ' +
          'where L_ID In ($IN)';
  nSQL := MacroValue(nSQL, [MI('$BL', sTable_Bill) , MI('$IN', nStr)]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的交货单不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nK3Worker := gDBConnManager.GetConnection(sFlag_DB_K3, FErrNum);
    if not Assigned(nK3Worker) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not nK3Worker.FConn.Connected then
      nK3Worker.FConn.Connected := True;
    //conn db

    FListA.Clear;
    First;
    
    while not Eof do
    begin
      nSQL :='DECLARE @ret1 int, @FInterID int, @BillNo varchar(200) '+
            'Exec @ret1=GetICMaxNum @TableName=''%s'',@FInterID=@FInterID output '+
            'EXEC p_BM_GetBillNo @ClassType =21,@BillNo=@BillNo OUTPUT ' +
            'select @FInterID as FInterID , @BillNo as BillNo , ' +
            '''RetGetICMaxNum'' = @ret1';
      nSQL := Format(nSQL, ['ICStockBill']);
      //get FInterID, BillNo

      with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
      begin
        nBill := FieldByName('BillNo').AsString;
        nID := FieldByName('FInterID').AsInteger;
      end;

      {$IFDEF YNHT}
        nSQL := MakeSQLByStr([
          SF('Frob', 1, sfVal),
          SF('Fbrno', 0, sfVal),
          SF('Fbrid', 0, sfVal),

          SF('Fpoordbillno', ''),
          SF('Fstatus', 0, sfVal),
          SF('Fdate', Date2Str(Now)),

          SF('Ftrantype', 21, sfVal),
          SF('Fdeptid', 186, sfVal),

          SF('Frelatebrid', 0, sfVal),
          //SF('Fmanagetype', 0, sfVal),
          SF('Fvchinterid', 0, sfVal),

          SF('Fsalestyle', 101, sfVal),
          SF('Fseltrantype', 0, sfVal),

          SF('Fbillerid', 16559, sfVal),
          SF('Ffmanagerid', 36761, sfVal),
          SF('Fsmanagerid', 36761, sfVal),

          SF('Fupstockwhensave', 1, sfVal),
          SF('Fmarketingstyle', 12530, sfVal),

          SF('Fbillno', nBill),
          SF('Finterid', nID, sfVal),

          SF('Fheadselfb0144', 15263, sfVal),
          SF('Fheadselfb0146', FieldByName('L_Truck').AsString),

          SF('Fempid', FieldByName('L_SaleID').AsString, sfVal),
          SF('Fsupplyid', FieldByName('L_CusID').AsString, sfVal)
          ], 'ICStockBill', '', True);
        FListA.Add(nSQL);
      {$ELSE}
        {$IFDEF JYZL}
        nSQL := MakeSQLByStr([
          SF('Frob', 1, sfVal),
          SF('Fbrno', 0, sfVal),
          SF('Fbrid', 0, sfVal),

          SF('Fpoordbillno', ''),
          SF('Fstatus', 0, sfVal),
          SF('Fdate', Date2Str(Now)),

          SF('Ftrantype', 21, sfVal),
          SF('Fdeptid', 177, sfVal),
          SF('Fconsignee', 0, sfVal),

          SF('Frelatebrid', 0, sfVal),
          SF('Fmanagetype', 0, sfVal),
          SF('Fvchinterid', 0, sfVal),

          SF('Fsalestyle', 101, sfVal),
          SF('Fseltrantype', 0, sfVal),
          SF('Fsettledate', Date2Str(Now)),

          SF('Fbillerid', 16442, sfVal),
          SF('Ffmanagerid', 293, sfVal),
          SF('Fsmanagerid', 261, sfVal),

          SF('Fupstockwhensave', 0, sfVal),
          SF('Fmarketingstyle', 12530, sfVal),

          SF('Fbillno', nBill),
          SF('Finterid', nID, sfVal),

          SF('Fempid', FieldByName('L_SaleID').AsString, sfVal),
          SF('Fsupplyid', FieldByName('L_CusID').AsString, sfVal)
          ], 'ICStockBill', '', True);
        FListA.Add(nSQL);
        {$ELSE}
        nSQL := MakeSQLByStr([
          SF('Frob', 1, sfVal),
          SF('Fbrno', 0, sfVal),
          SF('Fbrid', 0, sfVal),

          SF('Fpoordbillno', ''),
          SF('Fstatus', 0, sfVal),
          SF('Fdate', Date2Str(Now)),

          SF('Ftrantype', 21, sfVal),
          SF('Fdeptid', 1356, sfVal),
          SF('Fconsignee', 0, sfVal),

          SF('Frelatebrid', 0, sfVal),
          SF('Fmanagetype', 0, sfVal),
          SF('Fvchinterid', 0, sfVal),

          SF('Fsalestyle', 101, sfVal),
          SF('Fseltrantype', 83, sfVal),
          SF('Fsettledate', Date2Str(Now)),

          SF('Fbillerid', 16394, sfVal),
          SF('Ffmanagerid', 1278, sfVal),
          SF('Fsmanagerid', 1279, sfVal),

          SF('Fupstockwhensave', 0, sfVal),
          SF('Fmarketingstyle', 12530, sfVal),

          SF('Fbillno', nBill),
          SF('Finterid', nID, sfVal),

          SF('Fempid', FieldByName('L_SaleID').AsString, sfVal),
          SF('Fsupplyid', FieldByName('L_CusID').AsString, sfVal)
          ], 'ICStockBill', '', True);
        FListA.Add(nSQL);
        {$ENDIF}
      {$ENDIF}

      //------------------------------------------------------------------------
      nVal := FieldByName('L_Value').AsFloat;
      nMoney := nVal * FieldByName('L_Price').AsFloat;
      nMoney := Float2Float(nMoney, cPrecision, True);

      {$IFDEF YNHT}
        nStr := FieldByName('L_StockNo').AsString;
        if nStr = '3396' then  //熟料
             nStockID := '3213'
        else nStockID := '3214';

        nSQL := MakeSQLByStr([
          SF('Fbrno', 0, sfVal),
          SF('Finterid', nID),
          SF('Fitemid', FieldByName('L_StockNo').AsString),
                                              
          SF('Fentryid', 1, sfVal),
          SF('Funitid', 64, sfVal),

          SF('Fdcspid', 0, sfVal),
          SF('Fsnlistid', 0, sfVal),
          SF('Fsourceentryid', 1, sfVal),

          SF('Forderbillno', FieldByName('L_ID').AsString),
          SF('Forderinterid', '0', sfVal),
          SF('Forderentryid', '0', sfVal),
          //订单编号

          SF('Fsourcebillno', '0'),
          SF('Fsourcetrantype', 0, sfVal),
          SF('Fsourceinterid', '0', sfVal),

          SF('Fqty',  nVal, sfVal),
          SF('Fauxqty', nVal, sfVal),
          SF('Fqtymust', nVal, sfVal),
          SF('Fauxqtymust', nVal, sfVal),

          {$IFDEF BatchInHYOfBill}
          SF('FEntrySelfB0155', FieldByName('L_HYDan').AsString),
          {$ELSE}
          SF('FEntrySelfB0155', FieldByName('L_Seal').AsString),
          {$ENDIF}
          //水泥出厂编号

          SF('Fconsignprice', FieldByName('L_Price').AsFloat , sfVal),
          SF('Fconsignamount', nMoney, sfVal),
          SF('fdcstockid', nStockID, sfVal)
          ], 'ICStockBillEntry', '', True);
        FListA.Add(nSQL);
      {$ELSE}
        {$IFDEF JYZL}
        nStr := FieldByName('L_StockNo').AsString;
        if nStr = '6053' then  //熟料
             nStockID := '322'
        else nStockID := '326';

        nSQL := MakeSQLByStr([
          SF('Fbrno', 0, sfVal),
          SF('Finterid', nID),
          SF('Fitemid', FieldByName('L_StockNo').AsString),
                                              
          SF('Fentryid', 1, sfVal),
          SF('Funitid', 132, sfVal),
          SF('Fplanmode', 14036, sfVal),

          SF('Fsourceentryid', 1, sfVal),
          SF('Fchkpassitem', 1058, sfVal),

          SF('Fseoutbillno', FieldByName('L_ID').AsString),
          SF('Fseoutinterid', '0', sfVal),
          SF('Fseoutentryid', '0', sfVal),

          SF('Fsourcebillno', '0'),
          SF('Fsourcetrantype', 83, sfVal),
          SF('Fsourceinterid', '0', sfVal),

          SF('Fqty',  nVal, sfVal),
          SF('Fauxqty', nVal, sfVal),
          SF('Fqtymust', nVal, sfVal),
          SF('Fauxqtymust', nVal, sfVal),

          SF('Fconsignprice', FieldByName('L_Price').AsFloat , sfVal),
          SF('Fconsignamount', nMoney, sfVal),
          SF('fdcstockid', nStockID, sfVal)
          ], 'ICStockBillEntry', '', True);
        FListA.Add(nSQL);
        {$ELSE}
        nStr := FieldByName('L_StockNo').AsString;
        if (nStr = '444') or (nStr = '1388') then  //熟料
             nStockID := '1731'
        else nStockID := '1730';

        nSQL := MakeSQLByStr([
          SF('Fbrno', 0, sfVal),
          SF('Finterid', nID),
          SF('Fitemid', FieldByName('L_StockNo').AsString),
                                              
          SF('Fentryid', 1, sfVal),
          SF('Funitid', 136, sfVal),
          SF('Fplanmode', 14036, sfVal),

          SF('Fsourceentryid', 1, sfVal),
          SF('Fchkpassitem', 1058, sfVal),

          SF('Fseoutbillno', '0'),
          SF('Fseoutinterid', '0', sfVal),
          SF('Fseoutentryid', '0', sfVal),

          SF('Fsourcebillno', '0'),
          SF('Fsourcetrantype', 83, sfVal),
          SF('Fsourceinterid', '0', sfVal),

          SF('Fentryselfb0166', FieldByName('L_ID').AsString),
          SF('Fentryselfb0167', FieldByName('L_Truck').AsString),
          SF('Fentryselfb0168', DateTime2Str(Now)),

          SF('Fqty',  nVal, sfVal),
          SF('Fauxqty', nVal, sfVal),
          SF('Fqtymust', nVal, sfVal),
          SF('Fauxqtymust', nVal, sfVal),

          SF('Fconsignprice', FieldByName('L_Price').AsFloat , sfVal),
          SF('Fconsignamount', nMoney, sfVal),
          SF('fdcstockid', nStockID, sfVal)
          ], 'ICStockBillEntry', '', True);
        FListA.Add(nSQL);
        {$ENDIF}
      {$ENDIF}

      Next;
      //xxxxx
    end;

    //----------------------------------------------------------------------------
    nK3Worker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nK3Worker, FListA[nIdx]);
      //xxxxx

      nK3Worker.FConn.CommitTrans;
      Result := True;
    except
      nK3Worker.FConn.RollbackTrans;
      nStr := '同步交货单数据到K3系统失败.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nK3Worker);
  end;
end;

//Date: 2014-10-15
//Parm: 采购单列表[FIn.FData]
//Desc: 同步采购单数据到K3系统
function TWorkerBusinessCommander.SyncRemoteStockOrder(var nData: string): Boolean;
var nID,nIdx: Integer;
    nVal: Double;
    nK3Worker: PDBWorker;
    nStr,nSQL,nBill,nStockID: string;
begin
  Result := False;
  nK3Worker := nil;

  nSQL := 'select O_ID,O_Truck,O_SaleID,O_ProID,O_StockNo,' +
          'D_ID, (D_MValue-D_PValue-D_KZValue) as D_Value,D_InTime, ' +
          'D_PValue, D_MValue, D_YSResult, D_KZValue ' +
          'From $OD od left join $OO oo on od.D_OID=oo.O_ID ' +
          'where D_ID=''$IN''';
  nSQL := MacroValue(nSQL, [MI('$OD', sTable_OrderDtl) ,
                            MI('$OO', sTable_Order),
                            MI('$IN', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的采购单不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    if FieldByName('D_YSResult').AsString=sFlag_No then
    begin          //拒收
      Result := True;
      Exit;
    end;  

    nK3Worker := gDBConnManager.GetConnection(sFlag_DB_K3, FErrNum);
    if not Assigned(nK3Worker) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not nK3Worker.FConn.Connected then
      nK3Worker.FConn.Connected := True;
    //conn db

    FListA.Clear;
    First;

    while not Eof do
    begin
      nSQL :='DECLARE @ret1 int, @FInterID int, @BillNo varchar(200) '+
            'Exec @ret1=GetICMaxNum @TableName=''%s'',@FInterID=@FInterID output '+
            'EXEC p_BM_GetBillNo @ClassType =1,@BillNo=@BillNo OUTPUT ' +
            'select @FInterID as FInterID , @BillNo as BillNo , ' +
            '''RetGetICMaxNum'' = @ret1';
      nSQL := Format(nSQL, ['ICStockBill']);
      //get FInterID, BillNo

      with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
      begin
        nBill := FieldByName('BillNo').AsString;
        nID := FieldByName('FInterID').AsInteger;
      end;

      {$IFDEF YNHT}
      nSQL := MakeSQLByStr([
          SF('Frob', 1, sfVal),
          SF('Fbrno', 0, sfVal),
          SF('Fbrid', 0, sfVal),

          SF('Ftrantype', 1, sfVal),
          SF('Fdate', Date2Str(Now)),

          SF('Fbillno', nBill),
          SF('Finterid', nID, sfVal),

          SF('Fdeptid', 191, sfVal),
          SF('FEmpid', 0, sfVal),
          SF('Fsupplyid', FieldByName('O_ProID').AsString, sfVal),
          //SF('FPosterid', FieldByName('O_SaleID').AsString, sfVal),
          //SF('FCheckerid', FieldByName('O_SaleID').AsString, sfVal),


          SF('Fbillerid', 36761, sfVal),
          SF('Ffmanagerid', 36761, sfVal),
          SF('Fsmanagerid', 36761, sfVal),

          SF('Fstatus', 0, sfVal),
          SF('Fvchinterid', 0, sfVal),

          //SF('Fconsignee', 0, sfVal),

          SF('Frelatebrid', 0, sfVal),
          SF('Fseltrantype', 0, sfVal),

          SF('Fupstockwhensave', 0, sfVal),
          SF('Fmarketingstyle', 12530, sfVal)
          ], 'ICStockBill', '', True);
      //  FListA.Add(nSQL);
      {$ELSE}
        {$IFDEF JYZL}
        nSQL := MakeSQLByStr([
          SF('Frob', 1, sfVal),
          SF('Fbrno', 0, sfVal),
          SF('Fbrid', 0, sfVal),

          SF('Ftrantype', 1, sfVal),
          SF('Fdate', Date2Str(Now)),

          SF('Fbillno', nBill),
          SF('Finterid', nID, sfVal),

          SF('Fdeptid', 0, sfVal),
          SF('FEmpid', 0, sfVal),
          SF('Fsupplyid', FieldByName('O_ProID').AsString, sfVal),
          //SF('FPosterid', FieldByName('O_SaleID').AsString, sfVal),
          //SF('FCheckerid', FieldByName('O_SaleID').AsString, sfVal),


          SF('Fbillerid', 16394, sfVal),
          SF('Ffmanagerid', 1789, sfVal),
          SF('Fsmanagerid', 1789, sfVal),

          SF('Fstatus', 0, sfVal),
          SF('Fvchinterid', 9662, sfVal),

          SF('Fconsignee', 0, sfVal),

          SF('Frelatebrid', 0, sfVal),
          SF('Fseltrantype', 0, sfVal),

          SF('Fupstockwhensave', 0, sfVal),
          SF('Fmarketingstyle', 12530, sfVal)
          ], 'ICStockBill', '', True);
        FListA.Add(nSQL);
        {$ELSE}
        nSQL := MakeSQLByStr([
          SF('Frob', 1, sfVal),
          SF('Fbrno', 0, sfVal),
          SF('Fbrid', 0, sfVal),

          SF('Ftrantype', 1, sfVal),
          SF('Fdate', Date2Str(Now)),

          SF('Fbillno', nBill),
          SF('Finterid', nID, sfVal),

          SF('Fdeptid', 0, sfVal),
          SF('FEmpid', 0, sfVal),
          SF('Fsupplyid', FieldByName('O_ProID').AsString, sfVal),
          //SF('FPosterid', FieldByName('O_SaleID').AsString, sfVal),
          //SF('FCheckerid', FieldByName('O_SaleID').AsString, sfVal),


          SF('Fbillerid', 16394, sfVal),
          SF('Ffmanagerid', 1789, sfVal),
          SF('Fsmanagerid', 1789, sfVal),

          SF('Fstatus', 0, sfVal),
          SF('Fvchinterid', 9662, sfVal),

          SF('Fconsignee', 0, sfVal),

          SF('Frelatebrid', 0, sfVal),
          SF('Fseltrantype', 0, sfVal),

          SF('Fupstockwhensave', 0, sfVal),
          SF('Fmarketingstyle', 12530, sfVal)
          ], 'ICStockBill', '', True);
        FListA.Add(nSQL);
        {$ENDIF}
      {$ENDIF}

      //------------------------------------------------------------------------
      nVal := FieldByName('D_Value').AsFloat;

      {$IFDEF YNHT}
        nStockID := FieldByName('O_StockNo').AsString;

      { nSQL := MakeSQLByStr([
          SF('Fbrno', 0, sfVal),
          SF('Finterid', nID),
          SF('Fitemid', nStockID),

          SF('Fqty',  nVal, sfVal),
          SF('Fauxqty', nVal, sfVal),
          SF('Fqtymust', 0, sfVal),
          SF('Fauxqtymust', 0, sfVal),

          SF('Fentryid', 1, sfVal),
          SF('Funitid', 64, sfVal),
          //SF('Fplanmode', 14036, sfVal),

          SF('Fsourceentryid', 0, sfVal),
          //SF('Fchkpassitem', 1058, sfVal),

          SF('Fsourcetrantype', 0, sfVal),
          SF('Fsourceinterid', '0', sfVal),

          SF('finstockid', '0', sfVal),
          SF('fdcstockid', '3211', sfVal),

          SF('FEntrySelfA0158', FieldByName('D_MValue').AsFloat, sfVal),
          SF('FEntrySelfA0159', FieldByName('D_PValue').AsFloat, sfVal),
          SF('FEntrySelfA0160', FieldByName('D_KZValue').AsFloat, sfVal),
          SF('FEntrySelfA0161', FieldByName('O_Truck').AsString),
          SF('FEntrySelfA0162', FieldByName('D_ID').AsString)
          ], 'ICStockBillEntry', '', True);
        FListA.Add(nSQL);  }
        nSQL := MakeSQLByStr([
          SF('FInTime', FieldByName('D_InTime').AsString),
          SF('FOutTime', sField_SQLServer_Now, sfVal),

          SF('FNO', nID),
          SF('FPrintNum', 1, sfVal),
          SF('FState', 3, sfVal),
          SF('FBillerID', 16559, sfVal),
          //DL系统

          SF('FRemark', FieldByName('D_ID').AsString),
          SF('FCarNO', FieldByName('O_Truck').AsString),
          SF('FSupplyID', FieldByName('O_ProID').AsString),
          SF('FICItemID', FieldByName('O_StockNo').AsString),


          SF('FTotal', Float2Float(FieldByName('D_MValue').AsFloat, 100, True) * 1000, sfVal),
          SF('FTruck', Float2Float(FieldByName('D_PValue').AsFloat, 100, True) * 1000, sfVal),
          SF('FNet', Float2Float(nVal, 100, True) * 1000, sfVal)
          ], 'A_BuyWeight', '', True);
        FListA.Add(nSQL);
      {$ELSE}
        {$IFDEF JYZL}
        nStockID := FieldByName('O_StockNo').AsString;

        nSQL := MakeSQLByStr([
          SF('Fbrno', 0, sfVal),
          SF('Finterid', nID),
          SF('Fitemid', nStockID),

          SF('Fqty',  nVal, sfVal),
          SF('Fauxqty', nVal, sfVal),
          SF('Fqtymust', 0, sfVal),
          SF('Fauxqtymust', 0, sfVal),

          SF('Fentryid', 1, sfVal),
          SF('Funitid', 136, sfVal),
          SF('Fplanmode', 14036, sfVal),

          SF('Fsourceentryid', 0, sfVal),
          SF('Fchkpassitem', 1058, sfVal),

          SF('Fsourcetrantype', 0, sfVal),
          SF('Fsourceinterid', '0', sfVal),

          SF('finstockid', '0', sfVal),
          SF('fdcstockid', '2071', sfVal),

          SF('FEntrySelfA0158', FieldByName('D_MValue').AsFloat, sfVal),
          SF('FEntrySelfA0159', FieldByName('D_PValue').AsFloat, sfVal),
          SF('FEntrySelfA0160', FieldByName('D_KZValue').AsFloat, sfVal),
          SF('FEntrySelfA0161', FieldByName('O_Truck').AsString),
          SF('FEntrySelfA0162', FieldByName('D_ID').AsString)
          ], 'ICStockBillEntry', '', True);
        FListA.Add(nSQL);
      {$ELSE}
        nStockID := FieldByName('O_StockNo').AsString;

        nSQL := MakeSQLByStr([
          SF('Fbrno', 0, sfVal),
          SF('Finterid', nID),
          SF('Fitemid', nStockID),

          SF('Fqty',  nVal, sfVal),
          SF('Fauxqty', nVal, sfVal),
          SF('Fqtymust', 0, sfVal),
          SF('Fauxqtymust', 0, sfVal),

          SF('Fentryid', 1, sfVal),
          SF('Funitid', 136, sfVal),
          SF('Fplanmode', 14036, sfVal),

          SF('Fsourceentryid', 0, sfVal),
          SF('Fchkpassitem', 1058, sfVal),

          SF('Fsourcetrantype', 0, sfVal),
          SF('Fsourceinterid', '0', sfVal),

          SF('finstockid', '0', sfVal),
          SF('fdcstockid', '2071', sfVal),

          SF('FEntrySelfA0158', FieldByName('D_MValue').AsFloat, sfVal),
          SF('FEntrySelfA0159', FieldByName('D_PValue').AsFloat, sfVal),
          SF('FEntrySelfA0160', FieldByName('D_KZValue').AsFloat, sfVal),
          SF('FEntrySelfA0161', FieldByName('O_Truck').AsString),
          SF('FEntrySelfA0162', FieldByName('D_ID').AsString)
          ], 'ICStockBillEntry', '', True);
        FListA.Add(nSQL);
        {$ENDIF}
      {$ENDIF}

      Next;
      //xxxxx
    end;

    //----------------------------------------------------------------------------
    nK3Worker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nK3Worker, FListA[nIdx]);
      //xxxxx

      nK3Worker.FConn.CommitTrans;
      Result := True;
    except
      nK3Worker.FConn.RollbackTrans;
      nStr := '同步采购单数据到K3系统失败.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nK3Worker);
  end;
end;

//Date: 2014-10-16
//Parm: 物料列表[FIn.FData]
//Desc: 验证物料是否允许发货.
function TWorkerBusinessCommander.IsStockValid(var nData: string): Boolean;
var nStr: string;
    nK3Worker: PDBWorker;
begin
  Result := True;
  nK3Worker := nil;
  try
    nStr := 'Select FItemID,FName from T_ICItem Where FDeleted=1';
    //sql
    
    with gDBConnManager.SQLQuery(nStr, nK3Worker, sFlag_DB_K3) do
    begin
      if RecordCount < 1 then Exit;
      //not forbid

      SplitStr(FIn.FData, FListA, 0, ',');
      First;

      while not Eof do
      begin
        nStr := Fields[0].AsString;
        if FListA.IndexOf(nStr) >= 0 then
        begin
          nData := '品种[ %s.%s ]已禁用,不能发货.';
          nData := Format(nData, [nStr, Fields[1].AsString]);

          Result := False;
          Exit;
        end;

        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nK3Worker);
  end;
end;   
{$ENDIF}

{$IFDEF UseK3SalePlan}
//Desc: 计划已使用
function TWorkerBusinessCommander.IsSalePlanUsed(const nInter, nEntry,
  nTruck: string): Boolean;
var nIdx: Integer;
begin
  Result := False;
  for nIdx:=Low(FSalePlans) to High(FSalePlans) do
   with FSalePlans[nIdx] do
    if (FInterID=nInter) and (FEntryID=nEntry) and (FTruck=nTruck) then
    begin
      Result := True;
      Exit;
    end;
  //xxxxx
end;

//Date: 2017-01-03
//Parm: 客户编号[FIn.FData]
//Desc: 读取客户的销售计划
function TWorkerBusinessCommander.GetSalePlan(var nData: string): Boolean;
var nIdx: Integer;
    nStr: string;
    nWorker: PDBWorker;
begin
  Result := False;
  nStr := 'select o.FBillNo,e.FInterID,e.FEntryID,i.FItemID as StockID,' +
          'i.FName as StockName,org.FItemID CusID,org.FName as CusName,' +
          'e.FQty as StockValue,e.FNote as Truck from SEOrderEntry e ' +
          '  left join SEOrder o on o.fInterID=e.fInterID' +
          '  left join t_Organization org on org.FItemID=o.FcustID' +
          '  left join t_ICItem i on i.FItemID=e.FItemID ' +
          'WHERE e.FDate>=%s-1 and o.FcustID=''%s'' and ' +
          '  o.FCancellation=0 and o.FStatus=1';
  nStr := Format(nStr, [sField_SQLServer_Now, FIn.FData]);

  nWorker := nil;
  try
    with gDBConnManager.SQLQuery(nStr, nWorker, sFlag_DB_K3) do
    begin
      if RecordCount < 1 then
      begin
        nData := '未找到该客户的销售计划';
        Exit;
      end;

      SetLength(FSalePlans, 0);
      FListC.Clear;
      First;

      while not Eof do
      begin
        FListC.Add(FieldByName('FInterID').AsString);
        Next;
      end;

      nStr := 'Delete From %s Where S_Date<%s-1';
      nStr := Format(nStr, [sTable_K3_SalePlan, sField_SQLServer_Now]);
      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr := 'Select * From %s Where S_InterID in (%s)';
      nStr := Format(nStr, [sTable_K3_SalePlan, CombinStr(FListC, ',', False)]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        SetLength(FSalePlans, RecordCount);
        nIdx := 0;
        First;

        while not Eof do
        begin
          with FSalePlans[nIdx] do
          begin
            FInterID := FieldByName('S_InterID').AsString;
            FEntryID := FieldByName('S_EntryID').AsString;
            FTruck := FieldByName('S_Truck').AsString;
          end;

          Inc(nIdx);
          Next;
        end;
      end;

      //------------------------------------------------------------------------
      FListA.Clear;
      FListB.Clear;
      First;

      while not Eof do
      try
        nStr := Trim(FieldByName('Truck').AsString);
        if nStr = '' then Continue;
        SplitStr(nStr, FListC, 0, ' ');

        for nIdx:=FListC.Count-1 downto 0 do
         if Trim(FListC[nIdx]) = '' then FListC.Delete(nIdx);
        //xxxxx

        if FListC.Count < 2 then Continue;
        if FListC.Count mod 2 <> 0 then Continue;
        //格式: 车牌 吨 车牌 吨

        nIdx:=0;
        while nIdx< FListC.Count do
        with FListB do
        begin
          if IsSalePlanUsed(FieldByName('FInterID').AsString,
             FieldByName('FEntryID').AsString, FListC[nIdx]) then
          begin
            Inc(nIdx, 2);
            Continue;
          end;

          Values['billno'] := FieldByName('FBillNo').AsString;
          Values['inter'] := FieldByName('FInterID').AsString;
          Values['entry'] := FieldByName('FEntryID').AsString;

          Values['id'] := FieldByName('StockID').AsString;
          Values['name'] := FieldByName('StockName').AsString;
          Values['truck'] := FListC[nIdx];
          Inc(nIdx);
          
          if IsNumber(FListC[nIdx], True) then
               Values['value'] := FListC[nIdx]
          else Values['value'] := '0';
          Inc(nIdx);

          FListA.Add(EncodeBase64(FListB.Text));
          //new item
        end;
      finally
        Next;
      end;

      Result := FListA.Count > 0;
      if Result then
           FOut.FData := EncodeBase64(FListA.Text)
      else nData := '找到销售计划,但车辆信息无效,有效格式: 车牌 吨 车牌 吨.';
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;
{$ENDIF}

{$IFDEF XzdERP_A3}
//date:2017-08-17
//desc:同步新中大ERPA3中的客户信息
function TWorkerBusinessCommander.SyncRemoteCustomer_zyw(
  var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select S_Table,S_Action,S_Record,S_Param1,S_Param2,' +
            'compno,saletype,compname,ocode,guid From %s' +
            ' Join %s On compno=S_Record';

    nStr := Format(nStr, [sTable_K3_SyncItem, sTable_A3_Customer]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_A3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      try
        nStr := FieldByName('S_Action').AsString;
        //action

        if nStr = 'A' then //Add
        begin
          if FieldByName('compno').AsString = '' then Continue;
                  
          nStr := MakeSQLByStr([SF('C_ID', FieldByName('compno').AsString),
                  SF('C_Name', FieldByName('compname').AsString),
                  SF('C_PY', GetPinYinOfStr(FieldByName('compname').AsString)),
                  SF('C_Memo', FieldByName('guid').AsString),
                  SF('C_Param', FieldByName('ocode').AsString),
                  SF('C_XuNi', sFlag_No)
                  ], sTable_Customer, '', True);
          FListA.Add(nStr);

          nStr := MakeSQLByStr([SF('A_CID', FieldByName('compno').AsString),
                  SF('A_Date', sField_SQLServer_Now, sfVal)
                  ], sTable_CusAccount, '', True);
                  
          FListA.Add(nStr);
        end
        else
        if nStr = 'E' then //edit
        begin
          if FieldByName('compno').AsString = '' then Continue;

          nStr := SF('C_ID', FieldByName('compno').AsString);
          nStr := MakeSQLByStr([
                  SF('C_Name', FieldByName('compname').AsString),
                  SF('C_PY', GetPinYinOfStr(FieldByName('compname').AsString)),
                  SF('C_Param', FieldByName('ocode').AsString),
                  SF('C_Memo', FieldByName('guid').AsString)
                  ], sTable_Customer, nStr, False);
                  
          FListA.Add(nStr);
        end
        else
        if nStr = 'D' then //delete
        begin
          nStr := 'Delete From %s Where C_ID=''%s''';
          nStr := Format(nStr, [sTable_Customer, FieldByName('compno').AsString]);
          FListA.Add(nStr);
        end;
      finally
        Next;
      end;
    end;

    if FListA.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;
      //开启事务

      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);

      FDBConn.FConn.CommitTrans;

      nStr := 'Delete From ' + sTable_K3_SyncItem +' where S_Table = ''%s''';
      nStr := Format(nStr,[sTable_A3_Customer]);
      gDBConnManager.WorkerExec(nDBWorker, nStr);
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//date:2017-08-17
//desc:同步新中大ERPA3中的物料信息
function TWorkerBusinessCommander.SyncRemoteMaterails_zyw(
  var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'select a.itemno,a.itemname,b.msname from itemdata a,msunit b where a.msunit=b.msunit '+
            ' and a.itemstatus=''03'' and prdclass like ''01%'' ';
            //03在用，02005产品大类，只同步建筑类

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_A3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('M_ID', Fieldbyname('itemno').AsString),
                SF('M_Name', Fieldbyname('itemname').AsString),
                SF('M_PY', GetPinYinOfStr(Fieldbyname('itemname').AsString)),
                SF('M_Unit', Fieldbyname('msname').AsString)
                ], sTable_Materails, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'Delete From ' + sTable_Materails;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//date:2017-08-17
//desc:同步新中大ERPA3中的供应商信息
function TWorkerBusinessCommander.SyncRemoteProviders_zyw(
  var nData: string): Boolean;
var nStr,nSaler: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nSaler := '待分配业务员';

    nStr := 'Select S_Table,S_Action,S_Record,S_Param1,S_Param2,' +
            'compno,ocode,compname,attr_id From %s' +
            ' Join %s On compno=S_Record';

    nStr := Format(nStr, [sTable_K3_SyncItem, sTable_A3_Provider]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_A3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      try
        nStr := FieldByName('S_Action').AsString;

        if nStr = 'A' then
        begin
          nStr := MakeSQLByStr([SF('P_ID', FieldByName('compno').AsString),
                SF('P_Name', FieldByName('compname').AsString),
                SF('P_PY', GetPinYinOfStr(FieldByName('compname').AsString)),
                SF('P_Memo', FieldByName('ocode').AsString),
                SF('P_Saler', nSaler)
                ], sTable_Provider, '', True);

          FListA.Add(nStr);
        end
        else
        if nStr = 'E' then
        begin
          if FieldByName('compno').AsString = '' then Continue;

          nStr := SF('P_ID', FieldByName('compno').AsString);
          nStr := MakeSQLByStr([
                  SF('P_Name', FieldByName('compname').AsString),
                  SF('P_PY', GetPinYinOfStr(FieldByName('compname').AsString)),
                  SF('P_Memo', FieldByName('ocode').AsString)
                  ], sTable_Provider, nStr, False);

          FListA.Add(nStr);
        end
        else
        if nStr = 'D' then
        begin
          nStr := 'Delete From %s Where P_ID=''%s''';
          nStr := Format(nStr, [sTable_Provider, FieldByName('compno').AsString]);
          FListA.Add(nStr);
        end;
      finally
        next;
      end;
    end;

    if FListA.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;
      //开启事务

      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);

      FDBConn.FConn.CommitTrans;

      nStr := 'Delete From ' + sTable_K3_SyncItem + ' where S_Table=''%s''';
      nStr := Format(nStr,[sTable_A3_Provider]);
      gDBConnManager.WorkerExec(nDBWorker, nStr);
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//2017-09-02
//新中大ERP取金额
function TWorkerBusinessCommander.GetCustomerValidMoney(
  var nData: string): Boolean;
var nStr,nCusID: string;
    nUseCredit: Boolean;
    nVal,nCredit: Double;
    nDBWorker: PDBWorker;
begin
  Result := False;
  nUseCredit := False;

  if FIn.FExtParam = sFlag_Yes then
  begin
    nStr := 'Select MAX(C_End) From %s ' +
            'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
    nStr := Format(nStr, [sTable_CusCredit, FIn.FData, sFlag_Yes]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      nUseCredit := (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
                    (Fields[0].AsDateTime > Now());
    //信用未过期
  end;

  nStr := 'Select A_FreezeMoney,A_CreditLimit,C_Param From %s,%s ' +
          'Where A_CID=''%s'' And A_CID=C_ID';
  nStr := Format(nStr, [sTable_Customer, sTable_CusAccount, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的客户账户不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nCusID := FieldByName('C_Param').AsString;
    nVal := FieldByName('A_FreezeMoney').AsFloat;
    nCredit := FieldByName('A_CreditLimit').AsFloat;
  end;

  nDBWorker := nil;
  try
    nStr :=
      'select sum(a) as Balance from( '+
      ' select (isnull(creditnum,0)-send_total)as a '+      ' from customfile where customfile.compno = ''%s''' +      ' union all ' +      ' Select Sum(lg_pgbody.locsum)as a From lg_pghead, lg_pgbody  '+      ' Where lg_pghead.sysno = lg_pgbody.sysno And compno =''%s'''+      ' And (billtype = ''01'' or billtype = ''02''  or billtype = ''05'' )'+      ' And lg_pghead.ischecked = 1 and lg_pghead.porg = ''1'''+      ' union all '+      ' Select -Sum(lg_pgbody.locsum)as a From lg_pghead, lg_pgbody '+      ' Where lg_pghead.sysno = lg_pgbody.sysno And compno = ''%s'''+      ' And (billtype = ''03'' or billtype = ''06'') And lg_pghead.ischecked = 1 and lg_pghead.porg = ''1'''+      ' union all '+      ' select -sum(locsum) as a from sbillmst where ischeck=0 and issend=1 and iscancell=0  and compno=''%s'''+      ' )as b' ;

    nStr := Format(nStr, [FIn.FData,FIn.FData,FIn.FData,FIn.FData]);
    
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_A3) do
    begin
      nVal := FieldByName('Balance').AsFloat - nVal;
      if nUseCredit then
      begin
        nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;
        nVal := nVal + nCredit;
      end;

      nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;
      FOut.FData := FloatToStr(nVal);
      FOut.FExtParam := FloatToStr(nCredit);
      Result := True;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2017-9-5
//Desc: 获取指定纸卡的可用金额，复制原来的K3里面的
function TWorkerBusinessCommander.GetZhiKaValidMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nMoney: Double;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  nStr := 'Select Z_Customer,Z_OnlyMoney,Z_FixedMoney From $ZK ' +
          'Where Z_ID=''$ZID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ZID', FIn.FData)]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的纸卡不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nStr := FieldByName('Z_Customer').AsString;
    if not TWorkerBusinessCommander.CallMe(cBC_GetCustomerMoney, nStr,
       sFlag_Yes, @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    nVal := StrToFloat(nOut.FData);
    FOut.FExtParam := FieldByName('Z_OnlyMoney').AsString;
    nMoney := FieldByName('Z_FixedMoney').AsFloat;
                                
    if FOut.FExtParam = sFlag_Yes then
    begin
      if nMoney > nVal then
        nMoney := nVal;
      //enough money
    end else nMoney := nVal;

    FOut.FData := FloatToStr(nMoney);
    Result := True;
  end;
end;

//2017-09-07
//同步交货单到新中大系统
function TWorkerBusinessCommander.SyncRemoteStockBill_zyw(
  var nData: string): Boolean;
var nID,nIdx: Integer;
    nStr,nSQL,nBill, nStrTax: string;
    nK3Worker, FDBConn_zyw: PDBWorker;
    nPrc, nQty, nSumMoney, nTax, nSumAfTax, nTaxSum, nPrcAfTax : Double;
    //单价,数量，总金额， 税率， 税后总额，  税额，  税后单价
begin
  Result := False;

  nK3Worker := nil;

  nStr := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);

  nSQL := 'select L_ID,L_Truck,L_SaleID,L_CusID,L_StockNo,L_Value,' +
          'L_Date,L_Man,L_Seal,L_HYDan,L_Price,L_OutFact,L_EmptyOut From $BL ' +
          'where L_ID In ($IN)';
  nSQL := MacroValue(nSQL, [MI('$BL', sTable_Bill), MI('$IN', nStr)]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的交货单不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    if FieldByName('L_EmptyOut').asstring = sFlag_Yes then
    begin
      nData := '编号为[ %s ]的交货单是空车出厂.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nK3Worker := gDBConnManager.GetConnection(sFlag_DB_A3, FErrNum);
    if not Assigned(nK3Worker) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not nK3Worker.FConn.Connected then
      nK3Worker.FConn.Connected := True;
    //conn db

    FListA.Clear;
    First;

    while not Eof do
    begin
      nSQL :='SELECT MAX(sysno) as sysno FROM sendmst WHERE sysno like ''Q'+FormatDateTime('yymmdd',Now)+'%''';
      //生成单号

      with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
      begin
        if FieldByName('sysno').AsString = '' then
        begin
          nBill := 'Q'+ formatdatetime('yymmdd',Now)+'0001';
        end
        else
        begin
          nBill := FieldByName('sysno').AsString;
          nID := StrToInt(Copy(nBill,8,4));
          Inc(nID);
          nBill := inttostr(nID);
          while Length(nBill) < 4 do
            nBill := '0' + nBill;
          nBill := 'Q' + FormatDateTime('yymmdd',Now) + nBill;
        end;
      end;

      FDBConn_zyw := nil;

      FDBConn_zyw := gDBConnManager.GetConnection(LocalDB_zyw, FErrNum);
      if not Assigned(FDBConn_zyw) then
      begin
        nData := '连接数据库失败(DBConn Is Null).';
        Exit;
      end;

      if not FDBConn_zyw.FConn.Connected then
        FDBConn_zyw.FConn.Connected := True;

      //nTax := 0.17;取nTax，取税率
      nSQL := 'select D_ParamA from Sys_Dict where D_ParamB='''+FieldByName('L_StockNo').asstring+'''';

      with gDBConnManager.WorkerQuery(FDBConn_zyw, nSQL) do
      begin
        nStrTax := Trim(FieldByName('D_ParamA').asstring);
        if nStrTax = '' then
          nTax := 0
        else
          nTax := strtofloat(nStrTax) ;
        //nTax := FieldByName('D_ParamA').asfloat;
      end;

      nPrc := FieldByName('L_Price').AsFloat;
      nQty := FieldByName('L_Value').AsFloat;
      nSumMoney := nPrc * nQty;
      nSumAfTax := nSumMoney / (1+nTax);
      nPrcAfTax := FieldByName('L_Price').AsFloat / (1+nTax);
      nTaxSum := nSumMoney - nSumAfTax;
      //sendmst，发货单主表
      nSQL := MakeSQLByStr([
                  SF('sysno',               nBill),
                  SF('carddt',              Now),
                  SF('saletype',            '03'),
                  SF('t_compno',            FieldByName('L_CusID').AsString),
                  SF('invo_type',           3),
                  SF('locsum',              nSumMoney),
                  SF('cardpsn',             FieldByName('L_Man').AsString),  //开单人
                  SF('ischeck',             0),
                  SF('istaken',             0),
                  SF('issend',              1),

                  SF('iscancell',           0),
                  SF('isprint',             0),
                  SF('isover',              0),
                  SF('deptno',              '27'), //部门
                  SF('empno',               FieldByName('L_SaleID').AsString),
                  SF('curstyle',            'CNY'),
                  SF('fc_locsum',           nSumMoney),
                  SF('invsum',              nSumMoney),
                  SF('fc_invsum',           nSumMoney),
                  SF('exgrate',             1),
                  SF('ismakeinv',           0),
                  SF('isfinish',            0),
                  SF('postsum',             0),
                  SF('fc_postsum',          0),
                  SF('ispost',              0),
                  SF('goodsto',             FieldByName('L_CusID').AsString), //发往单位
                  SF('billto',              FieldByName('L_CusID').AsString), //结算单位，存在不一样的情况
                  SF('isvcr',               0),
                  SF('ispond',              0),
                  SF('pondstate',           0),
                  SF('comptemp_id',         0),                               //临时客户ID
                  SF('plan_dt',             FieldByName('L_Date').AsDateTime),
                  SF('countday',            0),
                  SF('remarks',             FieldByName('L_ID').AsString),    //提货单号
                  SF('csaletype',           '03')                             //销售类型
                  ], 'sendmst',             '', True);

      FListA.Add(nSQL);

      //senddet,发货单从表
      nSQL := MakeSQLByStr([
                  SF('sysno',               nBill),
                  SF('lineid',              1),
                  SF('s_whouse',            '60'),                            //出货仓库
                  SF('itemno',              FieldByName('L_StockNo').AsString),
                  SF('ranks',               '01'),
                  SF('msunit',              '02'),
                  SF('qty',                 nQty),
                  SF('prc',                 nPrc),
                  SF('disc',                1),
                  SF('locsum',              nSumMoney),
                  SF('s_prc',               nPrc),
                  SF('curstyle',            'CNY'),
                  SF('exgrate',             1),
                  SF('fc_prc',              nPrc),
                  SF('fc_s_prc',            nPrc),
                  SF('fc_locsum',           nSumMoney),
                  SF('sellsum',             nSumMoney),
                  SF('freightsum',          nSumMoney),
                  SF('fc_freightsum',       nSumMoney),
                  SF('fc_sellsum',          nSumMoney),
                  SF('qty_pick',            nQty),
                  SF('inv_qty',             0),
                  SF('um_conv',             1),
                  SF('def_int1',            1),
                  SF('qty_a',               0),
                  SF('qty_pick_a',          nQty),
                  SF('inv_qty_a',           0),
                  SF('def_str2',            2),
                  SF('def_int2',            0),
                  SF('largs',               0),                               //赠品标记
                  SF('precardno',           ''),                              //上级单号，咱标记为空
                  //SF('id',                'NULL'),
                  SF('pondstate',           0),
                  SF('stdprc',              0),
                  SF('def_num3',            1),                               //有时为零，为1的时候较多，不知何意
                  //SF('def_num2',           ),                               //未弄清何意
                  SF('conlineid',           0),
                  SF('ref_qty',             nQty),                            //榜单参考数量,原ERP中大多不一致
                  SF('untaxprc',            nPrcAfTax),
                  SF('fc_untaxprc',         nPrcAfTax),
                  SF('untaxlocsum',         nSumAfTax),
                  SF('tax',                 nTax),
                  SF('fc_untaxlocsum',      nSumAfTax),
                  SF('fc_taxsum',           nTaxSum),
                  SF('taxsum',              nTaxSum),
                  SF('um_conv_a',           0),
                  SF('um_conv_am',          0),
                  SF('fc_prc_disc',         nPrc),
                  SF('remarks',             FieldByName('L_Truck').AsString),    //车牌
                  SF('attrvalid',           '*')
                  ], 'senddet', '',         True);

      FListA.Add(nSQL);

      //sbillmst，销售单主表
      nSQL := MakeSQLByStr([
                  SF('sysno',               nBill),
                  SF('carddt',              Now),//FieldByName('L_OutFact').AsDateTime),
                  SF('cardstyle',           3),     //销售清单类型，大部分时候是0，有时候是3，待定
                  SF('ismakeinv',           0),
                  SF('isfinish',            0),
                  SF('locsum',              nSumMoney),
                  SF('invsum',              nSumMoney),
                  SF('fc_invsum',           nSumMoney),
                  SF('fc_locsum',           nSumMoney),
                  SF('postsum',             0),
                  SF('fc_postsum',          0),
                  SF('compno',              FieldByName('L_CusID').AsString),
                  SF('decfcomp',            FieldByName('L_CusID').AsString),
                  SF('decfdept',            '27'), //部门
                  SF('empno',               FieldByName('L_SaleID').AsString),
                  SF('curstyle',            'CNY'),
                  SF('cardpsn',             FieldByName('L_Man').AsString),

                  SF('ischeck',             0),
                  SF('isprint',             0),
                  SF('istaken',             0),  //仓库取数标记，大部分是2，待定
                  SF('iscancell',           0),
                  SF('isover',              0),
                  SF('isflg',               0),
                  SF('ispost',              0),
                  SF('isvcr',               0),
                  SF('ispond',              0),
                  SF('issend',              1),

                  SF('precardno',           ''),   //相关的单据编号，待定
                  SF('saletype',            '03'), //03直销，02经销，大部分是03，待定
                  SF('exgrate',             1),
                  SF('goodsto',             FieldByName('L_CusID').AsString),
                  SF('billto',              FieldByName('L_CusID').AsString),
                  SF('comptemp_id',         0),
                  SF('plan_dt',             FieldByName('L_Date').AsDateTime),
                  SF('countday',            0),
                  SF('remarks',             FieldByName('L_ID').AsString),    //提货单号
                  SF('csaletype',           '03')  //03直销，02经销，大部分是03
                  ], 'sbillmst', '', True);

      FListA.Add(nSQL);

      //sbilldet，销售单从表
      nSQL := MakeSQLByStr([
                  SF('sysno',               nBill),
                  SF('lineid',              1),
                  SF('itemno',              FieldByName('L_StockNo').AsString),
                  SF('ranks',               '01'),
                  SF('msunit',              '02'),
                  SF('qty',                 nQty),
                  SF('inv_qty',             0),
                  SF('curstyle',            'CNY'),
                  SF('exgrate',             1),
                  SF('prc',                 nPrc),
                  SF('freightsum',          nSumMoney),
                  SF('sellsum',             nSumMoney),
                  SF('disc',                1),
                  //SF('def_num2',              ''),   //未弄清何意，待定
                  SF('def_int2',            0),        //大部分是0，少数是1，不知何意，待定
                  SF('fc_prc',              nPrc),
                  SF('fc_freightsum',       nSumMoney),
                  SF('fc_sellsum',          nSumMoney),
                  SF('fc_inv_sum',          0),
                  SF('qty_pick',            nQty),     //提货数量，原ERP存在不一致的情况，
                  SF('s_prc',               nPrc),
                  SF('fc_s_prc',            nPrc),
                  SF('um_conv',             1),
                  SF('def_int1',            1),
                  SF('qty_a',               0),
                  SF('inv_qty_a',           0),
                  SF('qty_pick_a',          nQty),
                  //SF('id',                  1),        //相关行号，大多是1，只有一条记录是2
                  SF('precardno',           ''),       //上级单号 ，暂且置空
                  SF('pondstate',           2),
                  SF('conlineid',           0),
                  SF('ref_qty',             nQty),     //榜单参考数量，存在不一致的情况
                  SF('taxsum',              nTaxSum),
                  SF('fc_taxsum',           nTaxSum),
                  SF('tax',                 nTax),
                  SF('fc_untaxlocsum',      nSumAfTax),
                  SF('untaxlocsum',         nSumAfTax),
                  SF('untaxprc',            nPrcAfTax),
                  SF('fc_untaxprc',         nPrcAfTax),
                  SF('um_conv_am',          0),
                  SF('um_conv_a',           0),
                  SF('s_whouse',            '60')
                  ], 'sbilldet', '',        True);

      FListA.Add(nSQL);
      
      Next;
      //xxxxx
    end;

    //----------------------------------------------------------------------------
    nK3Worker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nK3Worker, FListA[nIdx]);
      //xxxxx

      nK3Worker.FConn.CommitTrans;
      Result := True;
    except
      nK3Worker.FConn.RollbackTrans;
      nStr := '同步交货单数据到新中大A3系统失败.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nK3Worker);
    gDBConnManager.ReleaseConnection(FDBConn_zyw);
  end;
end;

//2017-09-07
//同步采购磅单到新中大系统
function TWorkerBusinessCommander.SyncRemoteStockOrder_zyw(
  var nData: string): Boolean;
var
  nK3Worker: PDBWorker;
  nSQL, nStr, nBill, nPcNum, nAppWatch, nPcNow, nO_BID, nO_ProID: string;
  nIdx, nID, nPcRule: Integer;
  nPrc, nValue, nSum: Double;
begin
  Result := False;
  nK3Worker := nil;

  nSQL := 'select O_ID,O_Truck,O_SaleID,O_ProID,O_StockNo,O_StockPrc,O_Date,O_Man,S_DepNo,O_BID,O_Value,' +
          ' D_ID, (D_MValue-D_PValue-isnull(D_KZValue,0)) as D_Value,D_InTime,D_PMan,D_MMan, ' +
          ' D_PValue, D_MValue, D_YSResult, D_KZValue,D_MDate,D_PDate ' +
          ' From $OD od , $OO oo, $SM sm ' +
          ' where od.D_OID=oo.O_ID and oo.O_SaleID=sm.S_ID and D_ID=''$IN''';
  nSQL := MacroValue(nSQL, [MI('$OD', sTable_OrderDtl) ,
                            MI('$OO', sTable_Order),
                            MI('$SM', sTable_Salesman),
                            MI('$IN', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的采购单不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    if FieldByName('D_YSResult').AsString=sFlag_No then
    begin          //拒收
      Result := True;
      Exit;
    end;  

    nK3Worker := gDBConnManager.GetConnection(sFlag_DB_A3, FErrNum);
    if not Assigned(nK3Worker) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not nK3Worker.FConn.Connected then
      nK3Worker.FConn.Connected := True;
    //conn db

    FListA.Clear;
    First;

    while not Eof do
    begin
      nO_BID := FieldByName('O_BID').asstring;
      nO_ProID := FieldByName('O_ProID').asstring;

      //生成采购验收批次号
      nSQL := 'select swatchnum from itemproperty_lg where itemno = '''+
              FieldByName('O_StockNo').AsString+''' and autoswatch = ''1''';
      with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
      begin
        if recordcount = 0 then
        begin
          nPcNum := '';
          nAppWatch := '';
        end
        else
        begin
          nPcRule := fieldbyname('swatchnum').asinteger;

          //取该采购订单，该供应商，当天最大检验号
          nSQL := 'select max(swatchno) from poundmst,pounddet where poundmst.sysno = pounddet.sysno '+
              ' and poundmst.precardno = '''+ nO_BID+''' and pounddet.refrow = 1 '+
              ' and poundmst.trans_comp = '''+nO_ProID+''' and poundmst.carddt = '''+
              FormatDateTime('yyyy-mm-dd 00:00:00',Now)+''' and poundmst.isreceive <> 1 ';
          with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
          begin
            if Fields[0].AsString ='' then       //该采购订单，该供应商，当天最大检验号为空，则查询当天的最大批次号
            begin
              nSQL := 'select max(swatchno) from poundmst where poundmst.carddt ='''+FormatDateTime('yyyy-mm-dd 00:00:00',Now)+'''';
              with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
              begin
                if Fields[0].AsString ='' then   //为空则从001开始
                begin
                  nPcNum := '001';
                  nAppWatch := formatdatetime('yymmdd',date)+nPcNum ;
                end
                else
                begin                            //不为空则当天最大批次号+1
                  nPcNow := fields[0].asstring;
                  nIdx := strtoint(nPcNow);
                  Inc(nIdx);
                  nPcNum := inttostr(nIdx);
                  while Length(nPcNum) < 3 do
                    nPcNum := '0' + nPcNum;
                  nAppWatch := formatdatetime('yymmdd',date)+nPcNum ;
                end;
              end;
            end
            else
            begin                                //该供应商，该采购订单，当天最大检验号不为空，则根据检验规则查看是否需要生成新的
              nPcNow := fields[0].asstring;
              nSQL := ' select count(swatchno) from poundmst,pounddet where poundmst.sysno = pounddet.sysno '+
              ' and poundmst.precardno = '''+ nO_BID +''' and pounddet.refrow = 1 '+
              ' and poundmst.trans_comp = '''+ nO_ProID +
              ''' and poundmst.carddt = '''+FormatDateTime('yyyy-mm-dd 00:00:00',Now)+
              ''' and poundmst.isreceive <> 1  and swatchno = '''+ nPcNow+'''';

              with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
              begin
                if fields[0].asinteger >= nPcRule then
                begin
                  nSQL := 'select max(swatchno) from poundmst where poundmst.carddt ='''+FormatDateTime('yyyy-mm-dd 00:00:00',Now)+'''';
                  with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
                  begin
                    if Fields[0].AsString ='' then
                    begin
                      nPcNum := '001';
                      nAppWatch := formatdatetime('yymmdd',date)+nPcNum ;
                    end
                    else
                    begin
                      nPcNow := fields[0].asstring;
                      nIdx := strtoint(nPcNow);
                      Inc(nIdx);
                      nPcNum := inttostr(nIdx);
                      while Length(nPcNum) < 3 do
                        nPcNum := '0' + nPcNum;
                      nAppWatch := formatdatetime('yymmdd',date)+nPcNum ;
                    end;
                  end;
                end
                else
                begin
                  nPcNum := nPcNow;
                  nAppWatch := formatdatetime('yymmdd',date)+nPcNum ;
                end;
              end;
            end;
          end;
        end;
      end;

      //生成单号
      nSQL :='SELECT MAX(sysno) as sysno FROM poundmst WHERE sysno like ''PD'+FormatDateTime('yymmdd',Now)+'%''';
      with gDBConnManager.WorkerQuery(nK3Worker, nSQL) do
      begin
        if FieldByName('sysno').AsString = '' then
        begin
          nBill := 'PD' + formatdatetime('yymmdd',Now) + '0001';
        end
        else
        begin
          nBill := FieldByName('sysno').AsString;
          nID := StrToInt(Copy(nBill,9,4));
          Inc(nID);
          nBill := inttostr(nID);
          while Length(nBill) < 4 do
            nBill := '0' + nBill;
          nBill := 'PD' + FormatDateTime('yymmdd',Now) + nBill;
          
        end;
      end;

      nPrc := FieldByName('O_StockPrc').AsFloat;
      nValue := FieldByName('D_Value').AsFloat;
      nSum := nPrc * nValue;

      //poundmst，采购 磅单 主表
      nSQL := MakeSQLByStr([
                    SF('sysno',                nBill),
                    SF('precardno',            FieldByName('O_BID').AsString),
                    SF('carddt',               FormatDateTime('yyyy-mm-dd 00:00:00',FieldByName('O_Date').AsDateTime)),
                    SF('whdt',                 FormatDateTime('yyyy-mm-dd 00:00:00',FieldByName('O_Date').AsDateTime)),
                    SF('poundtype',            '4'),
                    SF('deptno',               FieldByName('S_DepNo').AsString),
                    SF('empno',                FieldByName('O_SaleID').AsString),
                    SF('s_compno',             FieldByName('O_ProID').AsString),
                    SF('trans_comp',           FieldByName('O_ProID').AsString),
                    SF('trans_num',            FieldByName('O_Truck').AsString),
                    SF('curstyle',             'CNY'),
                    SF('locsum',               nSum),
                    SF('cardpsn',              FieldByName('D_PMan').AsString),
                    SF('ischeck',              '1'),
                    SF('checkpsn',             FieldByName('D_MMan').AsString),
                    SF('iscancell',            '0'),
                    SF('isclose',              '0'),
                    SF('isprint',              '0'),
                    SF('fc_locsum',            nSum),
                    SF('exgrate',              1),
                    SF('pdstand',              '10'),    //磅站
                    SF('isreceive',            ''),     //是否已开检验计划
                    SF('appswatchno',          nAppWatch),
                    SF('remarks',              FieldByName('O_ID').AsString),
                    SF('swatchno',             nPcNum)
                    ], 'poundmst',      '',    True);

      FListA.Add(nSQL);

      //pounddet，采购 磅单 从表
      nSQL := MakeSQLByStr([
                    SF('sysno',                nBill),
                    SF('lineid',               1),
                    SF('itemno',               FieldByName('O_StockNo').AsString),
                    SF('ranks',                '01'),
                    SF('msunit',               '02'),
                    SF('qty',                  FieldByName('D_Value').AsFloat),
                    SF('curstyle',             'CNY'),
                    SF('exgrate',              1),
                    SF('prc',                  FieldByName('O_StockPrc').AsFloat),
                    SF('locsum',               nSum),
                    SF('weight_gross',         FieldByName('D_MValue').AsFloat),
                    SF('weight_tare',          FieldByName('D_PValue').AsFloat),
                    SF('weight_net',           FieldByName('D_Value').AsFloat),
                    SF('weight_deduct',        FieldByName('D_KZValue').AsFloat),

                    SF('precardno',            FieldByName('O_BID').AsString),
                    SF('fc_prc',               nPrc),
                    SF('fc_locsum',            nSum),
                    SF('um_conv',              1),
                    SF('qty_a',                nValue),
                    SF('largs',                0),
                    SF('grossdtm',             FieldByName('D_MDate').AsDateTime),
                    SF('taredtm',              FieldByName('D_PDate').AsDateTime),
                    SF('inflag',               0),
                    SF('um_conv_a',            0),
                    SF('refrow',               1),
                    SF('um_conv_am',           FieldByName('O_Value').AsFloat)
                    ], 'pounddet',      '',    True);

      FListA.Add(nSQL);

      Next;
      //xxxxx
    end;

    //----------------------------------------------------------------------------
    nK3Worker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nK3Worker, FListA[nIdx]);
      //xxxxx

      nK3Worker.FConn.CommitTrans;
      Result := True;
    except
      nK3Worker.FConn.RollbackTrans;
      nStr := '同步采购单数据到A3系统失败.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nK3Worker);
  end;
end;

//date:2017-9-11
//desc:同步新中大ERPA3中的销售员信息
function TWorkerBusinessCommander.SyncRemoteSaleMan_zyw(
  var nData: string): Boolean;
var nStr,nDept: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nDept := '27';
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_SaleManDept]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nDept := Fields[0].AsString;
      //销售部门编号
    end;

    nStr := 'select empno,lastname,deptno from employee';
    //deptno='27'为销售部门

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_A3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if Fields[2].AsString = nDept then
             nStr := sFlag_No
        else nStr := sFlag_Yes;
        
        nStr := MakeSQLByStr([SF('S_ID', Fields[0].AsString),
                SF('S_Name', Fields[1].AsString),
                SF('S_PY', GetPinYinOfStr(Fields[1].AsString)),
                SF('S_DepNo', Fields[2].AsString),
                SF('S_InValid', nStr)
                ], sTable_Salesman, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'Delete From ' + sTable_Salesman;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;
{$ENDIF}

//Date: 2016-09-20
//Parm: 防伪码[FIn.FData]
//Desc: 防伪码校验
function TWorkerBusinessCommander.CheckSecurityCodeValid(var nData: string): Boolean;
var
  nStr,nCode,nBill_id: string;
  nSprefix:string;
  nIdx,nIdlen:Integer;
  nDs:TDataSet;
  nBills: TLadingBillItems;
begin
  nSprefix := '';
  nidlen := 0;
  Result := True;
  nCode := FIn.FData;
  if nCode='' then
  begin
    nData := '';
    FOut.FData := nData;
    Exit;
  end;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_BillNo]);
  nDs :=  gDBConnManager.WorkerQuery(FDBConn, nStr);

  if nDs.RecordCount>0 then
  begin
    nSprefix := nDs.FieldByName('B_Prefix').AsString;
    nIdlen := nDs.FieldByName('B_IDLen').AsInteger;
    nIdlen := nIdlen-length(nSprefix);
  end;

  //生成提货单号
  nBill_id := nSprefix+Copy(nCode, 1, 6) + //YYMMDD
              Copy(nCode, 12, Length(nCode) - 11); //XXXX  
  {$IFDEF CODECOMMON}
  //生成提货单号
  nBill_id := nSprefix+Copy(nCode, 1, 6) + //YYMMDD
              Copy(nCode, 12, Length(nCode) - 11); //XXXX
  {$ENDIF}

  {$IFDEF CODEAREA}
  //生成提货单号
  nBill_id := nSprefix+Copy(nCode, 1, nIdlen); //YYMMDDXXXX
  {$ENDIF}

  {$IFDEF CODEBATCODE}
  //生成提货单号
  nBill_id := nSprefix+Copy(nCode, 1, nIdlen); //YYMMDDXXXX
  {$ENDIF}


  //查询数据库
  nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
      'L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
      'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue,l_project,l_area,'+
      'l_workaddr,l_transname,l_hydan,l_outfact From $Bill b ';
  nStr := nStr + 'Where L_ID=''$CD''';
  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', nBill_id)]);

  nDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
  if nDs.RecordCount<1 then
  begin
    SetLength(nBills, 1);
    ZeroMemory(@nBills[0],0);
    FOut.FData := CombineBillItmes(nBills);
    Exit;
  end;

  SetLength(nBills, nDs.RecordCount);
  nIdx := 0;
  nDs.First;
  while not nDs.eof do
  begin
    with  nBills[nIdx] do
    begin
      FID         := nDs.FieldByName('L_ID').AsString;
      FZhiKa      := nDs.FieldByName('L_ZhiKa').AsString;
      FCusID      := nDs.FieldByName('L_CusID').AsString;
      FCusName    := nDs.FieldByName('L_CusName').AsString;
      FTruck      := nDs.FieldByName('L_Truck').AsString;

      FType       := nDs.FieldByName('L_Type').AsString;
      FStockNo    := nDs.FieldByName('L_StockNo').AsString;
      FStockName  := nDs.FieldByName('L_StockName').AsString;
      FValue      := nDs.FieldByName('L_Value').AsFloat;
      FPrice      := nDs.FieldByName('L_Price').AsFloat;

      FCard       := nDs.FieldByName('L_Card').AsString;
      FIsVIP      := nDs.FieldByName('L_IsVIP').AsString;
      FStatus     := nDs.FieldByName('L_Status').AsString;
      FNextStatus := nDs.FieldByName('L_NextStatus').AsString;
      FSelected := True;
      if FIsVIP = sFlag_TypeShip then
      begin
        FStatus    := sFlag_TruckZT;
        FNextStatus := sFlag_TruckOut;
      end;

      if FStatus = sFlag_BillNew then
      begin
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;
      end;

      FPData.FValue := nDs.FieldByName('L_PValue').AsFloat;
      FMData.FValue := nDs.FieldByName('L_MValue').AsFloat;

      FProject := nDs.FieldByName('l_project').AsString;
      FArea := nDs.FieldByName('l_area').AsString;
      Fhydan := nDs.FieldByName('l_hydan').AsString;
      Foutfact := nDs.FieldByName('l_outfact').AsDateTime;
    end;

    Inc(nIdx);
    nDs.Next;
  end;

  FOut.FData := CombineBillItmes(nBills);
end;

//Date: 2016-09-20
//Parm: 
//Desc: 工厂待装查询
function TWorkerBusinessCommander.GetWaitingForloading(var nData: string):Boolean;
var nFind: Boolean;
    nLine: PLineItem;
    nIdx,nInt, i: Integer;
    nQueues: TQueueListItems;
begin
  gTruckQueueManager.RefreshTrucks(True);
  Sleep(320);
  //刷新数据

  with gTruckQueueManager do
  try
    SyncLock.Enter;
    Result := True;

    FListB.Clear;
    FListC.Clear;

    i := 0;
    SetLength(nQueues, 0);
    //保存查询记录

    for nIdx:=0 to Lines.Count - 1 do
    begin
      nLine := Lines[nIdx];
      if not nLine.FIsValid then Continue;
      //通道无效

      nFind := False;
      for nInt:=Low(nQueues) to High(nQueues) do
      begin
        with nQueues[nInt] do
        if FStockNo = nLine.FStockNo then
        begin
          Inc(FLineCount);
          FTruckCount := FTruckCount + nLine.FRealCount;

          nFind := True;
          Break;
        end;
      end;

      if not nFind then
      begin
        SetLength(nQueues, i+1);
        with nQueues[i] do
        begin
          FStockNO    := nLine.FStockNo;
          FStockName  := nLine.FStockName;

          FLineCount  := 1;
          FTruckCount := nLine.FRealCount;
        end;

        Inc(i);
      end;
    end;

    for nIdx:=Low(nQueues) to High(nQueues) do
    begin
      with FListB, nQueues[nIdx] do
      begin
        Clear;

        Values['StockName'] := FStockName;
        Values['LineCount'] := IntToStr(FLineCount);
        Values['TruckCount']:= IntToStr(FTruckCount);
      end;

      FListC.Add(PackerEncodeStr(FListB.Text));
    end;

    FOut.FData := PackerEncodeStr(FListC.Text);
  finally
    SyncLock.Leave;
  end;
end;

//Date: 2016-09-23
//Parm:
//Desc: 网上订单可下单数量查询
function TWorkerBusinessCommander.GetBillSurplusTonnage(var nData:string):boolean;
var nStr,nCusID: string;
    nVal,nCredit,nPrice: Double;
    nStockNo:string;
begin
  nCusID := '';
  nStockNo := '';
  nPrice := 1;
  nCredit := 0;
  nVal := 0;
  Result := False;
  nCusID := Fin.FData;
  if nCusID='' then Exit;  
  //未传递客户号

  nStockNo := Fin.FExtParam;
  if nStockNo='' then Exit;
  //未传递产品编号

  //产品销售价格表擦查询单价
  nStr := 'select p_price from %s where P_StockNo=''%s'' order by P_Date desc';
  //nStr := Format(nStr, [sTable_SPrice, nStockNo]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '未设单价，查询失败!';
      Exit;
    end;
    nPrice := FieldByName('p_price').AsFloat;
    if Float2PInt(nPrice, 100000, False)<=0 then
    begin
      nData := '单价设置不正确，查询失败!';
      Exit;    
    end;
  end;

  //调用GetCustomerValidMoney查询可用金额
  Result := GetCustomerValidMoney(nData);
  if not Result then Exit;
  nVal := StrToFloat(FOut.FData);
  if Float2PInt(nVal, cPrecision, False)<=0 then
  begin
    nData := '编号为[ %s ]的客户账户可用金额不足.';
    nData := Format(nData, [nCusID]);
    Exit;
  end;
  FOut.FData := FormatFloat('0.0000',nVal/nPrice);
  Result := True;  
end;

//获取订单信息，用于网上下单
function TWorkerBusinessCommander.GetOrderInfo(var nData:string):Boolean;
var nList: TStrings;
    nOut: TWorkerBusinessCommand;
    nCard,nParam:string;
    nLoginAccount,nLoginCusId,nOrderCusId:string;
    nSql:string;
    nDataSet:TDataSet;
    nOrderValid:Boolean;
begin
  nCard := fin.FData;
  nLoginAccount := FIn.FExtParam;
  nList := TStringList.Create;
  try
    nList.Text := PackerDecodeStr(nOut.FData);
    nCard := nList[0];
    //cBC_ReadYTCard读取指令允许读取多条,取第一条
  finally
    nList.Free;
  end;

  FOut.FData := nCard;

  //------防伪校验begin-------
  nList := TStringList.Create;
  try
    nList.Text := PackerDecodeStr(nCard);
    nOrderCusId := nList.Values['XCB_Client'];
  finally
    nList.Free;
  end;

  nSql := 'select i_itemid from %s where i_group=''%s'' and i_item=''%s'' and i_info=''%s''';
  nSql := Format(nSql,[sTable_ExtInfo,sFlag_CustomerItem,'手机',nLoginAccount]);

  nDataSet := gDBConnManager.WorkerQuery(FDBConn, nSql);
  //未找到注册的手机号
  if nDataSet.RecordCount<1 then
  begin
    nData := '未找到注册的手机号码';
    nout.FBase.FErrDesc := nData;  
    Result := False;
    Exit;
  end;

  nOrderValid := False;
    
  while not nDataSet.Eof do
  begin
    nLoginCusId := nDataSet.FieldByName('i_itemid').AsString;
    if nLoginCusId=nOrderCusId then
    begin
      nOrderValid := True;
      Break;
    end;
    nDataSet.Next;
  end;

  if not nOrderValid then
  begin
    nData := '请勿冒用其他客户的订单号.';
    nout.FBase.FErrDesc := nData;  
    Result := False;
    Exit;  
  end;
  //------防伪校验end-------
end;

//获取订单列表，用于网上下单
function TWorkerBusinessCommander.GetOrderList(var nData:string):Boolean;
var
  nCusId,nStr,nMOney:string;
begin
  Result := False;
  nCusId := Trim(fin.FData);
  if nCusId='' then Exit;

  nMOney := '0';
  if GetCustomerValidMoney(nCusId) then
    nMoney := FOut.FData;

  nStr := 'select b.R_ID,' +
        '  D_ZID,' +                            //销售卡片编号
        '  D_Type,' +                           //类型(袋,散)
        '  D_StockNo,' +                        //水泥编号
        '  D_StockName,' +                      //水泥名称
        '  D_Price,' +                          //单价
        '  Z_Man,' +                            //创建人
        '  Z_Date,' +                           //创建日期
        '  Z_Customer,' +                       //客户编号
        '  Z_Name,' +                           //客户名称
        '  Z_Lading,' +                         //提货方式
        '  Z_CID,' +                            //合同编号
        '  Z_AreaCode,' +                       //销售区域编码
        '  Z_OnlyMoney,' +                      //纸卡是否限额
        '  Z_FixedMoney,' +                     //纸卡可提额度
        '  C_Name ' +                           //客户名
        ' from %s a join %s b on a.Z_ID = b.D_ZID join s_customer c on a.Z_Customer=c.C_ID ' +
        ' where (Z_Freeze<>''Y'' or Z_Freeze is null) '+
        ' and (Z_InValid<>''Y'' or Z_InValid is null) and Z_Customer=''%s'' ';
        //订单剩余量大于0、未结订单、订单行未停止状态

  nStr := Format(nStr,[sTable_ZhiKa,sTable_ZhiKaDtl,nCusId]);
  //WriteLog(nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('未查询到客户编号[ %s ]对应的订单信息.', [nCusId]);
      Exit;
    end;

    FListA.Clear;
    FListB.Clear;
    First;

    while not Eof do
    begin
      FListB.Values['XCB_ID']         := FieldByName('R_ID').AsString;
      FListB.Values['XCB_CardId']     := FieldByName('D_ZID').AsString+';'+FieldByName('R_ID').AsString;
      FListB.Values['XCB_Origin']     := '';
      FListB.Values['XCB_BillID']     := FieldByName('Z_CID').AsString;
      FListB.Values['XCB_SetDate']    := Date2Str(FieldByName('Z_Date').AsDateTime,True);
      FListB.Values['XCB_CardType']   := '';
      FListB.Values['XCB_SourceType'] := '';
      FListB.Values['XCB_Option']     := '';

      FListB.Values['XCB_Client']     := FieldByName('Z_Customer').AsString;
      FListB.Values['XCB_ClientName'] := FieldByName('C_Name').AsString;
      FListB.Values['XCB_Area']       := FieldByName('Z_AreaCode').AsString;

      FListB.Values['XCB_WorkAddr']   := '';
      FListB.Values['XCB_Alias']      := '';
      FListB.Values['XCB_OperMan']    := '';

      if FieldByName('Z_OnlyMoney').AsString = sFlag_Yes then
      begin
        if FieldByName('Z_FixedMoney').AsFloat > StrtoFloat(nMoney) then
          FListB.Values['XCB_RemainNum']  := FloatToStr(StrtoFloat(nMoney)/ FieldByName('D_Price').AsFloat)
        else
          FListB.Values['XCB_RemainNum']  := FloatToStr(FieldByName('Z_FixedMoney').AsFloat/ FieldByName('D_Price').AsFloat);
      end
      else
        FListB.Values['XCB_RemainNum']  := FloatToStr(StrtoFloat(nMoney) / FieldByName('D_Price').AsFloat);


      FListB.Values['XCB_Cement']     := FieldByName('D_StockNo').AsString+UpperCase(FieldByName('D_Type').AsString);
      if UpperCase(FieldByName('D_Type').AsString) = 'D' then
        FListB.Values['XCB_CementName'] := FieldByName('D_StockName').AsString +'袋装'
      else
        FListB.Values['XCB_CementName'] := FieldByName('D_StockName').AsString +'散装';
      FListB.Values['XCB_LadeType']   := FieldByName('Z_Lading').AsString;
      FListB.Values['XCB_Number']     := '0';
      FListB.Values['XCB_FactNum']    := '0';
      FListB.Values['XCB_PreNum']     := '0';
      FListB.Values['XCB_ReturnNum']  := '0';
      FListB.Values['XCB_OutNum']     := '0';
      FListB.Values['XCB_AuditState'] := '';
      FListB.Values['XCB_Status']     := '';
      FListB.Values['XCB_IsOnly']     := '';
      FListB.Values['XCB_Del']        := '0';
      FListB.Values['XCB_Creator']    := FieldByName('Z_Man').AsString;
      FListB.Values['XCB_CreatorNM']  := FieldByName('Z_Man').AsString;
      FListB.Values['XCB_CDate']      := DateTime2Str(FieldByName('Z_Date').AsDateTime);
      FListB.Values['XCB_Firm']       := '';
      FListB.Values['XCB_FirmName']   := '';
      FListB.Values['pcb_id']         := '';
      FListB.Values['pcb_name']       := '';
      FListB.Values['XCB_TransID']    := '';
      FListB.Values['XCB_TransName']  := '';

      FListA.Add(PackerEncodeStr(FListB.Text));
      Next;
    end;

    FOut.FData := PackerEncodeStr(FListA.Text);
    Result := True;
  end;
end;

//获取采购合同列表，用于网上下单
function TWorkerBusinessCommander.GetPurchaseContractList(var nData:string):Boolean;
var nStr:string;
    nProID:string;
    nK3Worker: PDBWorker;
begin
  Result := False;
  nProID := Trim(FIn.FData);
  if nProID = '' then Exit;

  nStr :=
      ' select DISTINCT rcvmst.srcvno,rcvmst.rcvno,rcvmst.rcvdt,rcvdet.itemno,itemdata.itemname, '+
      ' rcvmst.purpsn,rcvmst.purno,rcvmst.compno,rcvmst.deptno,rcvmst.curstyle,rcvmst.exgrate,rcvdet.rcvprc, '+
      ' rcvmst.transkm,rcvmst.otherkm,rcvmst.fc_transsum,rcvmst.fc_othersum,rcvmst.rcvtype, '+
      ' rcvmst.verifypsn,rcvmst.tr_proj,rcvmst.remarks,rcvmst.transcomp,rcvmst.pondstate, '+
      ' enterprise.compname,employee.lastname, (rcvdet.rcvqty- isnull(rcvdet.pondqty,0)) as B_MaxValue '+
      ' FROM rcvmst,rcvdet,purdec,purmst,itemdata,enterprise,employee '+
      ' WHERE ( rcvmst.srcvno = rcvdet.srcvno ) and '+
            ' ( purdec.spurno = purmst.spurno ) and '+
            ' ( rcvdet.purno = purdec.spurno ) and '+
            ' ( rcvdet.refrow = purdec.lineid ) and '+
            ' ( rcvdet.itemno=itemdata.itemno ) and '+
            ' (rcvmst.compno=enterprise.compno) and '+
            ' (rcvmst.purpsn=employee.empno) and '+
            ' ( ( rcvmst.ispond = 1 ) )  '+
      ' and rcvmst.exaflg = ''1'' and (rcvmst.closeflg = ''0'' or rcvmst.closeflg is null) '+
      ' and (purmst.closeflg =''0'' or purmst.closeflg is null) and (purmst.enddt is null or (purmst.enddt>=''1900-01-01''))';
  nStr := nStr + ' and enterprise.compno='''+nProID+'''';

  nK3Worker := nil;
  nK3Worker := gDBConnManager.GetConnection(sFlag_DB_A3, FErrNum);
  if not Assigned(nK3Worker) then
  begin
    nData := '连接数据库失败(DBConn Is Null).';
    Exit;
  end;

  if not nK3Worker.FConn.Connected then
    nK3Worker.FConn.Connected := True;
  try
  with gDBConnManager.WorkerQuery(nK3Worker, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('未查询到供应商[ %s ]对应的订单信息.', [FIn.FData]);
      Exit;
    end;

    FListA.Clear;
    FListB.Clear;
    First;
    while not Eof do
    try
      FListB.Values['pcId'] := FieldByName('srcvno').AsString;//+';'+FieldByName('B_RecID').AsString;
      FListB.Values['provider_code'] := FieldByName('compno').AsString;
      FListB.Values['provider_name'] := FieldByName('compname').AsString;

      FListB.Values['con_materiel_Code'] := FieldByName('itemno').AsString;
      FListB.Values['con_materiel_name'] := FieldByName('itemname').AsString;

      FListB.Values['con_quantity'] := FieldByName('B_MaxValue').AsString;
      FListB.Values['con_finished_quantity'] := '0';//FieldByName('B_SentValue').AsString;
      FListB.Values['con_date'] := DateTime2Str(FieldByName('rcvdt').AsDateTime);
      
      //FListB.Values['con_remark'] := FieldByName('B_Memo').AsString;
      //FListB.Values['con_code'] := FieldByName('B_RecID').AsString;
      FListB.Values['con_price'] := FieldByName('rcvprc').AsString; //单价
      FListA.Add(PackerEncodeStr(FListB.Text));

    finally
      Next;
    end;
  end;

  FOut.FData := PackerEncodeStr(FListA.Text);
  Result := True;
  finally
  gDBConnManager.ReleaseConnection(nK3Worker);
  end;
end;

//获取客户注册信息
function TWorkerBusinessCommander.getCustomerInfo(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_getCustomerInfo);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//客户与微信账号绑定
function TWorkerBusinessCommander.get_Bindfunc(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_Bindfunc);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//发送消息
function TWorkerBusinessCommander.send_event_msg(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_send_event_msg);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//新增商城用户
function TWorkerBusinessCommander.edit_shopclients(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_edit_shopclients);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//添加商品
function TWorkerBusinessCommander.edit_shopgoods(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_edit_shopgoods);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//获取订单信息
function TWorkerBusinessCommander.get_shoporders(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_shoporders);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//根据订单号获取订单信息
function TWorkerBusinessCommander.get_shoporderbyno(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_shoporderbyNO);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//根据货单号获取货单信息-原材料
function TWorkerBusinessCommander.get_shopPurchasebyNO(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_shopPurchasebyNO);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//修改订单状态
function TWorkerBusinessCommander.complete_shoporders(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_complete_shoporders);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;


initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerQueryField, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessCommander, sPlug_ModuleBus);
end.
