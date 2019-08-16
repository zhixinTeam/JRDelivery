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
  USysLoger, USysDB, UMITConst, IdHTTP, superobject;

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
    HttpClient: TIdHTTP;
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
    procedure SaveHyDanEvent(const nStockno,nEvent,
          nFrom,nSolution,nDepartment: string);
    //生成化验单推送事件
    function GetRemoteCusFromNC(var nCode,nRet:string):Boolean;
    //从NC获取往来单位
    function SyncRemoteCustomer(var nData: string): Boolean;
    //同步客户
    function GetRemoteCusMoney(var nCode:string;var nMoney:Double):Boolean;
    //从NC获取往来单位资金

    function SyncBillToNC_Bak(var nData: string):Boolean;    //不影响出厂，在用
    function SyncBillToNC(var nNo,nType:string):Boolean;     //停用方案
    function SyncRemoteStockBill(var nData: string): Boolean;
    //同步交货单到备用库
    function SyncRemoteStockOrder(var nData: string): Boolean;
    //同步采购单到备用库
    function SyncSalesmanFromNC(var nData:string):Boolean;
    //同步业务员
    
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
  HttpClient := TIdHttp.Create();
  inherited;
end;

destructor TWorkerBusinessCommander.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  HttpClient.Free;
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
   
   cBC_SyncStockBill       : Result := SyncRemoteStockBill(nData);
   cBC_SyncBillToNC        : Result := SyncBillToNC_Bak(nData);
   cBC_SyncSaleMan         : Result := SyncSalesmanFromNC(nData);
   cBC_SyncStockOrder      : Result := SyncRemoteStockOrder(nData);
   cBC_SyncCustomer        : Result := SyncRemoteCustomer(nData);

   {$IFDEF UseK3SalePlan}
   cBC_LoadSalePlan        : Result := GetSalePlan(nData);
   {$ENDIF}
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
          'or C_Card3=''%s'' or C_Card2=''%s''';
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
    nVal,nCredit,nFreeze: Double;
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
    nFreeze := FieldByName('A_FreezeMoney').AsFloat;

    if FieldByName('A_FromNC').AsString = sflag_yes then
    begin
      if not GetRemoteCusMoney(FIn.FData, nVal) then
      begin
        nData := '从用友获取客户资金余额失败.';
        Result := False;
        exit;
      end;

      nVal := nVal - nFreeze;
      FOut.FData := FloatToStr(nVal);
      FOut.FExtParam := '0';
    end
    else
    begin
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
    end;
    Result := True;
  end;
end;
{$ENDIF}

{$IFDEF COMMON}
//Date: 2014-09-05
//Desc: 获取指定纸卡的可用金额
function TWorkerBusinessCommander.GetZhiKaValidMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nMoney,nCredit,nFreezeMoney: Double;
    nCusID: string;
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
    nCusID := FieldByName('A_CId').AsString;
    nFreezeMoney := FieldByName('A_FreezeMoney').AsFloat;

    //如果是从NC同步的
    if FieldByName('A_FromNC').AsString = sFlag_Yes then
    begin
      if not GetRemoteCusMoney(nCusID,nVal) then
      begin
        nData := 'Get纸卡:GetRemoteCusMoney调用NC接口失败.';
        WriteLog(nData);
        Exit;
      end;
      nVal := nVal - nFreezeMoney;
    end
    else
    begin
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
      {$IFDEF SaveHyDanEvent}
      SaveHyDanEvent(FIn.FData,nData,sFlag_DepDaTing,sFlag_Solution_OK,sFlag_DepHuaYan);
      {$ENDIF}
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

  if FOut.FBase.FErrCode = sFlag_ForceHint then
  begin
    {$IFDEF SaveHyDanEvent}
    SaveHyDanEvent(FIn.FData,FOut.FBase.FErrDesc,
                   sFlag_DepDaTing,sFlag_Solution_OK,sFlag_DepHuaYan);
    {$ENDIF}
  end;
  Result := True;
  FOut.FBase.FResult := True;
end;

{$IFDEF UseERP_K3}
{$ENDIF}

{$IFDEF UseK3SalePlan}
{$ENDIF}

procedure TWorkerBusinessCommander.SaveHyDanEvent(const nStockno,nEvent,
          nFrom,nSolution,nDepartment: string);
var
  nStr:string;
  nEID:string;
