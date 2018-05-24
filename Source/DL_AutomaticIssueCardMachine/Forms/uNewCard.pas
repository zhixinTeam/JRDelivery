unit uNewCard;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, Menus, StdCtrls, cxButtons, cxGroupBox,
  cxRadioGroup, cxTextEdit, cxCheckBox, ExtCtrls, dxLayoutcxEditAdapters,
  dxLayoutControl, cxDropDownEdit, cxMaskEdit, cxButtonEdit,
  USysConst, cxListBox, ComCtrls,Uszttce_api,Contnrs, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  PWorkshop=^TWorkshop;
  TWorkshop = record
    code:string;
    desc:string;
    remainder:Integer;
    WarehouseList:TStringList;
  end;
  TfFormNewCard = class(TForm)
    editWebOrderNo: TcxTextEdit;
    labelIdCard: TcxLabel;
    btnQuery: TcxButton;
    PanelTop: TPanel;
    PanelBody: TPanel;
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    EditCard: TcxTextEdit;
    EditCus: TcxTextEdit;
    EditCName: TcxTextEdit;
    EditDate: TcxTextEdit;
    EditArea: TcxTextEdit;
    EditStock: TcxTextEdit;
    EditSName: TcxTextEdit;
    EditMax: TcxTextEdit;
    EditTruck: TcxButtonEdit;
    PrintFH: TcxCheckBox;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Item9: TdxLayoutItem;
    dxlytmLayout1Item3: TdxLayoutItem;
    dxlytmLayout1Item4: TdxLayoutItem;
    dxlytmLayout1Item6: TdxLayoutItem;
    dxlytmLayout1Item8: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxlytmLayout1Item9: TdxLayoutItem;
    dxlytmLayout1Item10: TdxLayoutItem;
    dxGroupLayout1Group5: TdxLayoutGroup;
    dxlytmLayout1Item11: TdxLayoutItem;
    dxlytmLayout1Item12: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    pnlMiddle: TPanel;
    cxLabel1: TcxLabel;
    lvOrders: TListView;
    Label1: TLabel;
    btnClear: TcxButton;
    TimerAutoClose: TTimer;
    dxLayout1Group2: TdxLayoutGroup;
    EditValue: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    LabInfo: TcxLabel;
    dxLayout1Item3: TdxLayoutItem;
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure editWebOrderNoKeyPress(Sender: TObject; var Key: Char);
    procedure EditValue1KeyPress(Sender: TObject; var Key: Char);
    procedure lvOrdersClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure editWebOrderNoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FErrorCode:Integer;
    FErrorMsg:string;
    FCardData,FComentData:TStrings;
    FNewBillID,FWebOrderID:string;
    FWebOrderItems:array of stMallOrderItem;
    FWebOrderIndex,FWebOrderCount:Integer;
    FSzttceApi:TSzttceApi;
    FGetBatchCode:Boolean;
    FWorkshopList:TList;
    FAutoClose:Integer;
    function DownloadOrder(const nCard:string):Boolean;
    function PostBillStatur(const nBillNo,nStatus,nQty:string):string;
    function SendEventMsg(nData:TStrings;MsgType:string):string;
    function CheckYunTianOrderInfo(const nOrderId:string;var nWebOrderItem:stMallOrderItem):Boolean;
    function SaveBillProxy:Boolean;
    function VerifyCtrl(Sender: TObject; var nHint: string): Boolean;
    procedure SaveWebOrderMatch;
    procedure SetControlsReadOnly;
    procedure InitListView;
    procedure LoadSingleOrder;
    procedure AddListViewItem(var nWebOrderItem:stMallOrderItem);
    function IsRepeatCard(const nWebOrderItem:string):Boolean;
    function LoadWarehouseConfig:Boolean;
    function GetOutASH(const nStr: string): string;
    //获取批次号条件
    function GetStockType(const nStockno:string):string;
    function GetCenterID(const nStockno,nType:string):string;
  public
    { Public declarations }
    procedure SetControlsClear;
    property SzttceApi:TSzttceApi read FSzttceApi write FSzttceApi;
  end;

var
  fFormNewCard: TfFormNewCard;

implementation
uses
  ULibFun,UBusinessPacker,USysLoger,UBusinessConst,UFormMain,USysBusiness,USysDB,
  UAdjustForm,UFormCard,UFormBase,UDataReport,UDataModule,NativeXml;
{$R *.dfm}

