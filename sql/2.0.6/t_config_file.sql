/** drop t_configuration_files table */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_configuration_files]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[t_configuration_files]
GO

------------------------------------------------------------------
-- table: t_config_file                                      
------------------------------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_config_file]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[t_config_file] (
		[guid] [guid] NOT NULL ,
		[file_key] [guid_string] NOT NULL ,
		[file_content] [image] NULL ,
		[file_format] [nvarchar] (8) COLLATE Chinese_PRC_CI_AS NULL ,
		[data_create_time] [data_create_time] NULL 
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	ALTER TABLE [dbo].[t_config_file] WITH NOCHECK ADD 
		CONSTRAINT [PK_t_config_file] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	ALTER TABLE [dbo].[t_config_file] ADD 
		CONSTRAINT [DF_t_config_file_file_format] DEFAULT (N'txt') FOR [file_format]
	
	CREATE  INDEX [IX_t_config_file_key] ON [dbo].[t_config_file]([file_key]) ON [PRIMARY]
	
end

EXEC sp_bindefault N'[dbo].[now]', N'[t_config_file].[data_create_time]'
EXEC sp_bindefault N'[dbo].[guid]', N'[t_config_file].[guid]'
GO

sp_tableoption   't_config_file','text in row','true'   

------------------------------------------------------------------
-- 在file_content上创建全文索引                                     
------------------------------------------------------------------
if (select DATABASEPROPERTY(DB_NAME(), N'IsFullTextEnabled')) <> 1 
	exec sp_fulltext_database N'enable' 
GO

if not exists (select * from dbo.sysfulltextcatalogs where name = 'cat_t_config_file') 
begin
	EXEC sp_fulltext_catalog 'cat_t_config_file', 'create'
	EXEC sp_fulltext_table 't_config_file', 'create', 'cat_t_config_file', 'PK_t_config_file'
	EXEC sp_fulltext_column 't_config_file', 'file_content', 'add',0x0804,'file_format'
	EXEC sp_fulltext_table 't_config_file','activate'
	exec sp_fulltext_table 't_config_file','start_full'

	exec sp_fulltext_table t_config_file,'start_change_tracking'
	exec sp_fulltext_table t_config_file,'Start_background_updateindex'
	exec sp_fulltext_table t_config_file,'update_index'
end
