use gtalarm
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[T_UI_MENU]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	update T_UI_MENU set SMARTMENUTYPE = '00', SMARTFROMNAME = null where pageid is not null
go

/****** 对象: 存储过程 dbo.sp_import_function    脚本日期: 2010-1-13 15:17:42 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_import_function]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[sp_import_function]
go

/****** 对象: 存储过程 dbo.sp_import_function    脚本日期: 2010-1-13 15:17:42 ******/
----------------------------------------------------------------------------------------------------------------------
-- 描述: 将客户端功能权限数据导入gtalarm数据库
-- 作者: 潘龙泉
-- 日期: 2010/01/13
----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].sp_import_function AS
BEGIN
	if not exists (select 1 from master.dbo.sysdatabases where name ='gtalarm')
		return

	declare @name nvarchar(32) 
	declare @guid  nvarchar(36)
	declare @pid int
	declare @id int 
	declare @childid int

	DECLARE root CURSOR FOR SELECT  [Id],  [Name],  EntityGuid FROM EafFunctionTree WHERE ParentId is null	
	OPEN root
	FETCH NEXT FROM root INTO @id, @name, @guid
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		if not exists(select 1 from gtalarm..t_ui_menu where smartfromname = @guid)
		begin
			select @pid = max(convert( int, menuid))  from gtalarm..t_ui_menu
			set @pid = @pid + 1
			insert into gtalarm..t_ui_menu(   menuid,   parentmenuid,  menutitle, menutype, smartmenutype, smartfromname) 
						values(   @pid,  0,  @name,  '01',   '02',   @guid)
		end
		else
		begin
			select @pid = menuid from gtalarm..t_ui_menu where smartfromname = @guid
		end

		declare child cursor for select  [Name],  EntityGuid from EafFunctionTree where ParentId = @id
		open child
		fetch next from child into  @name, @guid
		while @@FETCH_STATUS = 0
		begin
			if not exists(select 1 from gtalarm..t_ui_menu where smartfromname = @guid)
			begin
				select @childid = max(convert( int, menuid))  from gtalarm..t_ui_menu
				set @childid = @childid + 1
				insert into gtalarm..t_ui_menu( menuid,  parentmenuid, menutitle, menutype, smartmenutype, smartfromname) 
				values(@childid, @pid, @name, '02', '02', @guid)
			end
			fetch next from child into  @name, @guid
		end
		close child
		deallocate child

		FETCH NEXT FROM root INTO @id, @name, @guid
	END
	
	CLOSE root
	DEALLOCATE root
END
GO

exec sp_import_function
go