procedure TfFormNewCard.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormNewCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i:Integer;
  nItem:PWorkshop;
begin
  Action:=  caFree;
  fFormNewCard := nil;
  FCardData.Free;
  FComentData.Free;
  for i := FWorkshopList.Count-1 downto 0 do
  begin
    nItem := PWorkshop(FWorkshopList.Items[i]);
    nItem.WarehouseList.Free;
    Dispose(nItem);
  end;
  FWorkshopList.Free;
  FreeAndNil(FDR);
  fFormMain.TimerInsertCard.Enabled := True;
end;

procedure TfFormNewCard.FormShow(Sender: TObject);
begin
  SetControlsReadOnly;
  dxLayout1Item9.Visible := True;
  dxlytmLayout1Item6.Visible := False;
  dxlytmLayout1Item8.Visible := False;

//  dxLayout1Item11.Visible := False;
//  dxlytmLayout1Item11.Visible := False;
//  dxlytmLayout1Item13.Visible := False;
  EditTruck.Properties.Buttons[0].Visible := False;

  ActiveControl := editWebOrderNo;
  btnOK.Enabled := False;
  FAutoClose := gSysParam.FAutoClose_Mintue;
  TimerAutoClose.Interval := 60*1000;
  TimerAutoClose.Enabled := True;

  PrintFH.Checked := True;
end;

procedure TfFormNewCard.BtnOKClick(Sender: TObject);
begin
  BtnOK.Enabled := False;
  try
    if not SaveBillProxy then Exit;
    Close;
  finally
    BtnOK.Enabled := True;
  end;
end;

procedure TfFormNewCard.FormCreate(Sender: TObject);
begin
  FCardData := TStringList.Create;
  FComentData := TStringList.Create;
  FWorkshopList := TList.Create;
  if not Assigned(FDR) then
  begin
    FDR := TFDR.Create(Application);
  end;
//  if not LoadWarehouseConfig then
//  begin
//    ShowMsg(FErrorMsg,sHint);
//  end;
  InitListView;
  gSysParam.FUserID := 'AICM';
end;

procedure TfFormNewCard.btnQueryClick(Sender: TObject);
var
  nCardNo,nStr:string;
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  btnQuery.Enabled := False;
  try
    nCardNo := Trim(editWebOrderNo.Text);
    if nCardNo='' then
    begin
      nStr := '请先输入或扫描订单号';
      ShowMsg(nStr,sHint);
      LabInfo.Caption := nStr;
      Exit;
    end;
    lvOrders.Items.Clear;
    if not DownloadOrder(nCardNo) then Exit;
    btnOK.Enabled := True;
  finally
    btnQuery.Enabled := True;
  end;
end;

function TfFormNewCard.DownloadOrder(const nCard: string): Boolean;
var
  nXmlStr,nData:string;
  nIDCard:string;
  nListA,nListB:TStringList;
  i:Integer;
//  nOrderItem:stMallOrderItem;
begin
  Result := False;
  FWebOrderIndex := 0;
  nIDCard := Trim(editWebOrderNo.Text);
  nXmlStr := '<?xml version="1.0" encoding="UTF-8"?>'
            +'<DATA>'
            +'<head>'
            +'<Factory>%s</Factory>'
            +'      <NO>%s</NO>'
            +'</head>'
            +'</DATA>';

  nXmlStr := Format(nXmlStr,[gSysParam.FFactory,nIDCard]);
  nXmlStr := PackerEncodeStr(nXmlStr);

  nData := get_shoporderbyno(nXmlStr);
  if nData='' then
  begin
    ShowMsg('未查询到网上商城订单['+nIDCard+']详细信息，请检查订单号是否正确',sHint);
    LabInfo.Caption := '未查询到网上商城订单['+nIDCard+']详细信息，请检查订单号是否正确';
    Exit;
  end;

  //解析网城订单信息
  nData := PackerDecodeStr(nData);
  gSysLoger.AddLog('get_shoporderbyno res:'+nData);
  nData := StringReplace(nData, ' ', '@', [rfReplaceAll]);
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
//    nListA.add(nData);
    nListA.Text := nData;
    for i := nListA.Count-1 downto 0 do
    begin
      if Trim(nListA.Strings[i])='' then
      begin
        nListA.Delete(i);
      end;
    end;

    FWebOrderCount := nListA.Count;
    SetLength(FWebOrderItems,FWebOrderCount);
    for i := 0 to nListA.Count-1 do
    begin
      nListB.CommaText := nListA.Strings[i];
      nListB.Text := StringReplace(nListB.Text, '@', ' ', [rfReplaceAll]);

      FWebOrderItems[i].FOrder_id := nListB.Values['order_id'];
      FWebOrderItems[i].FOrdernumber := nListB.Values['ordernumber'];
      FWebOrderItems[i].FGoodsID := Copy(nListB.Values['goodsID'],1,Length(nListB.Values['goodsID'])-1);
      FWebOrderItems[i].FGoodstype := nListB.Values['goodstype'];
      FWebOrderItems[i].FGoodsname := Copy(nListB.Values['goodsname'],1,Length(nListB.Values['goodsname'])-4);
      FWebOrderItems[i].FData := nListB.Values['data'];
      FWebOrderItems[i].Ftracknumber := nListB.Values['tracknumber'];
      FWebOrderItems[i].FYunTianOrderId := nListB.Values['fac_order_no'];
