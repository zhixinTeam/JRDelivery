//----------------------------------- ͨ�� -------------------------------------
{.$DEFINE DEBUG}
//����ģʽ

{.$DEFINE TrialVersion}
//���ð汾

{$DEFINE UseReport}
//����֧��

{.$DEFINE RandomID}
//ʹ��������

{$DEFINE cxLibrary42}
//Ver4.2���뻷��

{.$DEFINE EnableBackupDB}
//�������ݿ�֧��
{.$DEFINE EnableDoubleDB}
//˫���ݿ�֧��

//---------------------------------- �м�� ------------------------------------
{.$DEFINE ClientMon}
//�����ػ��ͻ���

{$DEFINE HardMon}
//����Ӳ���ػ�

{.$DEFINE GenRODL}
//����RODL��Դ

{$DEFINE COM_MIT}
//����ϵͳģʽ

//ͨ���м��
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //�������ݿ�֧��
  {$DEFINE ChannelPool}
  //����ͨ��֧��
  {.$DEFINE AutoChannel}
  //����ͨ��ƽ��
  {.$DEFINE SAP}
  //����SAP֧��
  {.$DEFINE ClientMon}
  //֧���ػ�����
{$ENDIF}

//--------------------------------- �ض�ϵͳ -----------------------------------
{.$DEFINE COMMON}
//ͨ�ð汾

{$DEFINE HNJR}
//�ض�ϵͳ

{$IFDEF HNJR}
 
//���Ͻ���
{$DEFINE HNJR}
  {$DEFINE M100Reader}
  //�̿���
  {$DEFINE HYRFID201}
  //���������
  {$DEFINE XzdERP_A3}
  //���д�ERP
  {$DEFINE SyncRemote}
  //ͬ������
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE MITTruckProber}
  //�������м������
  {$DEFINE DaiStepWuCha}
  //��װ�������
  {$DEFINE BatchInHYOfBill}
  //���α����ڻ��鵥�ֶ�
  {$DEFINE EnableWebMall}
  //���������̳�
  {.$DEFINE MicroMsg}
  //΢��֧��
{$ENDIF}

//֣���Ͻ�
{$IFDEF ZZSJ}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE MITTruckProber}
  //�������м������
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE PrintHYEach}
  //�泵�����鵥
  {.$DEFINE HeGeZhengOnly}
  //�泵����ʱֻ��ϸ�֤
  {$DEFINE BatchInHYOfBill}
  //���α����ڻ��鵥�ֶ�
  {$DEFINE SanPreHK}
  //ɢװ����ʱԤ�Ͽ�
  {$DEFINE ManualEvent}
  //�˹���Ԥ�¼�
  {$DEFINE DaiStepWuCha}
  //��װ�������
  {$DEFINE NoShowPriceChange}
  //����ʾ�۸������ʾ
  {$DEFINE NoCheckOnPayment}
  //�˿�ʱ��У���ʽ����
{$ENDIF}

//����Ӫ��
{$IFDEF LNYK}
  {$DEFINE COMMON}
{$ENDIF}

//��������
{$IFDEF DYGL}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE PrintGLF}
  //��ӡ��·��
  {$DEFINE TruckInNow}
  //������������,��Ҫ���ó����Ŷ�ģʽ
{$ENDIF}

//�綫����
{$IFDEF RDHX}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //�����ͷ
{$ENDIF}

//�°�����
{$IFDEF XAZL}
  {$DEFINE UseERP_K3}
  //ʹ��k3
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE VerifyK3Stock}
  //����ʱ��֤Ʒ��
  {$DEFINE MicroMsg}
  //΢��֧��
  {$DEFINE BlueCard}
  //����̧��
{$ENDIF}

//��Դ����
{$IFDEF JYZL}
  {$DEFINE UseERP_K3}
  //ʹ��k3
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE VerifyK3Stock}
  //����ʱ��֤Ʒ��
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE PrintBillMoney}
  //��ӡʱ�Խ��
  {$DEFINE HR1847}
  //�������𳵼�
{$ENDIF}

//���Ϻ���
{$IFDEF YNHT}
  {$DEFINE UseERP_K3}
  //ʹ��k3
  {$DEFINE SyncRemote}
  //Զ��ͬ��
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE PrintBillMoney}
  //��ӡʱ�Խ��
  {$DEFINE MITTruckProber}
  //�������м������
  {$DEFINE UseK3SalePlan}
  //K3���ۼƻ�
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE NoShowPriceChange}
  //����ʾ�۸������ʾ
  {$DEFINE BatchInHYOfBill}
  //���α����ڻ��鵥�ֶ�
{$ENDIF}
