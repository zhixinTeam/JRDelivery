{*******************************************************************************
����: fendou116688@163.com 2016/9/19
����: Webƽ̨�����ѯ
*******************************************************************************}
unit UWorkerBussinessWebchat;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, ADODB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, ULibFun, UFormCtrl, USysLoger,
  USysDB, UMITConst, UWorkerSelfRemote, NativeXml;

type
  TWebResponseBaseInfo = class(TObject)
  public
    FErrcode:Integer;
    FErrmsg:string;
    FPacker: TBusinessPackerBase;
    function ParseWebResponse(var nData:string):Boolean;virtual;
  end;

  stCustomerInfoItem = record
    Fphone:string;
    FBindcustomerid:string;
    FNamepinyin:string;
    FEmail:string;
  end;

  TWebResponse_CustomerInfo = class(TWebResponseBaseInfo)
  public
    items:array of stCustomerInfoItem;
    function ParseWebResponse(var nData:string):Boolean;override;
  end;

  TWebResponse_Bindfunc = class(TWebResponseBaseInfo)
  end;

  TWebResponse_send_event_msg=class(TWebResponseBaseInfo)
  end;

  TWebResponse_edit_shopclients=class(TWebResponseBaseInfo)
  end;

  TWebResponse_edit_shopgoods=class(TWebResponseBaseInfo)
  end;

  TWebResponse_complete_shoporders=class(TWebResponseBaseInfo)
  end;  

  stShopOrderItem = record
    FOrder_id:string;
    Ffac_order_no:string;
    FOrdernumber:string;
    FGoodsID:string;
    FGoodstype:string;
    FGoodsname:string;
    Ftracknumber:string;
    FData:string;
    FProID:string;
  end;
  
  TWebResponse_get_shoporders=class(TWebResponseBaseInfo)
  public
    items:array of stShopOrderItem;
    function ParseWebResponse(var nData:string):Boolean;override;
  end;

  TBusWorkerBusinessWebchat = class(TBusinessWorkerBase)
  private
    FIn: TWorkerWebChatData;
    FOut: TWorkerWebChatData;

    procedure BuildDefaultXMLPack;
    //��������Ĭ�ϱ���
    function UnPackIn(var nData: string): Boolean;
    //���뱨�Ľ��
    function VerifyPrintCode(var nData: string): Boolean;
    //��֤������Ϣ

    function GetWaitingForloading(var nData:string):Boolean;
    //������װ��ѯ

    function GetBillSurplusTonnage(var nData:string):Boolean;
    //���϶������µ�������ѯ

    function GetOrderInfo(var nData:string):Boolean;
    //��ȡ������Ϣ

    function GetOrderList(var nData:string):Boolean;
    //��ȡ�����б�

    function GetPurchaseContractList(var nData:string):Boolean;
    //��ȡ�ɹ���ͬ�б�

    function GetCustomerInfo(var nData:string):boolean;
    //��ȡ�ͻ�ע����Ϣ
    
    function Get_Shoporders(var nData:string):boolean;
    //��ȡ������Ϣ

    function get_shoporderByNO(var nData:string):boolean;
    //���ݶ����Ż�ȡ������Ϣ

    function Get_Bindfunc(var nData:string):boolean;
    //�ͻ���΢���˺Ű�

    function Send_Event_Msg(var nData:string):boolean;
    //������Ϣ
    
    function Edit_ShopClients(var nData:string):boolean;
    //�����̳��û�
    
    function Edit_Shopgoods(var nData:string):boolean;
    //�����Ʒ

    function complete_shoporders(var nData:string):Boolean;
    //�޸Ķ���״̬
    
  public
    class function FunctionName: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    function DoWork(var nData: string): Boolean; override;
    //ִ��ҵ��
    procedure WriteLog(const nEvent: string);
    //��¼��־
  end;

implementation
uses
  wechat_soap,DateUtils;
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TBusWorkerBusinessWebchat, 'Webƽ̨ҵ��' , nEvent);
end;

class function TBusWorkerBusinessWebchat.FunctionName: string;
begin
  Result := sBus_BusinessWebchat;
end;

function TBusWorkerBusinessWebchat.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessWebchat;
  end;
end;

//Desc: ��¼nEvent��־
procedure TBusWorkerBusinessWebchat.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TBusWorkerBusinessWebchat, 'Webƽ̨ҵ��' , nEvent);
end;