//      gSysParam.FUserID := nListB.Values['namepinyin'];
      FWebOrderItems[i].Ftoaddress := nListB.Values['toaddress'];
      FWebOrderItems[i].Fidnumber := nListB.Values['idnumber'];
      AddListViewItem(FWebOrderItems[i]);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;
  FGetBatchCode := True;
  LoadSingleOrder;
end;

function TfFormNewCard.CheckYunTianOrderInfo(const nOrderId: string;
  var nWebOrderItem: stMallOrderItem): Boolean;
var
  nCardDataStr, nZID,nRID: string;
  nIn: TWorkerBusinessCommand;
  nOut: TWorkerBusinessCommand;
  nCard,nParam:string;
  nList: TStrings;
  nPos : integer;

  nYuntianOrderItem:stMallOrderItem;
  nOrderNumberWeb,nOrderNumberYT:Double;
  nType, nStr:string;
begin
  if FGetBatchCode then FComentData.Clear;
  FCardData.Clear;

  nCardDataStr := nOrderId;

  nStr := 'select b.R_ID,' +
        '  D_ZID,' +                            //销售卡片编号
        '  D_Type,' +                           //类型(袋,散)
        '  D_StockNo,' +                        //水泥编号
        '  D_StockName,' +                      //水泥名称
        '  D_Price,' +                          //单价
        '  Z_Man,' +                            //创建人
        '  Z_Date,' +                           //创建日期
        '  Z_Customer,' +                       //客户编号
        '  Z_Name,' +                           //纸卡名称
        '  Z_Lading,' +                         //提货方式
        '  Z_CID,' +                            //合同编号
        '  Z_AreaCode,' +                       //销售区域编码
        '  Z_OnlyMoney,' +                      //纸卡是否限额
        '  Z_FixedMoney,' +                     //纸卡可提额度
        '  C_Name ' +                           //客户名
        ' from %s a join %s b on a.Z_ID = b.D_ZID join s_customer c on a.Z_Customer=c.C_ID ' +
        ' where (Z_Freeze<>''Y'' or Z_Freeze is null) '+
        ' and (Z_InValid<>''Y'' or Z_InValid is null)';
        //订单剩余量大于0、未结订单、订单行未停止状态
  nPos := Pos(';',nCardDataStr);
  if nPos > 0 then
  begin
    nZID := Copy(nCardDataStr,1,nPos-1);
    nRID := Copy(nCardDataStr,nPos+1,Length(nCardDataStr)-nPos);
    nStr := nStr + Format(' and Z_id=''%s'' and b.R_ID=''%s'' ', [nZID,nRID]);
  end
  else
    nStr := nStr + Format(' and Z_id=''%s'' ', [nCardDataStr]);

  nStr := Format(nSTr, [sTable_ZhiKa,sTable_ZhiKaDtl]);

  with fdm.QueryTemp(nStr) do
  begin
    if recordcount < 1 then
    begin
      ShowMsg('当前纸卡已失效。',sError);
      LabInfo.Caption := '当前纸卡已失效。';
      Result := False;
      Exit;
    end;
    nYuntianOrderItem.FGoodsID :=  FieldbyName('D_StockNo').asstring;
    nYuntianOrderItem.FGoodsname := FieldbyName('D_StockName').asstring;
    nYuntianOrderItem.FCusID := FieldbyName('Z_Customer').asstring;
    nYuntianOrderItem.FCusName := FieldbyName('C_Name').asstring;
    EditCus.Text    := FieldbyName('Z_Customer').asstring;
    EditCName.Text  := FieldbyName('C_Name').asstring;
    EditArea.Text := FieldbyName('Z_AreaCode').asstring;

    FCardData.Add('XCB_CardId='+FieldbyName('D_ZID').asstring);
    FCardData.Add('XCB_CementType='+FieldbyName('D_Type').asstring);
    FCardData.Add('XCB_Cement='+FieldbyName('D_StockNo').asstring);
    FCardData.Add('XCB_CementName='+FieldbyName('D_StockName').asstring);
    FCardData.Add('XCB_ID='+FieldbyName('D_Price').asstring);
    FCardData.Add('XCB_LadeType='+FieldbyName('Z_Lading').asstring);
    FCardData.Add('XCB_CusID='+FieldbyName('Z_Customer').asstring);
    FCardData.Add('XCB_CusName='+FieldbyName('C_Name').asstring);
    FCardData.Add('XCB_AreaCode='+FieldbyName('Z_AreaCode').asstring);
  end;

  if UpperCase(nWebOrderItem.FGoodsID)<>UpperCase(nYuntianOrderItem.FGoodsID) then
  begin
    ShowMsg('商城订单中产品型号['+nWebOrderItem.FOrder_id+']有误。',sError);
    LabInfo.Caption := '商城订单中产品型号['+nWebOrderItem.FOrder_id+']有误。';
    Result := False;
    Exit;
  end;

  if nWebOrderItem.FGoodsname<>nYuntianOrderItem.FGoodsname then
  begin
    ShowMsg('商城订单中产品名称['+nWebOrderItem.FGoodsname+']有误。',sError);
    LabInfo.Caption := '商城订单中产品名称['+nWebOrderItem.FGoodsname+']有误。';
    Result := False;
    Exit;
  end;

  nOrderNumberWeb := StrToFloatDef(nWebOrderItem.FData,0);

  if (nOrderNumberWeb<=0.000001) then
  begin
    ShowMsg('订单中提货数量格式有误。',sError);
    LabInfo.Caption := '订单中提货数量格式有误。';
    Result := False;
    Exit;
  end;

  nType := GetStockType(nWebOrderItem.FGoodsID);
  if not gSysParam.FSanZhuangACIM then
  begin
    if nType = sFlag_San then
    begin
      ShowMsg('当前不允许散装产品办理此业务。',sError);
      LabInfo.Caption := '当前不允许散装产品办理此业务。';
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;