begin
  try
    nEID := nStockno + FormatDateTime('YYYYMMDD',Now);
    nStr := 'Delete From %s Where E_ID=''%s''';
    nStr := Format(nStr, [sTable_ManualEvent, nEID]);

    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := MakeSQLByStr([
        SF('E_ID', nEID),
        SF('E_Key', ''),
        SF('E_From', nFrom),
        SF('E_Event', nEvent),
        SF('E_Solution', nSolution),
        SF('E_Departmen', nDepartment),
        SF('E_Date', sField_SQLServer_Now, sfVal)
        ], sTable_ManualEvent, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  except
    on E: Exception do
    begin
      WriteLog(e.message);
    end;
  end;
end;

//Date: 2019-04-09
//Param: 编号
//Desc: 调用同步客户接口
function TWorkerBusinessCommander.GetRemoteCusFromNC(var nCode, nRet: string): Boolean;
var                                                                                            
  nAPIUrl:string;                                                                              
  nNCOut: TStringStream;
begin
  Result := False;
  nAPIUrl := gAPIUrl + sFlag_GetReceive;
  if Trim(nCode) <> '' then
    nAPIUrl := nAPIUrl+'?partnerCode='+nCode;
  //WriteLog('zyww::'+napiurl);
  try
    nNCOut := TStringStream.Create('');
    try
      HttpClient.Get(nAPIUrl,nNCOut);
    except
      WriteLog('GetRemoteCus调用NC接口失败.');
      Exit;
    end;
    nRet := UTF8Decode(nNCOut.DataString);
    Result := True;
  finally
    nNCOut.Free;
  end;
end;

//Date: 2019-03-09
//Desc: 同步客户
function TWorkerBusinessCommander.SyncRemoteCustomer(var nData: string): Boolean;
var nStr, nCus: string;
    nIdx, nCount, nTotal: Integer;
    jo : ISuperObject;
    ja : TSuperArray;
    nID: string;
    nOut: TWorkerBusinessCommand;
begin
  Result := True;
  nCount := 0;

  try
    if not GetRemoteCusFromNC(nCus,nStr) then Exit;
    jo := SO(nStr);
    ja := jo['DataSource.Rows'].AsArray;
    nTotal := ja.Length;
    if nTotal = 0 then
    begin
      nData := '用友T+接口返回的用户数据为空.';
      Result := False;
      Exit;
    end;
  except
    nData := '调用用友T+接口出错.';
    Result := False;
    Exit;
  end;

  for nIdx := 0 to ja.Length - 1 do
  begin
    nStr := 'select * from %s where  C_NCID=''%s'' and C_JxsId=''%s''';
    nStr := Format(nStr,[sTable_Customer, ja[nidx]['partnerCode'].AsString,
            ja[nidx]['ProjectCode'].AsString]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do                                            
    begin
      if recordcount <= 0 then                                                                    
      begin
        FListC.Clear;
        FListC.Values['Group'] := sFlag_BusGroup;
        FListC.Values['Object'] := sFlag_Customer;

        if not CallMe(cBC_GetSerialNO,FListC.Text, sFlag_No, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx

        nID := nOut.FData;
        FDBConn.FConn.BeginTrans;
        try
          if Trim(ja[nidx]['ProjectName'].AsString)= '' then
            nCus := ja[nidx]['partnerName'].AsString
          else
            nCus := ja[nidx]['partnerName'].AsString+' - '+ja[nidx]['ProjectName'].AsString;

          nStr := MakeSQLByStr([
                    SF('C_ID',          nID),
                    SF('C_Name',        nCus),
                    SF('C_PY',          GetPinYinOfStr(ja[nidx]['partnerName'].AsString+ja[nidx]['ProjectName'].AsString)),
                    SF('C_NCID',        ja[nidx]['partnerCode'].AsString),
                    SF('C_NCName',      ja[nidx]['partnerName'].AsString),
                    SF('C_JxsID',       ja[nidx]['ProjectCode'].AsString),
                    SF('C_JxsName',     ja[nidx]['ProjectName'].AsString),
                    SF('C_XuNi',        sFlag_No),
                    SF('C_FromNC',      sFlag_Yes)
                    ], sTable_Customer,         '',      True);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          nStr := 'Insert Into %s(A_CID,A_FromNC,A_Date) Values(''%s'',''%s'', ''%s'')';
          nStr := Format(nStr, [sTable_CusAccount, nID, sFlag_Yes, DateTime2Str(now)]);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          FDBConn.FConn.CommitTrans;
          Inc(nCount);
        except
          Result := False;
          FDBConn.FConn.RollbackTrans;
          nData := '同步失败,过程中断,本次成功同步:['+inttostr(nCount)+']条数据';
          Exit;
        end;
      end;
    end;                                                                                         
  end;
  nData := '同步完成,本次新增:['+inttostr(nCount)+']条数据';
end;

function TWorkerBusinessCommander.GetRemoteCusMoney(var nCode: string;var nMoney:Double): Boolean;
var
  nAPIUrl, nStr, nNcId,nJxsId:string;
  nNCOut: TStringStream;
  jo:ISuperObject;
  ja:TSuperArray;
  nIdx: Integer;
begin
  Result := False;
  nStr := 'select * from %s where C_ID=''%s''';
  nStr := Format(nStr,[sTable_Customer,nCode]);
  with gDBConnManager.WorkerQuery(FDBConn,nStr) do
  begin
    nNcId := fieldbyname('C_NCID').AsString;
    nJxsId := fieldbyname('C_JxsID').AsString;
  end;


  nAPIUrl := gAPIUrl + sFlag_GetReceive +'?partnerCode='+nNcId;
  writelog('调用客户['+nNcId+'],经销商['+njxsid+']可用金入参:'+napiurl);

  try
    nNCOut := TStringStream.Create('');
    try
      HttpClient.Get(nAPIUrl,nNCOut);
    except
      nCode := 'GetRemoteCusMoney调用NC接口失败.';
      WriteLog(nCode);
      Exit;
    end;
    writelog('调用客户['+nNcId+'],经销商['+njxsid+']可用金出参解码前:'+EncodeBase64(nNCOut.DataString));

    writelog('调用客户['+nNcId+'],经销商['+njxsid+']可用金出参解码后:'+UTF8Decode(nNCOut.DataString));

    jo := so(UTF8Decode(nNCOut.DataString));
    ja := jo['DataSource.Rows'].AsArray;
    if ja.Length = 0 then
    begin
      nCode := '客户 ['+ncode+'] 调用queryReceive未获取查询结果.s';
      WriteLog(nCode);
      Exit;
    end;

    for nIdx := 0 to ja.Length -1 do
    begin
      if (nNcId = ja[nidx]['partnerCode'].AsString) and
        (nJxsId = ja[nidx]['ProjectCode'].AsString) then
      begin
        nMoney := - ja[nidx]['origBalanceAmount'].AsDouble;
        Result := true;
        Exit;
      end;
    end;
  finally
    nNCOut.Free;
  end;
end;            


function TWorkerBusinessCommander.SyncRemoteStockBill(
  var nData: string): Boolean;
var
  nBakWork:PDBWorker;
  nStr, nSQL, nType:string;
  nIdx: Integer;
begin
  Result := False;
  nBakWork := nil;
  nStr := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);

  {if not SyncBillToNC(nStr,nType) then
  begin
    nData := nType;
    exit;
  end;}
  //向用友推单

  FListA.Clear;
  try
    nBakWork := gDBConnManager.GetConnection(sFlag_BakDB, FErrNum);
    if not Assigned(nBakWork) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not nBakWork.FConn.Connected then
      nBakWork.FConn.Connected := True;
    //conn db

    nSQL := 'select * From $BL where L_ID In ($IN)';
    nSQL := MacroValue(nSQL, [MI('$BL', sTable_Bill) , MI('$IN', nStr)]);

    with gDBConnManager.WorkerQuery(nBakWork,nSQL) do
    begin
      if RecordCount > 0 then
      begin
        Result := True;
        Exit;
      end;
    end;

    with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
    begin
      if RecordCount < 1 then
      begin
        nData := '编号为[ %s ]的交货单不存在.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      First;
      while not Eof do
      begin
        nSQL := MakeSQLByStr([
                    SF('L_ID',              FieldByName('L_ID').AsString),
                    SF('L_ZhiKa',           FieldByName('L_ZhiKa').AsString),
                    SF('L_Project',         FieldByName('L_Project').AsString),
                    SF('L_Area',            FieldByName('L_Area').AsString),
                    SF('L_CusID',           FieldByName('L_CusID').AsString),
                    SF('L_CusName',         FieldByName('L_CusName').AsString),
                    SF('L_CusPY',           FieldByName('L_CusPY').AsString),
                    SF('L_SaleID',          FieldByName('L_SaleID').AsString),
                    SF('L_SaleMan',         FieldByName('L_SaleMan').AsString),
                    SF('L_Type',            FieldByName('L_Type').AsString),
                    SF('L_StockNo',         FieldByName('L_StockNo').AsString),
                    SF('L_StockName',       FieldByName('L_StockName').AsString),
                    SF('L_Value',           FieldByName('L_Value').AsFloat),
                    SF('L_Price',           FieldByName('L_Price').AsFloat),
                    //SF('L_ZKMoney',         FieldByName('L_ZKMoney').AsFloat),
                    SF('L_Truck',           FieldByName('L_Truck').AsString),
                    SF('L_Status',          sFlag_TruckOut),              //FieldByName('L_Status').AsString),
                    //SF('L_NextStatus',      FieldByName('L_NextStatus').AsString),
                    SF('L_InTime',          FieldByName('L_InTime').AsDateTime),
                    SF('L_InMan',           FieldByName('L_InMan').AsString),
                    SF('L_PValue',          FieldByName('L_PValue').AsFloat),
                    SF('L_PDate',           FieldByName('L_PDate').AsDateTime),
                    SF('L_PMan',            FieldByName('L_PMan').AsString),
                    SF('L_MValue',          FieldByName('L_MValue').AsFloat),
                    SF('L_MDate',           FieldByName('L_MDate').AsDateTime),
                    SF('L_MMan',            FieldByName('L_MMan').AsString),
                    SF('L_LadeTime',        FieldByName('L_LadeTime').AsDateTime),
                    SF('L_LadeMan',         FieldByName('L_LadeMan').AsString),
                    SF('L_LadeLine',        FieldByName('L_LadeLine').AsString),
                    SF('L_LineName',        FieldByName('L_LineName').AsString),
                    SF('L_DaiTotal',        FieldByName('L_DaiTotal').AsFloat),
                    SF('L_DaiNormal',       FieldByName('L_DaiNormal').AsFloat),
                    SF('L_OutFact',         sField_SQLServer_Now, sfVal),
                    SF('L_OutMan',          FieldByName('L_OutMan').AsString),
                    SF('L_PrintGLF',        FieldByName('L_PrintGLF').AsString),
                    SF('L_Lading',          FieldByName('L_Lading').AsString),
                    SF('L_IsVIP',           FieldByName('L_IsVIP').AsString),
                    SF('L_Seal',            FieldByName('L_Seal').AsString),
                    SF('L_HYDan',           FieldByName('L_HYDan').AsString),
                    SF('L_PrintHY',         FieldByName('L_PrintHY').AsString),
                    SF('L_EmptyOut',        FieldByName('L_EmptyOut').AsString),
                    SF('L_Man',             FieldByName('L_Man').AsString),
                    SF('L_Date',            FieldByName('L_Date').AsDateTime),
                    SF('L_CusType',         FieldByName('L_CusType').AsString),
                    //SF('L_DelMan',          FieldByName('L_DelMan').AsString),
                    //SF('L_DelDate',         FieldByName('L_DelDate').AsString),
                    SF('L_Memo',            FieldByName('L_Memo').AsString)
                    ], sTable_Bill,         '',      True);
        FListA.Add(nSQL);

        Next;
      end;
    end;

    nSQL := 'select * From $PL where P_Bill In ($IN)';
    nSQL := MacroValue(nSQL, [MI('$PL', sTable_PoundLog) , MI('$IN', nStr)]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nSQL := MakeSQLByStr([
                    SF('P_ID',              FieldByName('P_ID').AsString),
                    SF('P_Type',            FieldByName('P_Type').AsString),
                    SF('P_Order',           FieldByName('P_Order').AsString),
                    SF('P_Bill',            FieldByName('P_Bill').AsString),
                    SF('P_Truck',           FieldByName('P_Truck').AsString),
                    SF('P_CusID',           FieldByName('P_CusID').AsString),
                    SF('P_CusName',         FieldByName('P_CusName').AsString),
                    SF('P_MID',             FieldByName('P_MID').AsString),
                    SF('P_MName',           FieldByName('P_MName').AsString),
                    SF('P_MType',           FieldByName('P_MType').AsString),
                    SF('P_LimValue',        FieldByName('P_LimValue').AsString),
                    SF('P_PValue',          FieldByName('P_PValue').AsFloat),
                    SF('P_PDate',           FieldByName('P_PDate').AsDateTime),
                    SF('P_PMan',            FieldByName('P_PMan').AsString),
                    SF('P_MValue',          FieldByName('P_MValue').AsFloat),
                    SF('P_MDate',           FieldByName('P_MDate').AsDateTime),
                    SF('P_MMan',            FieldByName('P_MMan').AsString),
                    SF('P_FactID',          FieldByName('P_FactID').AsString),
                    SF('P_PStation',        FieldByName('P_PStation').AsString),
                    SF('P_MStation',        FieldByName('P_MStation').AsString),
                    SF('P_Direction',       FieldByName('P_Direction').AsString),
                    SF('P_PModel',          FieldByName('P_PModel').AsString),
                    SF('P_Status',          FieldByName('P_Status').AsString),
                    SF('P_Valid',           FieldByName('P_Valid').AsString),
                    SF('P_KZValue',         FieldByName('P_KZValue').AsFloat),
                    //SF('P_DelMan',          FieldByName('P_DelMan').AsString),
                    //SF('P_DelDate',         FieldByName('P_DelDate').AsDateTime),
                    SF('P_Memo',            FieldByName('P_Memo').AsString)
                    ], sTable_PoundLog,        '',      True);
                    
          FListA.Add(nSQL);
          Next;
        end;
      end;
    end;

    nBakWork.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nBakWork, FListA[nIdx]);
      //xxxxx

      nBakWork.FConn.CommitTrans;
      Result := True;
    except
      nBakWork.FConn.RollbackTrans;
      nStr := '同步交货单数据到备用数据库失败.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nBakWork);
  end;
end;

function TWorkerBusinessCommander.SyncSalesmanFromNC(
  var nData: string): Boolean;
var                                                                                            
  nAPIUrl, nStr:string;
  nNCOut: TStringStream;
  jo : ISuperObject;
  ja : TSuperArray;
  nTotal, nIdx: Integer;
  nList: TStrings;
begin
  Result := False;
  nAPIUrl := gAPIUrl + 'queryPerson';

  try
    nList := TStringList.Create;
    nNCOut := TStringStream.Create('');
    try
      HttpClient.Get(nAPIUrl,nNCOut);
    except
      WriteLog('GetRemoteCus调用NC接口失败.');
      Exit;
    end;

    nStr := UTF8Decode(nNCOut.DataString);
    jo := SO(nStr);
    ja := jo.AsArray;
    nTotal := ja.Length;
    if nTotal = 0 then
    begin
      nData := '用友T+接口返回的用户数据为空.';
      Exit;
    end;

    for nIdx := 0 to ja.Length - 1 do
    begin
      nStr := 'select * from %s where  S_ID=''%s''';
      nStr := Format(nStr,[sTable_Salesman, ja[nidx]['Code'].AsString]);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do                                            
      begin
        if recordcount <= 0 then                                                                    
        begin
          nStr := MakeSQLByStr([
                    SF('S_ID',          ja[nidx]['Code'].AsString),
                    SF('S_Name',        ja[nidx]['Name'].AsString),
                    SF('S_Py',          ja[nidx]['Shorthand'].AsString),
                    SF('S_InValid',     sflag_no)
                    ], sTable_Salesman,         '',      True);

          nList.Add(nStr);
        end;
      end;
    end;

    if nlist.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;
      //开启事务

      for nIdx:=0 to nlist.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, nList[nIdx]);

      FDBConn.FConn.CommitTrans;
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;

    Result := True;
  finally
    nNCOut.Free;
  end;
end;

function TWorkerBusinessCommander.SyncRemoteStockOrder(
  var nData: string): Boolean;
var
  nBakWork:PDBWorker;
  nStr, nSQL, nType:string;
  nIdx: Integer;
begin
  Result := False;
  nBakWork := nil;

  FListA.Clear;
  try
    nBakWork := gDBConnManager.GetConnection(sFlag_BakDB, FErrNum);
    if not Assigned(nBakWork) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not nBakWork.FConn.Connected then
      nBakWork.FConn.Connected := True;
    //conn db

    nSQL := 'select * From $BL where D_ID =''$IN''';
    nSQL := MacroValue(nSQL, [MI('$BL', sTable_OrderDtl) , MI('$IN', FIn.FData)]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
    begin
      if RecordCount < 1 then
      begin
        nData := '编号为[ %s ]的采购单不存在.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      First;
      while not Eof do
      begin
        nSQL := MakeSQLByStr([
                    SF('D_ID',           FieldByName('D_ID').AsString),
                    SF('D_OID',          FieldByName('D_OID').AsString),
                    SF('D_PID',          FieldByName('D_PID').AsString),
                    SF('D_Area',         FieldByName('D_Area').AsString),
                    SF('D_Project',      FieldByName('D_Project').AsString),
                    SF('D_Truck',        FieldByName('D_Truck').AsString),
                    SF('D_ProID',        FieldByName('D_ProID').AsString),
                    SF('D_ProName',      FieldByName('D_ProName').AsString),
                    SF('D_ProPY',        FieldByName('D_ProPY').AsString),
                    SF('D_SaleID',       FieldByName('D_SaleID').AsString),
                    SF('D_SaleMan',      FieldByName('D_SaleMan').AsString),
                    SF('D_SalePY',       FieldByName('D_SalePY').AsString),
                    SF('D_Type',         FieldByName('D_Type').AsString),
                    SF('D_StockNo',      FieldByName('D_StockNo').AsString),
                    SF('D_StockName',    FieldByName('D_StockName').AsString),
                    SF('D_DStatus',      FieldByName('D_DStatus').AsString),
                    SF('D_Status',       sFlag_TruckOut),            //FieldByName('D_Status').AsString),
                    SF('D_InTime',       FieldByName('D_InTime').AsString),
                    SF('D_InMan',        FieldByName('D_InMan').AsString),
                    SF('D_PValue',       FieldByName('D_PValue').AsFloat),
                    SF('D_PDate',        FieldByName('D_PDate').AsString),
                    SF('D_PMan',         FieldByName('D_PMan').AsString),
                    SF('D_MValue',       FieldByName('D_MValue').AsFloat),
                    SF('D_MDate',        FieldByName('D_MDate').AsString),
                    SF('D_MMan',         FieldByName('D_MMan').AsString),
                    SF('D_YTime',        FieldByName('D_YTime').AsString),
                    SF('D_YMan',         FieldByName('D_YMan').AsString),
                    SF('D_Value',        FieldByName('D_Value').AsFloat),
                    SF('D_KZValue',      FieldByName('D_KZValue').AsFloat),
                    SF('D_AKValue',      FieldByName('D_AKValue').AsFloat),
                    SF('D_YLine',        FieldByName('D_YLine').AsString),
                    SF('D_YLineName',    FieldByName('D_YLineName').AsString),
                    SF('D_YSResult',     FieldByName('D_YSResult').AsString),
                    SF('D_OutFact',      sField_SQLServer_Now, sfVal),
                    SF('D_Memo',         FieldByName('D_Memo').AsString)
                    ], sTable_OrderDtl,         '',      True);
        FListA.Add(nSQL);

        Next;
      end;

      //先检索在备用库是否存在，以排除长期卡
      nStr := FieldByName('D_OID').AsString;
      nSQL := 'select * from %s where O_ID=''%s''';
      nSQL := Format(nSQL,[sTable_Order,nStr]);
      with gDBConnManager.WorkerQuery(nBakWork, nSQL)  do
      if RecordCount = 0 then
      begin
        with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
        if RecordCount> 0 then
        begin
          nSQL := MakeSQLByStr([
                  SF('O_ID',           FieldByName('O_ID').AsString),
                  SF('O_BID',          FieldByName('O_BID').AsString),
                  SF('O_CType',        FieldByName('O_CType').AsString),
                  SF('O_Value',        FieldByName('O_Value').AsFloat),
                  SF('O_Area',         FieldByName('O_Area').AsString),
                  SF('O_Project',      FieldByName('O_Project').AsString),
                  SF('O_ProID',        FieldByName('O_ProID').AsString),
                  SF('O_ProName',      FieldByName('O_ProName').AsString),
                  SF('O_ProPY',        FieldByName('O_ProPY').AsString),
                  SF('O_SaleID',       FieldByName('O_SaleID').AsString),
                  SF('O_SaleMan',      FieldByName('O_SaleMan').AsString),
                  SF('O_SalePY',       FieldByName('O_SalePY').AsString),
                  SF('O_Type',         FieldByName('O_Type').AsString),
                  SF('O_StockNo',      FieldByName('O_StockNo').AsString),
                  SF('O_StockName',    FieldByName('O_StockName').AsString),
                  SF('O_Truck',        FieldByName('O_Truck').AsString),
                  SF('O_OStatus',      FieldByName('O_OStatus').AsString),
                  SF('O_Man',          FieldByName('O_Man').AsString),
                  SF('O_Date',         FieldByName('O_Date').AsString),
                  SF('O_DelMan',       FieldByName('O_DelMan').AsString),
                  SF('O_DelDate',      FieldByName('O_DelDate').AsString),
                  SF('O_Memo',         FieldByName('O_Memo').AsString),
                  SF('O_StockPrc',     FieldByName('O_StockPrc').AsFloat)
                  ], sTable_Order,         '',      True);
          FListA.Add(nSQL);
        end;
      end;
    end;

    nSQL := 'select * From $PL where P_Order = ''$IN''';
    nSQL := MacroValue(nSQL, [MI('$PL', sTable_PoundLog) , MI('$IN', FIn.FData)]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nSQL := MakeSQLByStr([
                    SF('P_ID',              FieldByName('P_ID').AsString),
                    SF('P_Type',            FieldByName('P_Type').AsString),
                    SF('P_Order',           FieldByName('P_Order').AsString),
                    SF('P_Bill',            FieldByName('P_Bill').AsString),
                    SF('P_Truck',           FieldByName('P_Truck').AsString),
                    SF('P_CusID',           FieldByName('P_CusID').AsString),
                    SF('P_CusName',         FieldByName('P_CusName').AsString),
                    SF('P_MID',             FieldByName('P_MID').AsString),
                    SF('P_MName',           FieldByName('P_MName').AsString),
                    SF('P_MType',           FieldByName('P_MType').AsString),
                    SF('P_LimValue',        FieldByName('P_LimValue').AsFloat),
                    SF('P_PValue',          FieldByName('P_PValue').AsFloat),
                    SF('P_PDate',           FieldByName('P_PDate').AsDateTime),
                    SF('P_PMan',            FieldByName('P_PMan').AsString),
                    SF('P_MValue',          FieldByName('P_MValue').AsFloat),
                    SF('P_MDate',           FieldByName('P_MDate').AsDateTime),
                    SF('P_MMan',            FieldByName('P_MMan').AsString),
                    SF('P_FactID',          FieldByName('P_FactID').AsString),
                    SF('P_PStation',        FieldByName('P_PStation').AsString),
                    SF('P_MStation',        FieldByName('P_MStation').AsString),
                    SF('P_Direction',       FieldByName('P_Direction').AsString),
                    SF('P_PModel',          FieldByName('P_PModel').AsString),
                    SF('P_Status',          FieldByName('P_Status').AsString),
                    SF('P_Valid',           FieldByName('P_Valid').AsString),
                    SF('P_KZValue',         FieldByName('P_KZValue').AsFloat),
                    SF('P_DelMan',          FieldByName('P_DelMan').AsString),
                    SF('P_DelDate',         FieldByName('P_DelDate').AsDateTime),
                    SF('P_Memo',            FieldByName('P_Memo').AsString)
                    ], sTable_PoundLog,        '',      True);
                    
          FListA.Add(nSQL);
          Next;
        end;
      end;
    end;

    nBakWork.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nBakWork, FListA[nIdx]);
      //xxxxx

      nBakWork.FConn.CommitTrans;
      Result := True;
    except
      nBakWork.FConn.RollbackTrans;
      nStr := '同步交货单数据到备用数据库失败.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nBakWork);
  end;
end;

function TWorkerBusinessCommander.SyncBillToNC(var nNo,
  nType: string): Boolean;
var
  nSQL, nAPIUrl, nStr:string;
  nNCOut: TStringStream;
  nJo : ISuperObject;
begin
  Result := False;

  nAPIUrl := 'createDispatch?externalCode=%s&voucherDate=%s&partner=%s'+
             '&warehouse=%s&projectCode=%s&memo=%s&rdRecordDetails=[$Bills]';

  nSQL := 'select a.*,b.C_NCID,b.C_NCName,b.C_JxsID,b.C_JxsName,c.D_ParamA '+
          'from S_bill a,S_Customer b,Sys_Dict c where a.L_CusID=b.C_ID and '+
          'a.L_StockNo=c.D_ParamB and L_ID In ($IN)';
  nSQL := MacroValue(nSQL, [MI('$IN', nNo)]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      nType := '编号为[ %s ]的交货单不存在.';
      nType := Format(nType, [nNo]);
      WriteLog('同步出错,'+nType);
      Exit;
    end;

    nAPIUrl := Format(nAPIUrl,[FieldByName('L_Id').AsString,
                Date2Str(FieldByName('L_Date').AsDateTime, True),
                FieldByName('C_NCID').AsString, '01',
                FieldByName('C_JxsID').AsString,
                FieldByName('L_Id').AsString]);

    nStr := '{"Inventory":{"Code":"%s"},"BaseQuantity":%s,'+
              '"OrigTaxSalePrice":%s,"taxRate":"%s","DiscountRate":"1"}';
    nStr := Format(nStr,[FieldByName('L_StockNo').AsString,
            FieldByName('L_Value').AsString,
            FieldByName('L_Price').AsString,
            FieldByName('D_ParamA').AsString]);
  end;

  nAPIUrl := MacroValue(nAPIUrl, [MI('$Bills', nStr)]);
  nAPIUrl := gAPIUrl + nAPIUrl;

  WriteLog('同步APIURL：'+nAPIUrl);

  try
    nNCOut := TStringStream.Create('');
    try
      HttpClient.Get(nAPIUrl,nNCOut);
    except
      nType := '同步交货单调用NC接口失败.';
      WriteLog(nType);
      Exit;
    end;
    nStr := UTF8Decode(nNCOut.DataString);
    nJo := so(nStr);
    if nJo['status'].AsString <> 'success' then
    begin
      nType := '推送单据'+nNo+'至用友出错，info:'+ nJo['info'].AsString;
      WriteLog(nType);
      Exit;
    end;
  finally
    nNCOut.Free;
  end;
  Result := True;
end;

function TWorkerBusinessCommander.SyncBillToNC_Bak(
  var nData: string): Boolean;
var
  nSQL, nAPIUrl, nStr, nNo, nBillDate:string;
  nNCOut: TStringStream;
  nJo : ISuperObject;
begin
  Result := False;

  nNo := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);

  nAPIUrl := 'createDispatch?externalCode=%s&voucherDate=%s&partner=%s'+
             '&warehouse=%s&projectCode=%s&memo=%s&rdRecordDetails=[$Bills]';

  nSQL := 'select a.*,b.C_NCID,b.C_NCName,b.C_JxsID,b.C_JxsName,c.D_ParamA '+
          'from S_bill a,S_Customer b,Sys_Dict c where a.L_CusID=b.C_ID and '+
          'a.L_StockNo=c.D_ParamB and L_ID In ($IN)';
  nSQL := MacroValue(nSQL, [MI('$IN', nNo)]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的交货单不存在.';
      nData := Format(nData, [nNo]);
      WriteLog('同步出错,'+nData);
      Exit;
    end;
    if FieldByName('L_outFact').AsString ='' then
      nBillDate := Date2Str(Now, True)
    else
      nBillDate := Date2Str(FieldByName('L_outFact').AsDateTime, True);

    nAPIUrl := Format(nAPIUrl,[FieldByName('L_Id').AsString,
                nBillDate,
                FieldByName('C_NCID').AsString, '01',
                FieldByName('C_JxsID').AsString,
                FieldByName('L_Id').AsString]);

    nStr := '{"Inventory":{"Code":"%s"},"BaseQuantity":%s,'+
              '"OrigTaxSalePrice":%s,"taxRate":"%s","DiscountRate":"1"}';
    nStr := Format(nStr,[FieldByName('L_StockNo').AsString,
            FieldByName('L_Value').AsString,
            FieldByName('L_Price').AsString,
            FieldByName('D_ParamA').AsString]);
  end;

  nAPIUrl := MacroValue(nAPIUrl, [MI('$Bills', nStr)]);
  nAPIUrl := gAPIUrl + nAPIUrl;

  WriteLog('同步APIURL：'+nAPIUrl);

  try
    nNCOut := TStringStream.Create('');
    try
      HttpClient.Get(nAPIUrl,nNCOut);
    except
      nData := '同步交货单调用NC接口失败.';
      WriteLog(nData);
      Exit;
    end;
    nStr := UTF8Decode(nNCOut.DataString);
    nJo := so(nStr);
    if nJo['status'].AsString <> 'success' then
    begin
      nData := '推送单据'+nNo+'至用友出错，info:'+ nJo['info'].AsString;
      WriteLog(nData);
      Exit;                    
    end;
  finally
    nNCOut.Free;
  end;
  Result := True;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerQueryField, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessCommander, sPlug_ModuleBus);
end.
