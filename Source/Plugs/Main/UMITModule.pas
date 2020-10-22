{*******************************************************************************
  ����: dmzn@163.com 2009-6-25
  ����: ��Ԫģ��

  ��ע: ����ģ������ע������,ֻҪUsesһ�¼���.
*******************************************************************************}
unit UMITModule;

{$I Link.Inc}
interface

uses
  Windows, Forms, Classes, SysUtils, ULibFun, UBusinessWorker, UBusinessPacker,
  UTaskMonitor, UBaseObject, USysShareMem, USysLoger, UMITConst, UMITPacker,
  {$IFDEF HardMon}UEventHardware, UWorkerHardware,{$ENDIF}
  UWorkerBusiness, UWorkerBusinessBill, UWorkerBusinessOrder,USysDB,
  {$IFDEF MicroMsg}UMgrRemoteWXMsg,{$ENDIF} UMemDataPool,
  UMgrDBConn, UMgrParam, UMgrPlug, UMgrChannel, UChannelChooser,
  USAPConnection, UWorkerBusinessDuanDao;

procedure InitSystemObject(const nMainForm: THandle);
procedure RunSystemObject;
procedure FreeSystemObject;
//��ں���

implementation

type
  TMainEventWorker = class(TPlugEventWorker)
  protected
    procedure GetExtendMenu(const nList: TList); override;
    procedure BeforeStartServer; override;
    procedure AfterStopServer; override;
  public
    class function ModuleInfo: TPlugModuleInfo; override;
  end;

class function TMainEventWorker.ModuleInfo: TPlugModuleInfo;
begin
  Result := inherited ModuleInfo;
  with Result do
  begin
    FModuleID       := '{2497C39C-E1B2-406D-B7AC-9C8DB49C44DF}';
    FModuleName     := '����¼�';
    FModuleAuthor   := 'dmzn@163.com';
    FModuleVersion  := '2013-12-12';
    FModuleDesc     := '����ܶ���,�������ҵ��.';
    FModuleBuildTime:= Str2DateTime('2013-12-12 13:05:00');
  end;
end;

procedure TMainEventWorker.GetExtendMenu(const nList: TList);
//var nMenu: PPlugMenuItem;
begin
{
  New(nMenu);
  nList.Add(nMenu);

  nMenu.FModule := ModuleInfo.FModuleID;
  nMenu.FName := '';
  nMenu.FCaption := '';
  nMenu.FFormID := 0;
  nMenu.FDefault := True;
}
end;

//Desc: ��ȡ���ݿ����
procedure LoadDBConfig;
var nStr: string;
    nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    nStr := ' Select D_Value, D_Memo From Sys_Dict Where D_Name = ''%s'' ';
    nStr := Format(nStr, ['SysParam']);

    with gDBConnManager.SQLQuery(nStr, nWorker) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := Fields[1].AsString;
        if nStr = sFlag_WXErpUrl then
          gSysParam.FWXERPUrl := Fields[0].AsString;
         //��Ȩ�����ַ

        if nStr = sFlag_WXErpZhangHu then
          gSysParam.FWXZhangHu := Fields[0].AsString;
         //��Ȩ�˻�

        if nStr = sFlag_WXErpMima then
          gSysParam.FWXMiMa := Fields[0].AsString;
         //��Ȩ����

        if nStr = 'Authorization' then
          gSysParam.FAuthorization := Fields[0].AsString;

        if nStr = 'TenantId' then
          gSysParam.FTenantId := Fields[0].AsString;

        if nStr = 'DeptId' then
          gSysParam.FDeptId    := Fields[0].AsString;

        if nStr = 'CarrierId' then
          gSysParam.FCarrierId := Fields[0].AsString;

        if nStr = sFlag_WXToken then
          gSysParam.FWXToken := Fields[0].AsString;
        //��Ȩ�̶�Token
        
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker); 
  end;
end;

procedure TMainEventWorker.BeforeStartServer;
begin
  {$IFDEF DBPool}
  with gParamManager do
  begin
    gDBConnManager.DefaultConnection := ActiveParam.FDB.FID;
    gDBConnManager.MaxConn := ActiveParam.FDB.FNumWorker;
  end;
  {$ENDIF} //db

  {$IFDEF SAP}
  with gParamManager do
  begin
    gSAPConnectionManager.AddParam(ActiveParam.FSAP^);
    gSAPConnectionManager.PoolSize := ActiveParam.FPerform.FPoolSizeSAP;
  end;
  {$ENDIF}//sap

  {$IFDEF ChannelPool}
  gChannelManager.ChannelMax := 50;
  {$ENDIF} //channel

  {$IFDEF AutoChannel}
  gChannelChoolser.AddChanels(gParamManager.URLRemote.Text);
  gChannelChoolser.StartRefresh;
  {$ENDIF} //channel auto select

  {$IFDEF MicroMsg}
  gWXPlatFormHelper.StartPlatConnector;
  {$ENDIF} //micro message

  gTaskMonitor.StartMon;
  //mon task start
  LoadDBConfig;
end;