function TfFormNewCard.SaveBillProxy: Boolean;
var
  nPrice:string;
  nHint:string;
  nList,nTmp,nStocks: TStrings;
  nPrint:Boolean;
  nBillData:string;
  nNewCardNo:string;
  nType,nStockno:string;
  nPos:Integer;
  nZID,nCenterID,nSampleID, nStr, nPcNo:string;
begin
  FNewBillID := '';
  Result := False;
  //校验提货单信息
  if EditCard.Text='' then
  begin
    ShowMsg('未查询网上订单',sHint);
    LabInfo.Caption := '未查询网上订单';
    Exit;
  end;
  if not VerifyCtrl(EditTruck,nHint) then
  begin
    ShowMsg(nHint,sHint);
    LabInfo.Caption := nHint;
    Exit;
  end;
  if not VerifyCtrl(EditValue,nHint) then
  begin
    ShowMsg(nHint,sHint);
    LabInfo.Caption := nHint;
    Exit;
  end;

  //查询最新批次信息
  nStr := 'select top 1 R_SerialNo from %s a,%s b where a.R_PID=b.P_ID and P_Stock=''%s'' order by R_Date desc';
  nStr := Format(nStr,[sTable_StockRecord,sTable_StockParam, FCardData.Values['XCB_CementName']]);
  with FDM.QueryTemp(nStr) do
  begin
    if recordcount > 0 then
    begin
      nPcNo := fieldbyname('R_SerialNo').asstring;
    end;
  end;

  if gSysParam.FUserID = '' then gSysParam.FUserID := 'AICM';
  nSampleID := '';

  nHint := FCardData.Values['XCB_ID'];

  nPrice := nHint;

  nPos := Pos(';',FCardData.Values['XCB_CardId']);
  if nPos > 0 then
    nZID := Copy(FCardData.Values['XCB_CardId'],1,nPos-1)
  else
    nZID := FCardData.Values['XCB_CardId'];

  //保存提货单
  nStocks := TStringList.Create;
  nList := TStringList.Create;
  nTmp := TStringList.Create;  
  try
    LoadSysDictItem(sFlag_PrintBill, nStocks);

    nType := FCardData.Values['XCB_CementType'];
    if ntype='0' then nType := 'S';
    nTmp.Values['Type'] := ntype;
    nStockno := FCardData.Values['XCB_Cement'];//Copy(FCardData.Values['XCB_Cement'], 1, Length(FCardData.Values['XCB_Cement'])-1);
    nTmp.Values['StockNO'] := nStockno;
    nTmp.Values['StockName'] := FCardData.Values['XCB_CementName'];
    nTmp.Values['Price'] := nPrice;
    nTmp.Values['Value'] := EditValue.Text;
    nTmp.Values['RECID'] := FCardData.Values['XCB_ID'];
    nTmp.Values['SampleID'] := nSampleID;

    nList.Add(PackerEncodeStr(nTmp.Text));
    nPrint := nStocks.IndexOf(Copy(FCardData.Values['XCB_Cement'], 1, Length(FCardData.Values['XCB_Cement'])-1)) >= 0;
    nTmp.Values['Seal'] := nPcNo;
    with nList do
    begin
      Values['Bills'] := PackerEncodeStr(nList.Text);
      Values['ZhiKa'] := nZID;
      Values['Truck'] := EditTruck.Text;
      Values['Lading'] := FCardData.Values['XCB_LadeType'];
      Values['IsVIP'] := sFlag_TypeCommon;
      Values['MakeMan'] := 'ATM';
      Values['Memo']  := EmptyStr;
      Values['BuDan'] := sFlag_No;
      Values['CenterID'] := nCenterID;
      if PrintFH.Checked  then
        Values['IfHYprt'] := sFlag_Yes
      else
        Values['IfHYprt'] := sFlag_No;
      Values['LID'] := '';
      Values['Project'] := EditCName.Text;
      Values['WebOrderID'] := FWebOrderID;
      Values['IfNeiDao'] := sFlag_No;
      Values['AreaCode'] := FCardData.Values['XCB_AreaCode'];
    end;

    nBillData := PackerEncodeStr(nList.Text);
    FNewBillID := SaveBill(nBillData);
    if FNewBillID = '' then
    begin
      LabInfo.Caption := '保存单据失败！';
      Exit;
    end;
    //SaveWebOrderMatch;
    //PostBillStatur(Trim(editWebOrderNo.Text),'0',Trim(EditValue.Text));
    //修改订单状态
    //SendEventMsg(FCardData,'1');
    //推送办卡信息
  finally
    nStocks.Free;
    nList.Free;
    nTmp.Free;
  end;
  ShowMsg('提货单保存成功', sHint);
  //发卡
  if not FSzttceApi.IssueOneCard(nNewCardNo) then
  begin
    nHint := '出卡失败,请到开票窗口补办磁卡：[errorcode=%d,errormsg=%s]';
    nHint := Format(nHint,[FSzttceApi.ErrorCode,FSzttceApi.ErrorMsg]);
    ShowMsg(nHint,sHint);
    LabInfo.Caption := nHint;
  end
  else begin
    ShowMsg('发卡成功,卡号['+nNewCardNo+'],请收好您的卡片',sHint);
    SetBillCard(FNewBillID, EditTruck.Text,nNewCardNo, True);
  end;

  if PrintYesNo then
    PrintBillReport(FNewBillID, False);
  Close;
end;

function TfFormNewCard.VerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '车牌号长度应大于2位';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    nHint := '请填写有效的办理量';
    if not Result then Exit;

    nVal := StrToFloat(EditValue.Text);
    Result := FloatRelation(nVal, StrToFloat(EditMax.Text),rtLE);
    nHint := '已超出可提货量';
  end;
end;

procedure TfFormNewCard.editWebOrderNoKeyPress(Sender: TObject; var Key: Char);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  if Key=Char(vk_return) then
  begin
    key := #0;
    btnQuery.SetFocus;
    btnQuery.Click;
  end;
end;

procedure TfFormNewCard.EditValue1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=Char(vk_return) then
  begin
    key := #0;
    BtnOK.Click;
  end;
end;

procedure TfFormNewCard.SaveWebOrderMatch;
var
  nStr:string;
begin
  nStr := 'insert into %s(WOM_WebOrderID,WOM_LID) values(''%s'',''%s'')';
  nStr := Format(nStr,[sTable_WebOrderMatch,FWebOrderID,FNewBillID]);
  fdm.ADOConn.BeginTrans;
  try
    fdm.ExecuteSQL(nStr);
    fdm.ADOConn.CommitTrans;
  except
    fdm.ADOConn.RollbackTrans;
  end;
end;

