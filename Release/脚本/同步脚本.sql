INSERT INTO DL_SyncItem(S_Record, S_Table , S_Action , S_Time ) 
select compno,'fg_customfile' as S_Table,'A' as S_Action,getdate() as S_Time From [fg_customfile] 

��������->DL_SyncItem
--�ͻ���Ϣ


INSERT INTO DL_SyncItem(S_Record, S_Table , S_Action , S_Time )
select compno,'fg_supplyfile' as S_Table,'A' as S_Action,getdate() as S_Time From [fg_supplyfile] 

��������->DL_SyncItem
--��Ӧ��

