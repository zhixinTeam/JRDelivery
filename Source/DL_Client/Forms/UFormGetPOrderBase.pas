{*******************************************************************************
  作者: fendou116688@163.com 2015/9/19
  描述: 选择采购申请单
*******************************************************************************}
unit UFormGetPOrderBase;

{$I Link.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxLayoutControl, StdCtrls, cxControls,
  ComCtrls, cxListView, cxButtonEdit, cxLabel, cxLookAndFeels, ADODB,
  cxLookAndFeelPainters, dxLayoutcxEditAdapters, cxCheckBox;

type
  TOrderBaseParam = record
    FID :string;

    FProvID: string;
    FProvName: string;

    FSaleID: string;
    FSaleName: string;

    FArea: string;
    FProject: string;

    FStockNO: string;
    FStockName: string;
    FStockPrc:string;

    FRestValue: string;
  end;
  TOrderBaseParams = array of TOrderBaseParam;

  TfFormGetPOrderBase = class(TfFormNormal)
    EditProvider: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListQuery: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    EditMate: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    ck30Days: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListQueryKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListQueryDblClick(Sender: TObject);
  private
    { Private declarations }
    FResults: TStrings;
    //查询类型
    FOrderData: string;
    //申请单信息
    FOrderItems: TOrderBaseParams;
    function QueryData(const nQueryType: string=''): Boolean;
    function QueryData_zyw(const nQueryType: string=''): Boolean;
    //查询数据
    procedure GetResult;
    //获取结果
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UFormBase, USysGrid, USysDB, 
  USysConst, UDataModule, UBusinessPacker, UFormDateFilter, UMgrDBConn;

class function TfFormGetPOrderBase.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetPOrderBase.Create(Application) do
  begin
    Caption := '选择申请单';
    FResults.Clear;
    SetLength(FOrderItems, 0);

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := PackerEncodeStr(FOrderData);
    end;
    Free;
  end;
end;

class function TfFormGetPOrderBase.FormID: integer;
begin
  Result := cFI_FormGetPOrderBase;
end;

procedure TfFormGetPOrderBase.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;

  FResults := TStringList.Create;
end;

procedure TfFormGetPOrderBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;

  FResults.Free;
end;

//------------------------------------------------------------------------------
//Date: 2015-01-22
//Desc: 按指定类型查询
function TfFormGetPOrderBase.QueryData(const nQueryType: string=''): Boolean;
var nStr, nQuery: string;
    nIdx: Integer;
begin
  Result := False;
  ListQuery.Items.Clear;

  nStr := 'Select *,(B_Value-B_SentValue-B_FreezeValue) As B_MaxValue From $TB ' +
          'Where ((B_Value-B_SentValue>0) or (B_Value=0)) ' +
          'And B_BStatus=''Y'' ';
  if nQueryType = '1' then //供应商
  begin
    nQuery := Trim(EditProvider.Text);
    nStr := nStr + 'And ((B_ProID like ''%%$QUERY%%'') ' +
            'or (B_ProName  like ''%%$QUERY%%'') ' +
            'or (B_ProPY  like ''%%$QUERY%%'')) ';
  end
  else if nQueryType = '2' then //原材料
  begin
    nQuery := Trim(EditMate.Text);
    nStr := nStr + 'And ((B_StockName like ''%%$QUERY%%'') ' +
            'or (B_StockNo  like ''%%$QUERY%%'')) ';
  end else Exit;

  nStr := MacroValue(nStr , [MI('$TB', sTable_OrderBase),
          MI('$QUERY', nQuery)]);


  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    SetLength(FOrderItems, RecordCount);
    nIdx := Low(FOrderItems);

    while not Eof do
    with FOrderItems[nIdx] do
    begin
      FID       := FieldByName('B_ID').AsString;
      FProvID   := FieldByName('B_ProID').AsString;
      FProvName := FieldByName('B_ProName').AsString;
      FSaleID   := FieldByName('B_SaleID').AsString;
      FSaleName := FieldByName('B_SaleMan').AsString;
      FStockNO  := FieldByName('B_StockNO').AsString;
      FStockName:= FieldByName('B_StockName').AsString;
      FArea     := FieldByName('B_Area').AsString;
      FProject  := FieldByName('B_Project').AsString;
      
      if FieldByName('B_Value').AsFloat>0 then
           FRestValue:= Format('%.2f', [FieldByName('B_MaxValue').AsFloat])
      else FRestValue := '0.00';

      if (FieldByName('B_MaxValue').AsFloat>0)
        or (FieldByName('B_Value').AsFloat<=0) then
      with ListQuery.Items.Add do
      begin
        Caption := FID;
        SubItems.Add(FStockName);
        SubItems.Add(FProvName);
        SubItems.Add(FRestValue);
        ImageIndex := cItemIconIndex;
      end;

      Inc(nIdx);
      Next;
    end;

    ListQuery.ItemIndex := 0;
    Result := True;
  end;
end;

procedure TfFormGetPOrderBase.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nQueryType: string;
begin
  if Sender = EditProvider then
       nQueryType := '1'
  else nQueryType := '2';
  {$IFDEF XzdERP_A3}
  if QueryData_zyw(nQueryType) then ListQuery.SetFocus;
  {$ELSE}
  if QueryData(nQueryType) then ListQuery.SetFocus;
  {$ENDIF}
end;

//Desc: 获取结果
procedure TfFormGetPOrderBase.GetResult;
var nIdx: Integer;
begin
  with ListQuery.Selected do
  begin
    for nIdx:=Low(FOrderItems) to High(FOrderItems) do
    with FOrderItems[nIdx], FResults do
    begin
      if CompareText(FID, Caption)=0 then
      begin
        Values['SQ_ID']       := FID;
        Values['SQ_ProID']    := FProvID;
        Values['SQ_ProName']  := FProvName;
        Values['SQ_SaleID']   := FSaleID;
        Values['SQ_SaleName'] := FSaleName;
        Values['SQ_StockNO']  := FStockNO;
        Values['SQ_StockName']:= FStockName;
        Values['SQ_Area']     := FArea;
        Values['SQ_Project']  := FProject;
        Values['SQ_RestValue']:= FRestValue;
        Values['SQ_StockPrc']:= FStockPrc;

        Break;
      end;  
    end;  
  end;

  FOrderData := FResults.Text;
end;

procedure TfFormGetPOrderBase.ListQueryKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if ListQuery.ItemIndex > -1 then
    begin
      GetResult;
      ModalResult := mrOk;
    end;
  end;
end;

procedure TfFormGetPOrderBase.ListQueryDblClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end;
end;

procedure TfFormGetPOrderBase.BtnOKClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end else ShowMsg('请在查询结果中选择', sHint);
end;

//2017-09-19 新中大取订单详情
function TfFormGetPOrderBase.QueryData_zyw(
  const nQueryType: string): Boolean;
var
  nDBWorker: PDBWorker;
  nAdoJR : TADOConnection;
  nAdoQryJr: TADOQuery;
  nStr, nQuery, nConstr, nUser,nPwd,nDBName,nServer: string;
  nIdx: Integer;
  nIni : TIniFile;
begin
  try
    nIni := TIniFile.Create('.\DBConn_zyw.ini');
    nUser := nIni.ReadString('锦荣','DBUser','');
    nPwd := nIni.ReadString('锦荣','DBPwd','');
    nDBName := nIni.ReadString('锦荣','DBCatalog','');
    nServer := nIni.ReadString('锦荣','DBSource','');
    nIni.Free;

    nAdoJR := TADOConnection.Create(Self);
    nAdoQryJr := TADOQuery.Create(Self);
    with nAdoJR do
    begin
      nConstr := 'Provider=SQLOLEDB.1;Password= %s;Persist Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s';
      nConstr := Format(nConstr, [nPwd, nUser, nDBName, nServer]);
      ConnectionString := nconstr;
      LoginPrompt := False;
      Open;
    end;
    nAdoQryJr.Connection := nAdoJR;

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

    if ck30Days.Checked then
      nStr := nStr + ' and rcvmst.rcvdt>= '+''''+ FormatDateTime('yyyy-mm-dd',now-30)+'''';

    if nQueryType = '1' then //供应商
    begin
      nQuery := Trim(EditProvider.Text);
      nStr := nStr + ' And ((enterprise.compno like ''%%$QUERY%%'') ' +
            'or (enterprise.compname  like ''%%$QUERY%%'') ' +
            'or (enterprise.spell like ''%%$QUERY%%'')) ';
    end
    else
    if nQueryType = '2' then //物料
    begin
      nQuery := Trim(EditMate.Text);
      nStr := nStr + ' And ((itemdata.itemno like ''%%$QUERY%%'') ' +
              'or (itemdata.itemname  like ''%%$QUERY%%'') ' +
              'or (itemdata.spell  like ''%%$QUERY%%'')) ';
    end
    else exit;

    nStr := MacroValue(nStr , [ MI('$QUERY', nQuery)]);

    with nAdoQryJr do
    begin
      Close;
      SQL.Clear;
      sql.Add(nStr);
      Open;
    end;

    with nAdoQryJr do
    if RecordCount > 0 then
    begin
      First;

      SetLength(FOrderItems, RecordCount);
      nIdx := Low(FOrderItems);

      while not Eof do
      with FOrderItems[nIdx] do
      begin
        FID       := FieldByName('srcvno').AsString;
        FProvID   := FieldByName('compno').AsString;
        FProvName := FieldByName('compName').AsString;
        FSaleID   := FieldByName('purpsn').AsString;
        FSaleName := FieldByName('lastname').AsString;
        FStockNO  := FieldByName('itemno').AsString;
        FStockName:= FieldByName('itemName').AsString;
        FStockPrc := Format('%.4f', [FieldByName('rcvprc').AsFloat]);
        
        FArea     := '';
        FProject  := '';
        if FieldByName('B_MaxValue').AsFloat>0 then
             FRestValue:= Format('%.2f', [FieldByName('B_MaxValue').AsFloat])
        else FRestValue := '0.00';

        if (FieldByName('B_MaxValue').AsFloat>0) then
        with ListQuery.Items.Add do
        begin
          Caption := FID;
          SubItems.Add(FStockName);
          SubItems.Add(FProvName);
          SubItems.Add(FRestValue);
          ImageIndex := cItemIconIndex;
        end;

        Inc(nIdx);
        Next;
      end;
      ListQuery.ItemIndex := 0;
      Result := True;
    end;
  finally
    nAdoQryJr.Destroy;
    nAdoJR.Destroy;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormGetPOrderBase, TfFormGetPOrderBase.FormID);
end.
