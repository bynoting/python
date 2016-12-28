----------------------------------------------------------------------------------------
-- ɾ���ֵ�������õ�����
-----------------------------------------------------------------------------------------	
delete t_codediction where codetype = 'MATRIXTYPE'
delete t_codediction where codetype = 'CTRLPROTOCOL'
go

------------------------------------------------------------
-- ɾ��ԭ�е�˫����
------------------------------------------------------------
declare @constraint_name varchar(100)
declare @is_primary int

select  
  @constraint_name = constraint_name,
  @is_primary = objectproperty(object_id(constraint_schema + '.' + constraint_name),'IsPrimaryKey')
  from INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
  where table_name = 't_codediction' and column_name = 'codetype'

if @constraint_name is not null and @is_primary = 1
	exec ('alter table t_codediction drop constraint '+ @constraint_name)
go

declare @constraint_name varchar(100)
declare @is_primary int
select  
  @constraint_name = constraint_name,
  @is_primary = objectproperty(object_id(constraint_schema + '.' + constraint_name),'IsPrimaryKey')
  from INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
  where table_name = 't_codediction' and column_name = 'codevalue'

if @constraint_name is not null and @is_primary = 1
	exec ('alter table t_codediction drop constraint '+ @constraint_name)    

      
------------------------------------------------------------
-- 20080326 ��codetype��codevalue�ϴ�������
------------------------------------------------------------
exec spt_drop_index 't_codediction','codetype'
go

CREATE INDEX [idx_t_codediction_codetype] ON [dbo].[t_codediction] ([CODETYPE])
go

exec spt_drop_index 't_codediction','codevalue'
go

CREATE INDEX [idx_t_codediction_codevalue] ON [dbo].[t_codediction] ([CODEVALUE])
go

------------------------------------------------------------
-- ��������
------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='guid' and id = object_id(N't_codediction'))
begin
	exec ('alter table dbo.t_codediction add guid guid')
	exec ('update dbo.t_codediction set guid = newid() where guid is null')
	exec spt_modify_column_type 't_codediction','guid',' guid not null'
	ALTER TABLE [dbo].[t_codediction] WITH NOCHECK ADD 
		CONSTRAINT [PK_t_codediction_guid] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

end
go

DBCC DBREINDEX ('t_codediction')
go

-----------------------------------------------------------------------------------------
-- ���ֵ���м��봮��Э����ֵ�����
-----------------------------------------------------------------------------------------
declare @codetype varchar(50)
declare @codetypename varchar(50)

set @codetype = 'control_protocal'
set @codetypename = '���ڿ���Э��'

delete t_codediction where codetype = @codetype 

insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'YAAN Protocol','�ǰ�',1)

insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'DVMRe Triplex Protocol','GE DVRMe',1)

insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'GE ASCII Protocol','GE ASCII',1)

insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'PelcolP Protocol','PelcolP',1)
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'PelcolD Protocol','PelcolD',1)
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'VOYA Matrix Protocol','VOYA',1)
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'Dali DVR Protocol','����',1)
	
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'DaHua DVR Protocol','��DVR',1)	
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'GE DVSR Protocol','GE DVSR',1)	  
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'HaiKang DVR Protocol','����DVR',1)	  
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'AB Protocol','AB����Э��',1)	    
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'Pecol Matrix Protocol','�ɸ߾���Э��',1)	     
  
----------------------------------------------------------------------------------------
-- ���ֵ���м����������������
-----------------------------------------------------------------------------------------
set @codetype = 'video_decoder_type'
set @codetypename = '��Ƶ����������'

delete t_codediction where codetype = @codetype 

insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'1','gt',0)	  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'2','hk',0)	  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'3','dh',0)	  