{
//�������
<?xml version="1.0" encoding="utf-8"?>
<Head>
  <Command>1</Command>
  <Data>����</Data>
  <ExtParam>���Ӳ���</ExtParam>
  <RemoteUL>��������UL</RemoteUL>
</Head>

//��������
<?xml version="1.0" encoding="utf-8"?>
<DATA>
  <Items>
    <Item>
      .....
    </Item>
  </Items>
  <EXMG> ---�����������ɶ���
     < Item>
         < MsgResult> Y</ MsgResult > ---��Ϣ���ͣ�Y�ɹ���Nʧ�ܵ�
         < MsgCommand> 1</ MsgCommand >----��Ϣ����
		     < MsgTxt>����ʧ�ܣ�ָ����������Ч</ MsgTxt > ---��������
     < / Item >
  </EXMG>
</DATA>
}

function TBusWorkerBusinessWebchat.UnPackIn(var nData: string): Boolean;
var nNode, nTmp: TXmlNode;
begin
  Result := False;
  FPacker.XMLBuilder.Clear;
  FPacker.XMLBuilder.ReadFromString(nData);

  //nNode := FPacker.XMLBuilder.Root.FindNode('Head');
  nNode := FPacker.XMLBuilder.Root;
  if not (Assigned(nNode) and Assigned(nNode.FindNode('Command'))) then
  begin
    nData := '��Ч�����ڵ�(Head.Command Null).';
    Exit;
  end;

  if not Assigned(nNode.FindNode('RemoteUL')) then
  begin
    nData := '��Ч�����ڵ�(Head.RemoteUL Null).';
    Exit;
  end;

  nTmp := nNode.FindNode('Command');
  FIn.FCommand := StrToIntDef(nTmp.ValueAsString, 0);

  nTmp := nNode.FindNode('RemoteUL');
  FIn.FRemoteUL:= nTmp.ValueAsString;

  nTmp := nNode.FindNode('Data');
  if Assigned(nTmp) then FIn.FData := nTmp.ValueAsString;

  nTmp := nNode.FindNode('ExtParam');
  if Assigned(nTmp) then FIn.FExtParam := nTmp.ValueAsString;
end;

procedure TBusWorkerBusinessWebchat.BuildDefaultXMLPack;
begin
  with FPacker.XMLBuilder do
  begin
    Clear;
    VersionString := '1.0';
    EncodingString := 'utf-8';

    XmlFormat := xfCompact;
    Root.Name := 'DATA';
    //first node
  end;
end;

function TBusWorkerBusinessWebchat.DoWork(var nData: string): Boolean;
var
  nBegin:TDateTime;
begin
  nBegin := Now;
  UnPackIn(nData);

  case FIn.FCommand of
    cBC_VerifPrintCode         : Result := VerifyPrintCode(nData);
    cBC_WaitingForloading      : Result := GetWaitingForloading(nData);
    cBC_BillSurplusTonnage     : Result := GetBillSurplusTonnage(nData);
    cBC_GetOrderInfo           : Result := GetOrderInfo(nData);
    cBC_GetOrderList           : Result := GetOrderList(nData);
    cBC_GetPurchaseContractList : Result := GetPurchaseContractList(nData);

    cBC_WeChat_getCustomerInfo :Result := getCustomerInfo(nData);  //΢��ƽ̨�ӿڣ���ȡ�ͻ�ע����Ϣ
    cBC_WeChat_get_Bindfunc    :Result := get_Bindfunc(nData);  //΢��ƽ̨�ӿڣ��ͻ���΢���˺Ű�
    cBC_WeChat_send_event_msg  :Result := send_event_msg(nData);  //΢��ƽ̨�ӿڣ�������Ϣ
    cBC_WeChat_edit_shopclients :Result := edit_shopclients(nData);  //΢��ƽ̨�ӿڣ������̳��û�
    cBC_WeChat_edit_shopgoods :Result := edit_shopgoods(nData);  //΢��ƽ̨�ӿڣ������Ʒ
    cBC_WeChat_get_shoporders :Result := get_shoporders(nData);  //΢��ƽ̨�ӿڣ���ȡ������Ϣ
    cBC_WeChat_complete_shoporders : Result := complete_shoporders(nData); //΢��ƽ̨�ӿڣ��������
    cBC_WeChat_get_shoporderbyno : Result := get_shoporderbyno(nData);  //΢��ƽ̨�ӿڣ����ݶ����Ż�ȡ������Ϣ
    cBC_WeChat_get_shopPurchasebyNO : Result := get_shoporderbyno(nData);
   else
    begin
      Result := False;
      nData := '��Ч��ָ�����(Invalid Command).';
    end;
  end;

  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
    WriteLog('TBusWorkerBusinessWebchat.DoWork(FIn.FCommand='+inttostr(FIn.FCommand)+')-��ʱ��'+InttoStr(MilliSecondsBetween(Now, nBegin))+'ms');
  end;
end;

