set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

Create TRIGGER [Trig_SupplyFile_Del] ON [dbo].[fg_supplyfile]   
FOR DELETE  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)
  INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
	select 'fg_supplyfile','D',GetDate(),compno from DELETED	
end

go

/**************************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


Create TRIGGER [Trig_SupplyFile_Update] ON [dbo].[fg_supplyfile]   
FOR UPDATE  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)

  declare @InsID varchar(50);
  select @InsID =compno from INSERTED
    
  INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
	select 'fg_supplyfile','E',GetDate(),compno from DELETED where compno=@InsID	
end

/**************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


Create TRIGGER [Trig_SupplyFile_Add] ON [dbo].[fg_supplyfile]   
FOR INSERT  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  begin	
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)
  end
  INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
	select 'fg_supplyfile','A',GetDate(),compno from INSERTED	
end


