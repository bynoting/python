/*
//Description :建立组
//Company :GTAlarm 
//Create Date :2008-11-26
*/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_group]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
CREATE TABLE [dbo].[am_group](
	[guid] [guid] NOT NULL,
	[group_name] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[group_type] [int] NOT NULL,
	[data_create_user] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NULL,
	[data_create_time] [datetime] NULL
) ON [PRIMARY]
end
GO
EXEC dbo.sp_bindefault @defname=N'[dbo].[guid]', @objname=N'[dbo].[am_group].[guid]' , @futureonly='futureonly'

/*
//Description :建立组成员
//Company :GTAlarm 
//Create Date :2008-11-26
*/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_group_member]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
CREATE TABLE [dbo].[am_group_member](
	[guid] [guid] NOT NULL,
	[group_guid] [guid] NOT NULL,
	[group_member] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[data_create_user] [nvarchar](50) COLLATE Chinese_PRC_CI_AS NULL,
	[data_create_time] [datetime] NULL
) ON [PRIMARY]
end
GO
EXEC dbo.sp_bindefault @defname=N'[dbo].[guid]', @objname=N'[dbo].[am_group_member].[guid]' , @futureonly='futureonly'
GO
EXEC dbo.sp_bindefault @defname=N'[dbo].[guid]', @objname=N'[dbo].[am_group_member].[group_guid]' , @futureonly='futureonly'


-----------------------------------------------------------------------------------
-- 将notice_type字段修改为可以为空
-----------------------------------------------------------------------------------

if exists( select 1 from dbo.syscolumns s where name ='notice_type' and id = object_id(N'am_notice_receiver'))
begin
	alter table am_notice_receiver alter column notice_type nvarchar(50) null
end
go


-----------------------------------------------------------------------------------
-- 加入notice_guid字段，在公告中实现组功能
-----------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='notice_guid' and id = object_id(N'am_notice_receiver'))
begin
	alter table am_notice_receiver add notice_guid guid
	create   index idx_am_notice_receiver_notice_guid on am_notice_receiver (  guid ASC  )  
end
go

update am_notice_receiver set notice_guid = newid() where notice_guid is null
go

-----------------------------------------------------------------------------------
-- 加入group_guid字段，在公告中实现组功能
-----------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='group_guid' and id = object_id(N'am_notice_receiver'))
begin
	alter table am_notice_receiver add group_guid guid
	create   index idx_am_notice_receiver_group_guid on am_notice_receiver (  guid ASC  )  
end
go

update am_notice_receiver set group_guid = newid() where group_guid is null
go