//------------------------------------------------------------------------------
//Date: 2016-9-20
//Parm: ��α��
//Desc: ��α���ѯ
function TBusWorkerBusinessWebchat.VerifyPrintCode(var nData: string): Boolean;
var nOut: TWorkerBusinessCommand;
    nItems: TLadingBillItems;
    nIdx: Integer;
begin
  Result := CallRemoteWorker(sCLI_BusinessCommand, FIn.FData, FIn.FExtParam,
            @nOut, cBC_VerifPrintCode, Trim(FIn.FRemoteUL));
  //xxxxxx

  BuildDefaultXMLPack;
  if Result then
  begin
    with FPacker.XMLBuilder do
    begin
      with Root.NodeNew('Items') do
      begin
        AnalyseBillItems(nOut.FData, nItems);

        for nIdx := Low(nItems) to High(nItems) do
        with NodeNew('Item'), nItems[nIdx] do
        begin
          NodeNew('ID').ValueAsString := FID;

          NodeNew('CusID').ValueAsString := FCusID;
          NodeNew('CusName').ValueAsString := FCusName;

          NodeNew('Truck').ValueAsString := FTruck;
          NodeNew('StockNo').ValueAsString := FStockNo;
          NodeNew('StockName').ValueAsString := FStockName;

          NodeNew('BILL').ValueAsString := FID;
          NodeNew('PROJECT').ValueAsString := FProject;
          NodeNew('STOCK').ValueAsString := FStockName;
          NodeNew('CUSNAME').ValueAsString := FCusName;
          NodeNew('AREA').ValueAsString := Farea;
          NodeNew('WORKADDR').ValueAsString := Fworkaddr;
          NodeNew('TRANSNAME').ValueAsString := Ftransname;
          NodeNew('HYDAN').ValueAsString := FHYDan;
          NodeNew('TRUCK').ValueAsString := FTruck;
          NodeNew('LVALUE').ValueAsString := FloatToStr(FValue);
          NodeNew('OUTDATE').ValueAsString := FormatDateTime('yyyy-mm-dd',Foutfact);
        end;  
      end;

      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString     := 'ҵ��ִ�гɹ�';
        NodeNew('MsgResult').ValueAsString  := sFlag_Yes;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
    end;
  end  else

  begin
    with FPacker.XMLBuilder do
    begin
      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString     := nOut.FData;
        NodeNew('MsgResult').ValueAsString  := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
    end;
  end;  

  nData := FPacker.XMLBuilder.WriteToString;
end;  

