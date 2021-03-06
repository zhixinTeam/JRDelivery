USE [ZXDelivery]
GO
/****** Object:  Table [dbo].[Sys_Menu]    Script Date: 09/30/2017 00:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sys_Menu](
	[M_MenuID] [varchar](15) NULL,
	[M_ProgID] [varchar](15) NULL,
	[M_Entity] [varchar](15) NULL,
	[M_PMenu] [varchar](15) NULL,
	[M_Title] [varchar](50) NULL,
	[M_ImgIndex] [int] NULL,
	[M_Flag] [varchar](20) NULL,
	[M_Action] [varchar](50) NULL,
	[M_Filter] [varchar](50) NULL,
	[M_Popedom] [varchar](36) NULL,
	[M_NewOrder] [float] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'', N'ZXSOFT', N'', NULL, N'水泥销售系统', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'', N'ZXSOFT', N'MAIN', NULL, N'主菜单', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'DS03', N'ZXSOFT', N'MAIN', N'D00', N'-', -1, N'', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D08', N'ZXSOFT', N'MAIN', N'D00', N'空车出厂', -1, N'', N'', N'', NULL, 2.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A00', N'ZXSOFT', N'MAIN', N'', N'系统设置', -1, N'NB', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'B00', N'ZXSOFT', N'MAIN', N'', N'合同管理', -1, N'', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A06', N'ZXSOFT', N'MAIN', N'A00', N'参数设置', -1, N'', N'', N'', NULL, 0.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'AS04', N'ZXSOFT', N'MAIN', N'A00', N'-', -1, N'', N'', N'', NULL, 0.4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A07', N'ZXSOFT', N'MAIN', N'A00', N'安全授权', -1, N'', N'', N'', NULL, 0.3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L08', N'ZXSOFT', N'MAIN', N'L00', N'纸卡信息', -1, N'', N'', N'', NULL, 5.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L05', N'ZXSOFT', N'MAIN', N'L00', N'车辆调度', -1, N'UF', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'W00', N'ZXSOFT', N'MAIN', N'', N'微信平台', -1, N'NB', N'', N'', NULL, -1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'LS02', N'ZXSOFT', N'MAIN', N'L00', N'-', -1, N'', N'', N'', NULL, 5.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'W01', N'ZXSOFT', N'MAIN', N'W00', N'账号管理', -1, N'NB', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'WS01', N'ZXSOFT', N'MAIN', N'W00', N'-', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'W02', N'ZXSOFT', N'MAIN', N'W00', N'发送日志', -1, N'NB', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M01', N'ZXSOFT', N'MAIN', N'M00', N'供应商', -1, N'NB', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M02', N'ZXSOFT', N'MAIN', N'M00', N'原材料', -1, N'NB', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'MS01', N'ZXSOFT', N'MAIN', N'M00', N'-', -1, N'', N'', N'', NULL, 3.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M03', N'ZXSOFT', N'MAIN', N'M00', N'供应磁卡', -1, N'NB', N'', N'', NULL, 3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M04', N'ZXSOFT', N'MAIN', N'M00', N'供应查询', -1, N'', N'', N'', NULL, 4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'MS02', N'ZXSOFT', N'MAIN', N'M00', N'-', -1, N'', N'', N'', NULL, 3.4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M05', N'ZXSOFT', N'MAIN', N'M00', N'原料称重', -1, N'', N'', N'', NULL, -6)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'F05', N'ZXSOFT', N'MAIN', N'M00', N'供应验收', -1, N'', N'', N'', NULL, 5)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'F04', N'ZXSOFT', N'MAIN', N'F00', N'栈台调度', -1, N'', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M07', N'ZXSOFT', N'MAIN', N'M00', N'供应结算', -1, N'', N'', N'', NULL, -8)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K05', N'ZXSOFT', N'MAIN', N'K00', N'开化验单', -1, N'', N'', N'', NULL, -5)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K06', N'ZXSOFT', N'MAIN', N'K00', N'开单查询', -1, N'', N'', N'', NULL, -3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'CS03', N'ZXSOFT', N'MAIN', N'C00', N'-', -1, N'', N'', N'', NULL, 6.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C08', N'ZXSOFT', N'MAIN', N'C00', N'销售扎账', -1, N'NB', N'', N'', NULL, 5.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C09', N'ZXSOFT', N'MAIN', N'C00', N'销售退购', -1, N'NB', N'', N'', NULL, -6.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C00', N'ZXSOFT', N'MAIN', N'', N'财务室', -1, N'', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D00', N'ZXSOFT', N'MAIN', N'', N'开票室', -1, N'', N'', N'', NULL, 3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'E00', N'ZXSOFT', N'MAIN', N'', N'磅房', -1, N'', N'', N'', NULL, 4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'F00', N'ZXSOFT', N'MAIN', N'', N'栈台', -1, N'', N'', N'', NULL, 5)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'G00', N'ZXSOFT', N'MAIN', N'', N'放灰处', -1, N'', N'', N'', NULL, 6)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'H00', N'ZXSOFT', N'MAIN', N'', N'门卫室', -1, N'', N'', N'', NULL, 7)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K00', N'ZXSOFT', N'MAIN', N'', N'化验室', -1, N'', N'', N'', NULL, 3.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L00', N'ZXSOFT', N'MAIN', N'', N'报表查询', -1, N'', N'', N'', NULL, 9)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A01', N'ZXSOFT', N'MAIN', N'A00', N'公司信息', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A02', N'ZXSOFT', N'MAIN', N'A00', N'操作日志', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'AS01', N'ZXSOFT', N'MAIN', N'A00', N'-', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A03', N'ZXSOFT', N'MAIN', N'A00', N'数据备份', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A04', N'ZXSOFT', N'MAIN', N'A00', N'数据恢复', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'AS02', N'ZXSOFT', N'MAIN', N'A00', N'-', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A05', N'ZXSOFT', N'MAIN', N'A00', N'修改密码', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'SYSRELOAD', N'ZXSOFT', N'MAIN', N'A00', N'重新登录', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'AS03', N'ZXSOFT', N'MAIN', N'A00', N'-', -1, N'', N'', N'', NULL, 0.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'SYSCLOSE', N'ZXSOFT', N'MAIN', N'A00', N'退出系统', -1, N'', N'', N'', NULL, 0.5)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'B01', N'ZXSOFT', N'MAIN', N'B00', N'区域管理', -1, N'NB', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'B02', N'ZXSOFT', N'MAIN', N'B00', N'客户管理', -1, N'', N'', N'', NULL, 3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'B03', N'ZXSOFT', N'MAIN', N'B00', N'业务人员', -1, N'NB', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'BS01', N'ZXSOFT', N'MAIN', N'B00', N'-', -1, N'', N'', N'', NULL, 3.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'B04', N'ZXSOFT', N'MAIN', N'B00', N'合同管理', -1, N'', N'', N'', NULL, 4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C01', N'ZXSOFT', N'MAIN', N'C00', N'纸卡审核', -1, N'', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C02', N'ZXSOFT', N'MAIN', N'C00', N'货款回收', -1, N'UF', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'CS01', N'ZXSOFT', N'MAIN', N'C00', N'-', -1, N'', N'', N'', NULL, 3.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C03', N'ZXSOFT', N'MAIN', N'C00', N'信用管理', -1, N'', N'', N'', NULL, 3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C04', N'ZXSOFT', N'MAIN', N'C00', N'发票管理', -1, N'NB', N'', N'', NULL, 4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C05', N'ZXSOFT', N'MAIN', N'C00', N'开具发票', -1, N'', N'', N'', NULL, 6)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'CS02', N'ZXSOFT', N'MAIN', N'C00', N'-', -1, N'', N'', N'', NULL, 1.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C06', N'ZXSOFT', N'MAIN', N'C00', N'结算周期', -1, N'NB', N'', N'', NULL, 5)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'C07', N'ZXSOFT', N'MAIN', N'C00', N'收据管理', -1, N'', N'', N'', NULL, 7)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D01', N'ZXSOFT', N'MAIN', N'D00', N'办理纸卡', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D02', N'ZXSOFT', N'MAIN', N'D00', N'办理磁卡', -1, N'NB', N'', N'', NULL, 1.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'DS01', N'ZXSOFT', N'MAIN', N'D00', N'-', -1, N'', N'', N'', NULL, 1.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D03', N'ZXSOFT', N'MAIN', N'D00', N'开提货单', -1, N'', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D04', N'ZXSOFT', N'MAIN', N'D00', N'销售补单', -1, N'NB', N'', N'', NULL, 1.3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'DS02', N'ZXSOFT', N'MAIN', N'D00', N'-', -1, N'', N'', N'', NULL, 4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D05', N'ZXSOFT', N'MAIN', N'D00', N'纸卡查询', -1, N'', N'', N'', NULL, 4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D06', N'ZXSOFT', N'MAIN', N'D00', N'提货查询', -1, N'', N'', N'', NULL, 5)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'D07', N'ZXSOFT', N'MAIN', N'D00', N'销售调拨', -1, N'NB', N'', N'', NULL, -2.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'E01', N'ZXSOFT', N'MAIN', N'E00', N'手动称重', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'E02', N'ZXSOFT', N'MAIN', N'E00', N'自动称重', -1, N'', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'ES01', N'ZXSOFT', N'MAIN', N'E00', N'-', -1, N'', N'', N'', NULL, 1.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'E03', N'ZXSOFT', N'MAIN', N'E00', N'称量查询', -1, N'', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'F01', N'ZXSOFT', N'MAIN', N'F00', N'袋装提货', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'F02', N'ZXSOFT', N'MAIN', N'F00', N'栈台调度', -1, N'', N'', N'', NULL, -1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'FS01', N'ZXSOFT', N'MAIN', N'F00', N'-', -1, N'', N'', N'', NULL, 1.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'G01', N'ZXSOFT', N'MAIN', N'G00', N'散装放灰', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'H01', N'ZXSOFT', N'MAIN', N'H00', N'进厂检验', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'H02', N'ZXSOFT', N'MAIN', N'H00', N'出厂检验', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'HS01', N'ZXSOFT', N'MAIN', N'H00', N'-', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'H03', N'ZXSOFT', N'MAIN', N'H00', N'车辆查询', -1, N'', N'', N'', NULL, 0)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K01', N'ZXSOFT', N'MAIN', N'K00', N'品种管理', -1, N'', N'', N'', NULL, 1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K02', N'ZXSOFT', N'MAIN', N'K00', N'检验记录', -1, N'', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'KS01', N'ZXSOFT', N'MAIN', N'K00', N'-', -1, N'', N'', N'', NULL, 2.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K03', N'ZXSOFT', N'MAIN', N'K00', N'手工开单', -1, N'NB', N'', N'', NULL, 3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K04', N'ZXSOFT', N'MAIN', N'K00', N'开化验单', -1, N'', N'', N'', NULL, -1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L01', N'ZXSOFT', N'MAIN', N'L00', N'车辆查询', -1, N'UF', N'', N'', NULL, 2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L02', N'ZXSOFT', N'MAIN', N'L00', N'客户账户', -1, N'UF', N'', N'', NULL, 4)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L03', N'ZXSOFT', N'MAIN', N'L00', N'资金明细', -1, N'', N'', N'', NULL, 5)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'LS01', N'ZXSOFT', N'MAIN', N'L00', N'-', -1, N'', N'', N'', NULL, 3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L06', N'ZXSOFT', N'MAIN', N'L00', N'发货明细', -1, N'UF', N'', N'', NULL, 7)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L07', N'ZXSOFT', N'MAIN', N'L00', N'累计发货', -1, N'UF', N'', N'', NULL, 8)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M00', N'ZXSOFT', N'MAIN', N'', N'原料供应', -1, N'', N'', N'', NULL, 0.8)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M08', N'ZXSOFT', N'MAIN', N'M00', N'车辆查询', -1, N'', N'', N'', NULL, 8)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L09', N'ZXSOFT', N'MAIN', N'L00', N'销售结算', -1, N'', N'', N'', NULL, 5.1)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A08', N'ZXSOFT', N'MAIN', N'A00', N'待办事件', -1, N'', N'', N'', NULL, 0.32)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'A09', N'ZXSOFT', N'MAIN', N'A00', N'发送事件', -1, N'', N'', N'', NULL, 0.32)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'K07', N'ZXSOFT', N'MAIN', N'K00', N'批次管理', -1, N'NB', N'', N'', N'', 7)
GO
print 'Processed 100 total records'
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L10', N'ZXSOFT', N'MAIN', N'L00', N'采购明细', -1, N'', N'', N'', NULL, 9)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'LS03', N'ZXSOFT', N'MAIN', N'L00', N'-', -1, N'', N'', N'', NULL, 5.01)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M10', N'ZXSOFT', N'MAIN', N'M00', N'临时业务', -1, N'', N'', N'', NULL, 3.2)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'M06', N'ZXSOFT', N'MAIN', N'M00', N'临时查询', -1, N'NB', N'', N'', NULL, 3.3)
INSERT [dbo].[Sys_Menu] ([M_MenuID], [M_ProgID], [M_Entity], [M_PMenu], [M_Title], [M_ImgIndex], [M_Flag], [M_Action], [M_Filter], [M_Popedom], [M_NewOrder]) VALUES (N'L11', N'ZXSOFT', N'MAIN', N'L00', N'临时查询', -1, N'', N'', N'', NULL, 9.1)
/****** Object:  Default [DF__Sys_Menu__M_NewO__164452B1]    Script Date: 09/30/2017 00:44:20 ******/
ALTER TABLE [dbo].[Sys_Menu] ADD  DEFAULT ((-1)) FOR [M_NewOrder]
GO
