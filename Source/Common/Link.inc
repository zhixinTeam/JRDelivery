//----------------------------------- 通用 -------------------------------------
{.$DEFINE DEBUG}
//调试模式

{.$DEFINE TrialVersion}
//试用版本

{$DEFINE UseReport}
//报表支持

{.$DEFINE RandomID}
//使用随机编号

{$DEFINE cxLibrary42}
//Ver4.2编译环境

{.$DEFINE EnableBackupDB}
//备用数据库支持
{.$DEFINE EnableDoubleDB}
//双数据库支持

//---------------------------------- 中间件 ------------------------------------
{.$DEFINE ClientMon}
//进程守护客户端

{$DEFINE HardMon}
//编译硬件守护

{.$DEFINE GenRODL}
//生成RODL资源

{$DEFINE COM_MIT}
//定义系统模式

//通用中间件
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //启用数据库支持
  {$DEFINE ChannelPool}
  //启用通道支持
  {.$DEFINE AutoChannel}
  //启用通道平衡
  {.$DEFINE SAP}
  //启用SAP支持
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

//--------------------------------- 特定系统 -----------------------------------
{.$DEFINE COMMON}
//通用版本

{$DEFINE HNJR}
//特定系统

{$IFDEF HNJR}
 
//河南锦荣
{$DEFINE HNJR}
  {$DEFINE M100Reader}
  //吞卡机
  {$DEFINE HYRFID201}
  //华益读卡器
  {$DEFINE XzdERP_A3}
  //新中大ERP
  {$DEFINE SyncRemote}
  //同步开关
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE EnableWebMall}
  //启用网上商城
  {.$DEFINE MicroMsg}
  //微信支持
{$ENDIF}