//------------------------------------------------------------------------------
//Date: 2016-9-20
//Parm: ����
//Desc: ������װ��ѯ
function TBusWorkerBusinessWebchat.GetWaitingForloading(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
    nItems: TQueueListItems;
    nIdx: Integer;
begin
  Result := CallRemoteWorker(sCLI_BusinessCommand, FIn.FData, FIn.FExtParam,
            @nOut, cBC_WaitingForloading, Trim(FIn.FRemoteUL));
  //xxxxxx

  BuildDefaultXMLPack;
  if Result then
  begin
    with FPacker.XMLBuilder do
    begin
      with Root.NodeNew('Items') do
      begin
        AnalyseQueueListItems(nOut.FData, nItems);

        for nIdx := Low(nItems) to High(nItems) do
        with NodeNew('Item'), nItems[nIdx] do
        begin
          NodeNew('StockName').ValueAsString := FStockName;
          NodeNew('LineCount').ValueAsString := IntToStr(FLineCount);
          NodeNew('TruckCount').ValueAsString := IntToStr(FTruckCount);
        end;  
      end;

      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString     := 'ҵ��ִ�гɹ�';
        NodeNew('MsgResult').ValueAsString  := sFlag_Yes;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
    end;
  end
  else begin
    with FPacker.XMLBuilder do
    begin
      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString     := nOut.FData;
        NodeNew('MsgResult').ValueAsString  := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
    end;
  end;  
  nData := FPacker.XMLBuilder.WriteToString;
end;

//------------------------------------------------------------------------------
//Date: 2016-9-23
//Parm: �ͻ���ţ���Ʒ���
//Desc: ���϶������µ�������ѯ
function TBusWorkerBusinessWebchat.GetBillSurplusTonnage(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessCommand, FIn.FData, FIn.FExtParam,
            @nOut, cBC_BillSurplusTonnage, Trim(FIn.FRemoteUL));
  //xxxxxx

  BuildDefaultXMLPack;
  if Result then
  begin
    with FPacker.XMLBuilder do
    begin
      with Root.NodeNew('Items') do
      begin
        with NodeNew('Item') do
        begin
          NodeNew('MaxTonnage').ValueAsString := nOut.FData;
        end;
      end;

      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString     := 'ҵ��ִ�гɹ�';
        NodeNew('MsgResult').ValueAsString  := sFlag_Yes;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
    end;
  end
  else begin
    with FPacker.XMLBuilder do
    begin
      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString     := nOut.FData;
        NodeNew('MsgResult').ValueAsString  := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
    end;
  end;  
  nData := FPacker.XMLBuilder.WriteToString;
end;

//------------------------------------------------------------------------------
//Date: 2016-10-20
//Parm: ������ţ�����ϵͳ��Ʊ�ţ�
//Desc: ��ȡ������Ϣ,�����µ�ʱʹ��
function TBusWorkerBusinessWebchat.GetOrderInfo(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
  nCardData:TStringList;
begin
  Result := CallRemoteWorker(sCLI_BusinessCommand, FIn.FData, FIn.FExtParam,
              @nOut, cBC_GetOrderInfo, Trim(FIn.FRemoteUL));
  nCardData := TStringList.Create;
  try
    BuildDefaultXMLPack;
    if Result then
    begin
      nCardData.Text := PackerDecodeStr(nOut.FData);
      with FPacker.XMLBuilder do
      begin
        with Root.NodeNew('head') do
        begin
          NodeNew('CusId').ValueAsString := nCardData.Values['XCB_Client'];
          NodeNew('CusName').ValueAsString := nCardData.Values['XCB_ClientName'];
        end;

        with Root.NodeNew('Items') do
        begin
          with NodeNew('Item') do
          begin
            NodeNew('StockNo').ValueAsString := nCardData.Values['XCB_Cement'];
            NodeNew('StockName').ValueAsString := nCardData.Values['XCB_CementName'];
            NodeNew('MaxNumber').ValueAsString := nCardData.Values['XCB_RemainNum'];
          end;
        end;

        with Root.NodeNew('EXMG') do
        begin
          NodeNew('MsgTxt').ValueAsString     := 'ҵ��ִ�гɹ�';
          NodeNew('MsgResult').ValueAsString  := sFlag_Yes;
          NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
        end;
      end;
    end;
  finally
    nCardData.Free;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
end;

//------------------------------------------------------------------------------
//Date: 2016-12-18
//Parm: �ͻ����
//Desc: ��ȡ�����б�,�������µ�ʱʹ��
function TBusWorkerBusinessWebchat.GetOrderList(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
  nCardData,nCardItem:TStringList;
  nType: string;
  i:Integer;
  nRequest,nResponse:string;
begin
  Result := CallRemoteWorker(sCLI_BusinessCommand, FIn.FData, FIn.FExtParam,
              @nOut, cBC_GetOrderList, Trim(FIn.FRemoteUL));
  nRequest := nData;

//  WriteLog(Format('Out => [%s]', [nOut.FData]));
  nCardData := TStringList.Create;
  nCardItem := TStringList.Create;
  try
    BuildDefaultXMLPack;
    if Result then
    begin
      nCardData.Text := PackerDecodeStr(nOut.FData);
      WriteLog(Format('nCardData => [count.%d]', [nCardData.Count]));
      nCardItem.Text := PackerDecodeStr(nCardData.Strings[0]);
      with FPacker.XMLBuilder do
      begin
        with Root.NodeNew('head') do
        begin
          NodeNew('CusId').ValueAsString := nCardItem.Values['XCB_Client'];
          NodeNew('CusName').ValueAsString := nCardItem.Values['XCB_ClientName'];
        end;

        with Root.NodeNew('Items') do
        begin
          for i := 0 to nCardData.Count-1 do
          begin
            nCardItem.Text := PackerDecodeStr(nCardData.Strings[i]);
            WriteLog(Format('nCardData[%d] => [%s]', [i, nCardItem.Text]));
            with NodeNew('Item') do
            begin
              if Pos('��', nCardItem.Values['XCB_CementName']) > 0 then
                   nType := '��װ'
              else nType := 'ɢװ';

              NodeNew('SetDate').ValueAsString := nCardItem.Values['XCB_SetDate'];
              NodeNew('BillNumber').ValueAsString := nCardItem.Values['XCB_CardId'];
              NodeNew('StockNo').ValueAsString := nCardItem.Values['XCB_Cement'];
              NodeNew('StockName').ValueAsString := nCardItem.Values['XCB_CementName'];// + nType;
              NodeNew('MaxNumber').ValueAsString := nCardItem.Values['XCB_RemainNum'];
              NodeNew('SaleArea').ValueAsString := nCardItem.Values['XCB_WorkAddr'];
            end;
          end;
        end;

        with Root.NodeNew('EXMG') do
        begin
          NodeNew('MsgTxt').ValueAsString     := 'ҵ��ִ�гɹ�';
          NodeNew('MsgResult').ValueAsString  := sFlag_Yes;
          NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
        end;
      end;
    end;
  finally
    nCardItem.Free;
    nCardData.Free;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  nResponse := FPacker.XMLBuilder.WriteToString;
  WriteLog('TBusWorkerBusinessWebchat.GetOrderList request='+nRequest);
  WriteLog('TBusWorkerBusinessWebchat.GetOrderList Response='+nResponse);
end;

//��ȡ�ɹ���ͬ�б�
function TBusWorkerBusinessWebchat.GetPurchaseContractList(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
  nCardData,nCardItem:TStringList;
  i:Integer;
  nRequest,nResponse:string;
  nMaxNumber:Double;
begin
  Result := CallRemoteWorker(sCLI_BusinessCommand, FIn.FData, FIn.FExtParam,
              @nOut, cBC_GetPurchaseContractList, Trim(FIn.FRemoteUL));
  nCardData := TStringList.Create;
  nCardItem := TStringList.Create;
  nRequest := nData;
  try
    BuildDefaultXMLPack;
    if Result then
    begin
      nCardData.Text := PackerDecodeStr(nOut.FData);
      nCardItem.Text := PackerDecodeStr(nCardData.Strings[0]);
      with FPacker.XMLBuilder do
      begin
        with Root.NodeNew('head') do
        begin
          NodeNew('ProvId').ValueAsString := nCardItem.Values['provider_code'];
          NodeNew('ProvName').ValueAsString := nCardItem.Values['provider_name'];
        end;
        with Root.NodeNew('Items') do
        begin
          for i := 0 to nCardData.Count-1 do
          begin
            nCardItem.Text := PackerDecodeStr(nCardData.Strings[i]);
            with NodeNew('Item') do
            begin
              NodeNew('SetDate').ValueAsString := nCardItem.Values['con_date'];
              NodeNew('BillNumber').ValueAsString := nCardItem.Values['pcId'];
              NodeNew('StockNo').ValueAsString := nCardItem.Values['con_materiel_Code'];
              NodeNew('StockName').ValueAsString := nCardItem.Values['con_materiel_name'];
              nMaxNumber := StrToFloatdef(nCardItem.Values['con_quantity'],0)-StrToFloatdef(nCardItem.Values['con_finished_quantity'],0);
              if nMaxNumber<0.000001 then
                nMaxNumber := 0;
              NodeNew('MaxNumber').ValueAsString := FloatToStr(nMaxNumber);
            end;
          end;
        end;

        with Root.NodeNew('EXMG') do
        begin
          NodeNew('MsgTxt').ValueAsString     := 'ҵ��ִ�гɹ�';
          NodeNew('MsgResult').ValueAsString  := sFlag_Yes;
          NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
        end;
      end;
    end;
  finally
    nCardItem.Free;
    nCardData.Free;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  nResponse := FPacker.XMLBuilder.WriteToString;
  WriteLog('TBusWorkerBusinessWebchat.GetPurchaseContractList request='+nRequest);
  WriteLog('TBusWorkerBusinessWebchat.GetPurchaseContractList response='+nResponse);
end;

//��ȡ�ͻ�ע����Ϣ
function TBusWorkerBusinessWebchat.GetCustomerInfo(var nData:string):boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_CustomerInfo;
  function BuildResData:string;
  var
    i:Integer;
    nStr:string;
    nList:TStringList;
  begin
    nList := TStringList.Create;
    try
      for i := Low(nObj.items) to High(nObj.items) do
      begin
        nStr := 'phone=%s,Bindcustomerid=%s,Namepinyin=%s,Email=%s';
        nStr := Format(nStr,[nObj.items[i].Fphone, nObj.items[i].FBindcustomerid,
          nObj.items[i].FNamepinyin, nObj.items[i].FEmail]);
        //nStr := StringReplace(nStr, '\n', #13#10, [rfReplaceAll]);
        nlist.Add(nStr);
      end;
      Result := PackerEncodeStr(nlist.Text);
    finally
      nList.Free;
    end;
  end;
begin
  Result := False;
  nXmlStr := PackerDecodeStr(fin.FData);
  nObj := TWebResponse_CustomerInfo.Create;
  nService := GetReviceWS(True);
  try
    WriteLog('TBusWorkerBusinessWebchat.GetCustomerInfo request='+nXmlStr);
    nResponse := nService.mainfuncs('getCustomerInfo',nXmlStr);
    WriteLog('TBusWorkerBusinessWebchat.GetCustomerInfo response='+nResponse);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nResponse);
    nObj.FPacker := FPacker;
    Result := nObj.ParseWebResponse(nResponse);
    if not Result then
    begin
      nData := nObj.FErrmsg;
      fout.FBase.FErrDesc := nObj.FErrmsg;
      Exit;
    end;
    nData := BuildResData;
    FOut.FData := nData;
  finally
    nObj.Free;
    nService := nil;
  end;  
end;

//��ȡ������Ϣ
function TBusWorkerBusinessWebchat.Get_Shoporders(var nData:string):boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_get_shoporders;
  function BuildResData:string;
  var
    i:Integer;
    nStr:string;
    nList:TStringList;
  begin
    nList := TStringList.Create;
    try
      for i := Low(nObj.items) to High(nObj.items) do
      begin
        nStr := 'order_id=%s,fac_order_no=%s,ordernumber=%s,goodsID=%s,goodstype=%s,goodsname=%s,tracknumber=%s,data=%s\n';
        nStr := Format(nStr,[nObj.items[i].FOrder_id,
          nObj.items[i].Ffac_order_no,
          nObj.items[i].FOrdernumber,
          nObj.items[i].FGoodsID,
          nobj.items[i].FGoodstype,
          nObj.items[i].FGoodsname,
          nObj.items[i].Ftracknumber,
          nobj.items[i].FData]);
        nStr := StringReplace(nStr, '\n', #13#10, [rfReplaceAll]);
        nlist.Add(nStr);
      end;
      Result := PackerEncodeStr(nlist.Text);
    finally
      nList.Free;
    end;
  end;
begin
  Result := False;
  nXmlStr := PackerDecodeStr(fin.FData);
  nObj := TWebResponse_get_shoporders.Create;
  nService := GetReviceWS(True);
  try
    nResponse := nService.mainfuncs('get_shoporders',nXmlStr);
    writelog('TBusWorkerBusinessWebchat.Get_Shoporders request:'+#13+nXmlStr);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nResponse);
    writelog('TBusWorkerBusinessWebchat.Get_Shoporders response:'+#13+nResponse);
    nObj.FPacker := FPacker;
    Result := nObj.ParseWebResponse(nResponse);
    if not Result then
    begin
      nData := nObj.FErrmsg;
      fout.FBase.FErrDesc := nObj.FErrmsg;
      Exit;
    end;
    nData := BuildResData;
    FOut.FData := nData;
  finally
    nObj.Free;
    nService := nil;
  end;  
end;

//���ݶ����Ż�ȡ������Ϣ
function TBusWorkerBusinessWebchat.get_shoporderByNO(var nData:string):boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_get_shoporders;
  nBegin:TDateTime;
  function BuildResData:string;
  var
    i:Integer;
    nStr:string;
    nList:TStringList;
  begin
    nList := TStringList.Create;
    try
      for i := Low(nObj.items) to High(nObj.items) do
      begin
        nStr := 'order_id=%s,fac_order_no=%s,ordernumber=%s,goodsID=%s,goodstype=%s,'+
        'goodsname=%s,tracknumber=%s,proid=%s,data=%s\n';
        nStr := Format(nStr,[nObj.items[i].FOrder_id,
          nObj.items[i].Ffac_order_no,
          nObj.items[i].FOrdernumber,
          nObj.items[i].FGoodsID,
          nobj.items[i].FGoodstype,
          nObj.items[i].FGoodsname,
          nObj.items[i].Ftracknumber,
          nObj.items[i].FProID,
          nobj.items[i].FData]);
        nStr := StringReplace(nStr, '\n', #13#10, [rfReplaceAll]);
        nlist.Add(nStr);
      end;
      Result := PackerEncodeStr(nlist.Text);
    finally
      nList.Free;
    end;
  end;
begin
  nBegin := Now;
  Result := False;
  nXmlStr := PackerDecodeStr(fin.FData);
  nObj := TWebResponse_get_shoporders.Create;
  nService := GetReviceWS(True);
  try
    nResponse := nService.mainfuncs('get_shoporderByNO',nXmlStr);
    writelog('TBusWorkerBusinessWebchat.get_shoporderByNO request:'+#13+nXmlStr);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nResponse);
    writelog('TBusWorkerBusinessWebchat.get_shoporderByNO response:'+#13+nResponse);
    nObj.FPacker := FPacker;
    Result := nObj.ParseWebResponse(nResponse);
    if not Result then
    begin
      nData := nObj.FErrmsg;
      fout.FBase.FErrDesc := nObj.FErrmsg;
      Exit;
    end;
    nData := BuildResData;
    FOut.FData := nData;
  finally
    nObj.Free;
    nService := nil;
  end;
  WriteLog('TBusWorkerBusinessWebchat.get_shoporderByNO-��ʱ��'+InttoStr(MilliSecondsBetween(Now, nBegin))+'ms');  
end;

//�ͻ���΢���˺Ű�
function TBusWorkerBusinessWebchat.Get_Bindfunc(var nData:string):boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_Bindfunc;
begin
  Result := False;
  nXmlStr := PackerDecodeStr(fin.FData);
  nObj := TWebResponse_Bindfunc.Create;
  nService := GetReviceWS(True);
  try
    WriteLog('TBusWorkerBusinessWebchat.et_Bindfunc request:'+nXmlStr);
    nResponse := nService.mainfuncs('get_Bindfunc',nXmlStr);
    WriteLog('TBusWorkerBusinessWebchat.t_Bindfunc response:'+nResponse);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nResponse);
    nObj.FPacker := FPacker;
    Result := nObj.ParseWebResponse(nResponse);
    if not Result then
    begin
      nData := nObj.FErrmsg;
      fout.FBase.FErrDesc := nObj.FErrmsg;
      Exit;
    end;
  finally
    nService := nil;
    nObj.Free;
  end;  
end;

//������Ϣ
function TBusWorkerBusinessWebchat.Send_Event_Msg(var nData:string):boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_send_event_msg;
begin
  Result := False;
  nXmlStr := PackerDecodeStr(fin.FData);
  nObj := TWebResponse_send_event_msg.Create;
  nService := GetReviceWS(True);
  try
    WriteLog('TBusWorkerBusinessWebchat.Send_Event_Msg request:'+#13+nXmlStr);
    nResponse := nService.mainfuncs('send_event_msg',nXmlStr);
    WriteLog('TBusWorkerBusinessWebchat.Send_Event_Msg response:'+#13+nResponse);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nResponse);
    nObj.FPacker := FPacker;
    Result := nObj.ParseWebResponse(nResponse);
    if not Result then
    begin
      nData := nObj.FErrmsg;
      fout.FBase.FErrDesc := nObj.FErrmsg;
      Exit;
    end;
  finally
    nObj.Free;
    nService := nil;
  end;  
end;

//�����̳��û�
function TBusWorkerBusinessWebchat.Edit_ShopClients(var nData:string):boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_edit_shopclients;
begin
  Result := False;
  try
    nXmlStr := PackerDecodeStr(fin.FData);
    nObj := TWebResponse_edit_shopclients.Create;
    nService := GetReviceWS(True);
    try
      WriteLog('TBusWorkerBusinessWebchat.Edit_ShopClients request='+nXmlStr);
      nResponse := nService.mainfuncs('edit_shopclients',nXmlStr);
      WriteLog('TBusWorkerBusinessWebchat.Edit_ShopClients response='+nResponse);
      FPacker.XMLBuilder.Clear;
      FPacker.XMLBuilder.ReadFromString(nResponse);
      nObj.FPacker := FPacker;
      Result := nObj.ParseWebResponse(nResponse);
      if not Result then
      begin
        nData := nObj.FErrmsg;
        fout.FBase.FErrDesc := nObj.FErrmsg;
        Exit;
      end;
    finally
      nObj.Free;
      nService := nil;
    end;
  except
    on E:Exception do
    begin
      WriteLog('TBusWorkerBusinessWebchat.Edit_ShopClients exception='+e.Message);
    end;
  end;
end;

//�����Ʒ
function TBusWorkerBusinessWebchat.Edit_Shopgoods(var nData:string):boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_edit_shopgoods;
begin
  Result := False;
  nXmlStr := PackerDecodeStr(fin.FData);
  nObj := TWebResponse_edit_shopgoods.Create;
  nService := GetReviceWS(True);
  try
    WriteLog('TBusWorkerBusinessWebchat.Edit_Shopgoods request='+nXmlStr);
    nResponse := nService.mainfuncs('edit_shopgoods',nXmlStr);
    WriteLog('TBusWorkerBusinessWebchat.Edit_Shopgoods response='+nResponse);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nResponse);
    nObj.FPacker := FPacker;
    Result := nObj.ParseWebResponse(nResponse);
    if not Result then
    begin
      nData := nObj.FErrmsg;
      fout.FBase.FErrDesc := nObj.FErrmsg;
      Exit;
    end;
  finally
    nObj.Free;
    nService := nil;
  end;  
end;

//�޸Ķ���״̬
function TBusWorkerBusinessWebchat.complete_shoporders(var nData:string):Boolean;
var
  nXmlStr:string;
  nService:ReviceWS;
  nResponse:string;
  nObj:TWebResponse_complete_shoporders;
begin
  Result := False;
  nXmlStr := PackerDecodeStr(fin.FData);
  nObj := TWebResponse_complete_shoporders.Create;
  nService := GetReviceWS(True);
  try
    writelog('TBusWorkerBusinessWebchat.complete_shoporders request'+#13+nXmlStr);
    nResponse := nService.mainfuncs('complete_shoporders',nXmlStr);
    writelog('TBusWorkerBusinessWebchat.complete_shoporders response'+#13+nResponse);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nResponse);
    nObj.FPacker := FPacker;
    Result := nObj.ParseWebResponse(nResponse);
    if not Result then
    begin
      nData := nObj.FErrmsg;
      fout.FBase.FErrDesc := nObj.FErrmsg;
      Exit;
    end;
  finally
    nObj.Free;
    nService := nil;
  end;  
end;


{ TWebResponseBaseInfo }

function TWebResponseBaseInfo.ParseWebResponse(var nData: string): Boolean;
var nNode, nTmp: TXmlNode;
begin
  Result := False;
  FPacker.XMLBuilder.Clear;
  FPacker.XMLBuilder.ReadFromString(nData);
  nNode := FPacker.XMLBuilder.Root.FindNode('Head');
  if not (Assigned(nNode) and Assigned(nNode.FindNode('errcode'))) then
  begin
    FErrmsg := '��Ч�����ڵ�(Head.errcode Null).';
    Exit;
  end;
  if not Assigned(nNode.FindNode('errmsg')) then
  begin
    FErrmsg := '��Ч�����ڵ�(Head.errmsg Null).';
    Exit;
  end;
  nTmp := nNode.FindNode('errcode');
  FErrcode := StrToIntDef(nTmp.ValueAsString, 0);

  nTmp := nNode.FindNode('errmsg');
  FErrmsg:= nTmp.ValueAsString;
  Result := FErrcode=0;  
end;

{ TWebResponse_CustomerInfo }

function TWebResponse_CustomerInfo.ParseWebResponse(
  var nData: string): Boolean;
var nNode, nTmp,nNodeTmp: TXmlNode;
  nIdx,nNodeCount:Integer;  
begin
  Result := inherited ParseWebResponse(nData);
  if Result then
  begin
    nNode := FPacker.XMLBuilder.Root.FindNode('Items');
    if not Assigned(nNode) then
    begin
      FErrmsg := '��Ч�����ڵ�(Items Null).';
      Result := False;
      Exit;
    end;
    if not (Assigned(nNode) and Assigned(nNode.FindNode('Item'))) then
    begin
      FErrmsg := '��Ч�����ڵ�(Items.Item Null).';
      Result := False;
      Exit;
    end;
    
    nNodeCount :=nNode.NodeCount;
    SetLength(items,nNodeCount);

    for nIdx := 0 to nNodeCount-1 do
    begin
      nNodeTmp := nNode.Nodes[nIdx];

      nTmp := nNodeTmp.FindNode('phone');
      items[nIdx].Fphone := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('Bindcustomerid');
      items[nIdx].FBindcustomerid := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('Namepinyin');
      items[nIdx].FNamepinyin := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('Email');
      if Assigned(nTmp) then
      begin
        items[nIdx].FEmail := nTmp.ValueAsString;
      end;
    end;
  end;  
end;

{ TWebResponse_get_shoporders }

function TWebResponse_get_shoporders.ParseWebResponse(
  var nData: string): Boolean;
var nNode, nTmp,nNodeTmp: TXmlNode;
  nIdx,nNodeCount:Integer;  
begin
  Result := inherited ParseWebResponse(nData);
  if Result then
  begin
    nNode := FPacker.XMLBuilder.Root.FindNode('Items');
    if not Assigned(nNode) then
    begin
      FErrmsg := '��Ч�����ڵ�(Items Null).';
      Result := False;
      Exit;
    end;
    if not (Assigned(nNode) and Assigned(nNode.FindNode('Item'))) then
    begin
      FErrmsg := '��Ч�����ڵ�(Items.Item Null).';
      Result := False;
      Exit;
    end;

    nNodeCount :=nNode.NodeCount;
    SetLength(items,nNodeCount);

    for nIdx := 0 to nNodeCount-1 do
    begin
      nNodeTmp := nNode.Nodes[nIdx];

      nTmp := nNodeTmp.FindNode('order_id');
      items[nIdx].FOrder_id := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('fac_order_no');
      items[nIdx].Ffac_order_no := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('ordernumber');
      items[nIdx].FOrdernumber := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('goodsID');
      items[nIdx].FGoodsID := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('goodsname');
      items[nIdx].FGoodsname := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('tracknumber');
      items[nIdx].Ftracknumber := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('data');
      items[nIdx].FData := nTmp.ValueAsString;

      nTmp := nNodeTmp.FindNode('ClientNo');
      items[nIdx].FProID := nTmp.ValueAsString;
    end;
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerBusinessWebchat, sPlug_ModuleBus);
end.
