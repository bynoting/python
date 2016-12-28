----------------------------------------------------------------------------------------
-- 删除字典表中无用的数据
-----------------------------------------------------------------------------------------	
delete t_codediction where codetype = 'MATRIXTYPE'
delete t_codediction where codetype = 'CTRLPROTOCOL'
go

------------------------------------------------------------
-- 删除原有的双主键
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
-- 20080326 在codetype和codevalue上创建索引
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
-- 加入主键
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
-- 向字典表中加入串口协议的字典数据
-----------------------------------------------------------------------------------------
declare @codetype varchar(50)
declare @codetypename varchar(50)

set @codetype = 'control_protocal'
set @codetypename = '串口控制协议'

delete t_codediction where codetype = @codetype 

insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'YAAN Protocol','亚安',1)

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
  values (@codetype,@codetypename,'Dali DVR Protocol','大力',1)
	
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'DaHua DVR Protocol','大华DVR',1)	
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'GE DVSR Protocol','GE DVSR',1)	  
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'HaiKang DVR Protocol','海康DVR',1)	  
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'AB Protocol','AB矩阵协议',1)	    
  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'Pecol Matrix Protocol','派高矩阵协议',1)	     
  
----------------------------------------------------------------------------------------
-- 向字典表中加入编码器类型数据
-----------------------------------------------------------------------------------------
set @codetype = 'video_decoder_type'
set @codetypename = '视频解码器类型'

delete t_codediction where codetype = @codetype 

insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'1','gt',0)	  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'2','hk',0)	  
insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) 
  values (@codetype,@codetypename,'3','dh',0)	  