procedure TMainEventWorker.AfterStopServer;
begin
  inherited;
  gTaskMonitor.StopMon;
  //stop mon task

  {$IFDEF AutoChannel}
  gChannelChoolser.StopRefresh;
  {$ENDIF} //channel

  {$IFDEf SAP}
  gSAPConnectionManager.ClearAllConnection;
  {$ENDIF}//stop sap

  {$IFDEF DBPool}
  gDBConnManager.Disconnection();
  {$ENDIF} //db

  {$IFDEF MicroMsg}
  gWXPlatFormHelper.StopPlatConnector;
  {$ENDIF} //micro message
end;

//------------------------------------------------------------------------------
//Desc: ������ݿ����
procedure FillAllDBParam;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gParamManager.LoadParam(nList, ptDB);
    for nIdx:=0 to nList.Count - 1 do
      gDBConnManager.AddParam(gParamManager.GetDB(nList[nIdx])^);
    //xxxxx
  finally
    nList.Free;
  end;
end;

//Desc: ��ʼ��ϵͳ����
procedure InitSystemObject(const nMainForm: THandle);
var nParam: TPlugRunParameter;
begin
  gSysLoger := TSysLoger.Create(gPath + sLogDir, sLogSyncLock);
  //��־������
  gCommonObjectManager := TCommonObjectManager.Create;
  //ͨ�ö���״̬����

  gTaskMonitor := TTaskMonitor.Create;
  //��������
  gMemDataManager := TMemDataManager.Create;
  //�ڴ������

  gParamManager := TParamManager.Create(gPath + 'Parameters.xml');
  if gSysParam.FParam <> '' then
    gParamManager.GetParamPack(gSysParam.FParam, True);
  //����������

  TBusinessWorkerSweetHeart.RegWorker(gParamManager.URLLocal.Text);
  //for channel manager

  {$IFDEF ClientMon}
  gProcessMonitorClient := TProcessMonitorClient.Create(gSysParam.FParam);
  //process monitor
  {$ENDIF}
  
  {$IFDEF DBPool}
  gDBConnManager := TDBConnManager.Create;
  FillAllDBParam;
  {$ENDIF}

  {$IFDEF SAP}
  gSAPConnectionManager := TSAPConnectionManager.Create;
  //sap conn pool
  {$ENDIF}

  {$IFDEF ChannelPool}
  gChannelManager := TChannelManager.Create;
  {$ENDIF}

  {$IFDEF AutoChannel}
  gChannelChoolser := TChannelChoolser.Create('');
  gChannelChoolser.AutoUpdateLocal := False;
  gChannelChoolser.AddChanels(gParamManager.URLRemote.Text);
  {$ENDIF}

  {$IFDEF MicroMsg}
  gWXPlatFormHelper.LoadConfig(gPath + 'Hardware\MicroMsg.XML');
  {$ENDIF} //micro message

  with nParam do
  begin
    FAppHandle := Application.Handle;
    FMainForm  := nMainForm;
    FAppFlag   := gSysParam.FAppFlag;
    FAppPath   := gPath;

    FLocalIP   := gSysParam.FLocalIP;
    FLocalMAC  := gSysParam.FLocalMAC;
    FLocalName := gSysParam.FLocalName;
    FExtParam  := TStringList.Create;
  end;

  gPlugManager := TPlugManager.Create(nParam);
  with gPlugManager do
  begin
    AddEventWorker(TMainEventWorker.Create);
    {$IFDEF HardMon}
    AddEventWorker(THardwareWorker.Create);
    {$ENDIF}
    LoadPlugsInDirectory(gPath + sPlugDir);

    RefreshUIMenu;
    InitSystemObject;
  end; //���������(�����һ����ʼ��)
end;

//Desc: ����ϵͳ����
procedure RunSystemObject;
var nStr: string;
begin
  {$IFDEF ClientMon}
  if Assigned(gParamManager.ActiveParam) and
     Assigned(gParamManager.ActiveParam.FPerform) then
  with gParamManager.ActiveParam.FPerform^ do
  begin
    if Assigned(gProcessMonitorSapMITClient) then
    begin
      gProcessMonitorSapMITClient.UpdateHandle(gPlugManager.RunParam.FMainForm,
                                               GetCurrentProcessId, nStr);
      gProcessMonitorSapMITClient.StartMonitor(nStr, FMonInterval);
    end;

    if Assigned(gProcessMonitorClient) then
    begin
      gProcessMonitorClient.UpdateHandle(gPlugManager.RunParam.FMainForm,
                                               GetCurrentProcessId, nStr);
      gProcessMonitorClient.StartMonitor(nStr, FMonInterval);
    end;
  end;
  {$ENDIF}

  gPlugManager.RunSystemObject;
  //�������ʼ����
end;

//Desc: �ͷ�ϵͳ����
procedure FreeSystemObject;
begin
  FreeAndNil(gPlugManager);
  //���������(���һ���ͷ�)

  if Assigned(gProcessMonitorSapMITClient) then
  begin
    gProcessMonitorSapMITClient.StopMonitor(Application.Active);
    FreeAndNil(gProcessMonitorSapMITClient);
  end; //stop monitor
end;

end.