procedure TfFormNewCard.SetControlsClear;
var
  i:Integer;
  nComp:TComponent;
begin
  editWebOrderNo.Clear;
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Clear;
    end;
  end;
end;

procedure TfFormNewCard.SetControlsReadOnly;
var
  i:Integer;
  nComp:TComponent;
begin
//  editIdCard.Properties.ReadOnly := True;
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Properties.ReadOnly := True;
    end;
  end;
end;

procedure TfFormNewCard.InitListView;
var
  col:TListColumn;
begin
  lvOrders.ViewStyle := vsReport;
  col := lvOrders.Columns.Add;
  col.Caption := '网上订单编号';
  col.Width := 300;
  col := lvOrders.Columns.Add;
  col.Caption := '水泥型号';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '水泥名称';
  col.Width := 300;
  col := lvOrders.Columns.Add;
  col.Caption := '提货车辆';
  col.Width := 160;
  col := lvOrders.Columns.Add;
  col.Caption := '办理吨数';
  col.Width := 150;
end;

procedure TfFormNewCard.LoadSingleOrder;
var
  nOrderItem:stMallOrderItem;
  nRepeat:Boolean;
  nCorrectBatchCode,nCementCodeID:string;
  nStr,nZhiKaYL:string;
  nOnlyMoney:Boolean;
  nMoney, nPrice, nbillYE:Double;
  nPos: Integer;
  nZID,nRID,nCardDataStr: string;
begin
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  FWebOrderID := nOrderItem.FOrdernumber;
  nRepeat := IsRepeatCard(FWebOrderID);

  if nRepeat then
  begin
    ShowMsg('此订单已成功办卡，请勿重复操作',sHint);
    Exit;
  end;

  //订单有效性校验
  if not CheckYunTianOrderInfo(nOrderItem.FYunTianOrderId,nOrderItem) then
  begin
    BtnOK.Enabled := False;
    Exit;
  end;

  nStr := 'select * from %s where ';
  nCardDataStr := nOrderItem.FYunTianOrderId;
  nPos := Pos(';',nCardDataStr);
  if nPos > 0 then
  begin
    nZID := Copy(nCardDataStr,1,nPos-1);
    nRID := Copy(nCardDataStr,nPos+1,Length(nCardDataStr)-nPos);
    nStr := nStr + Format(' D_Zid=''%s'' and R_ID=''%s'' ', [nZID,nRID]);
  end
  else
    nStr := nStr + Format(' D_Zid=''%s'' ', [nCardDataStr]);

  nStr := Format(nStr,[sTable_ZhiKaDtl]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nStr := '编号为[ %s ] 的纸卡无明细';
      nStr := Format(nStr, [nOrderItem.FYunTianOrderId]);
      ShowMsg(nStr, sHint);
      Exit;
    end;
    nPrice := fieldbyname('D_Price').asfloat;
  end;

  if nPos > 0 then
    nMoney := GetZhikaValidMoney(nZID, nOnlyMoney)
  else
    nMoney := GetZhikaValidMoney(nOrderItem.FYunTianOrderId, nOnlyMoney);

  nZhiKaYL := FloatToStr(nMoney / nPrice);

  if StrToFloat(nOrderItem.FData) > (nMoney / nPrice) then
  begin
    ShowMsg('商城订单中提货数量有误，最多可提货数量为['+nZhiKaYL+']。',sError);
    LabInfo.Caption := '商城订单中提货数量有误，最多可提货数量为['+nZhiKaYL+']。';
    Exit;
  end;

  //填充界面信息
  //基本信息
  EditCard.Text   := nOrderItem.FOrder_id;
  EditDate.Text   := nOrderItem.FData;              
//  EditArea.Text   := nOrderItem.Ftoaddress;         

  //提单信息
  if FComentData.Text <> '' then
  begin
    FCardData.Values['XCB_CementCode'] := FComentData.Values['XCB_CementCode'];
    FCardData.Values['XCB_CementCodeID'] := FComentData.Values['XCB_CementCodeID'];
  end;
  EditStock.Text  := nOrderItem.FGoodsID;
  EditSName.Text  := nOrderItem.FGoodsname;
  EditMax.Text  := nZhiKaYL;
  EditValue.Text := nOrderItem.FData;
  EditTruck.Text := nOrderItem.Ftracknumber;
//  EditIdNo.Text := nOrderItem.Fidnumber;
  BtnOK.Enabled := not nRepeat;
end;

procedure TfFormNewCard.AddListViewItem(
  var nWebOrderItem: stMallOrderItem);
var
  nListItem:TListItem;
begin
  nListItem := lvOrders.Items.Add;
  nlistitem.Caption := nWebOrderItem.FOrdernumber;

  nlistitem.SubItems.Add(nWebOrderItem.FGoodsID);
  nlistitem.SubItems.Add(nWebOrderItem.FGoodsname);
  nlistitem.SubItems.Add(nWebOrderItem.Ftracknumber);
  nlistitem.SubItems.Add(nWebOrderItem.FData);
end;

procedure TfFormNewCard.lvOrdersClick(Sender: TObject);
var
  nSelItem:TListItem;
  i:Integer;
begin
  nSelItem := lvorders.Selected;
  if Assigned(nSelItem) then
  begin
    for i := 0 to lvOrders.Items.Count-1 do
    begin
      if nSelItem = lvOrders.Items[i] then
      begin
        FWebOrderIndex := i;
        LoadSingleOrder;
        Break;
      end;
    end;
  end;
end;

function TfFormNewCard.IsRepeatCard(const nWebOrderItem: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := 'select * from %s where WOM_WebOrderID=''%s'' and WOM_deleted=''%s''';
  nStr := Format(nStr,[sTable_WebOrderMatch,nWebOrderItem,sFlag_No]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount>0 then
    begin
      Result := True;
    end;
  end;
end;


function TfFormNewCard.LoadWarehouseConfig: Boolean;
var
  nFileName:string;
  nRoot,nworkshopNode, nWarehouseNode: TXmlNode;
  nXML: TNativeXml;
  nPWorkshopItem:PWorkshop;
  i,j,nworkshopCount,nWarehouseCount:Integer;
  nStr:string;
begin
  Result := False;
  nFileName := ExtractFilePath(ParamStr(0))+'Warehouse_config.xml';
  if not FileExists(nFileName) then
  begin
    FErrorCode := 1000;
    FErrorMsg := '系统配置文件['+nFileName+']不存在';
    Exit;
  end;

  nXML := TNativeXml.Create;
  try
    nXML.LoadFromFile(nFileName);
    nRoot := nXML.Root;
    nworkshopCount := nRoot.NodeCount;
    for i := 0 to nworkshopCount-1 do
    begin
      nworkshopNode := nRoot.Nodes[i];
      New(nPWorkshopItem);
      nPWorkshopItem.code := UTF8Decode(nworkshopNode.ReadAttributeString('code'));
      nPWorkshopItem.desc := UTF8Decode(nworkshopNode.ReadAttributeString('desc'));
      nPWorkshopItem.remainder := StrToIntDef(UTF8Decode(nworkshopNode.ReadAttributeString('remainder')),0);
      nPWorkshopItem.WarehouseList := TStringList.Create;
      nWarehouseCount := nworkshopNode.NodeCount;
      for j := 0 to nWarehouseCount-1 do
      begin
        nWarehouseNode := nworkshopNode.Nodes[j];
        nStr := UTF8Decode(nWarehouseNode.ValueAsString);
        nPWorkshopItem.WarehouseList.Add(nStr);
      end;
      FWorkshopList.Add(nPWorkshopItem);
    end;
    Result := True;
  finally
    nXML.Free;
  end;
end;

function TfFormNewCard.GetOutASH(const nStr: string): string;
var nPos: Integer;
    nTmp: string;
begin
  nTmp := nStr;
  nPos := Pos('.', nTmp);

  System.Delete(nTmp, 1, nPos);
  Result := nTmp;
end;

function TfFormNewCard.getStockType(const nStockno: string): string;
var
  nSql:string;
begin
  Result := '';
  nSql := 'select D_Memo from %s where d_name = ''StockItem'' and d_paramB=''%s''';
  nSql := Format(nSql,[sTable_SysDict,nStockno]);

  with FDM.QueryTemp(nSql) do
  begin
    if recordcount>0 then
    begin
      Result := FieldByName('D_Memo').AsString;
    end;
  end;
end;

procedure TfFormNewCard.btnClearClick(Sender: TObject);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  editWebOrderNo.Clear;
  ActiveControl := editWebOrderNo;
end;

procedure TfFormNewCard.TimerAutoCloseTimer(Sender: TObject);
begin
  if FAutoClose=0 then
  begin
    TimerAutoClose.Enabled := False;
    Close;
  end;
  Dec(FAutoClose);
end;

procedure TfFormNewCard.editWebOrderNoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
end;


function TfFormNewCard.GetCenterID(const nStockno, nType: string): string;
var
  nIdx:integer;
  nStr :string;
begin
  nStr := 'select * from %s where z_stockno=''%s'' and z_valid=''%s''';
  nStr := Format(nStr,[sTable_ZTLines,nStockno+nType,sFlag_Yes]);
  Result := FDM.QueryTemp(nStr).FieldByName('z_centerid').AsString;
end;

function TfFormNewCard.PostBillStatur(const nBillNo, nStatus, nQty: string): string;
var
  nXmlStr, nData: string;
begin
  Result := '';
  nXmlStr := '<?xml version="1.0" encoding="UTF-8"?>'
            +'<DATA>'
            +'<head>'
            +'<ordernumber>%s</ordernumber>'
            +'      <status>%s</status>'
            +'      <NetWeight>%s</NetWeight>'
            +'</head>'
            +'</DATA>';

  nXmlStr := Format(nXmlStr,[nBillNo,nStatus,nQty]);
  nXmlStr := PackerEncodeStr(nXmlStr);

  nData := Post_ShopOrderStatusByNo(nXmlStr);
  Result := nData;
end;

function TfFormNewCard.SendEventMsg(nData:TStrings;MsgType:string): string;
var
  nXmlStr, nStr: string;
begin
  Result := '';
  nXmlStr := '<?xml version="1.0" encoding="UTF-8"?>'
            +'<DATA>'
            +'<head>'
              +'<MsgType>'+MsgType+'</MsgType>'
              +'<Factory>'+gSysParam.FFactory+'</Factory>'
              +'<ToUser>'+nData.Values['XCB_CusID']+'</ToUser>'
            +'</head>'
            +'<ITEM>'
              +'<BillID>'+nData.Values['XCB_CusID']+'</BillID>'
              +'<Card></Card>'
              +'<Truck>'+EditTruck.Text+'</Truck>'
              +'<StockNo>'+nData.Values['XCB_Cement']+'</StockNo>'
              +'<StockName>'+nData.Values['XCB_CementName']+'</StockName>'
              +'<CusID></CusID>'
              +'<CusName>'+nData.Values['XCB_CusName']+'</CusName>'
              +'<CusAccount></CusAccount>'
              +'<MakeDate>%s</MakeDate>'
              +'<MakeMan>%s</MakeMan>'
              +'<TransID></TransID>'
              +'<TransName></TransName>'
              +'<Searial></Searial>'
              +'<OutFact>%s</OutFact>'
              +'<OutMan></OutMan>'
              +'<NetWeight>'+EditValue.Text+'</NetWeight>'
            +'</ITEM>'
            +'</DATA>';

  if MsgType ='1' then     //1开卡成功通知，2货物出厂通知
    nXmlStr := Format(nXmlStr,[formatdatetime('yyyy-mm-dd HH:MM:SS',Now),'ATM',''])
  else
    nXmlStr := Format(nXmlStr,['','',formatdatetime('yyyy-mm-dd HH:MM:SS',Now)]);

  nXmlStr := PackerEncodeStr(nXmlStr);

  nStr := Post_ShopOrderStatusByNo(nXmlStr);
  Result := nStr;
end;

end.
