if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_get_link_device]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_get_link_device]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
//Description :获取指定设备及其连接的设备数据集
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2008-05-07
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_get_link_device
	@user_account		varchar(36),
	@video_server_sns	varchar(4000)
AS
	declare @position 		int
	declare @video_server_sn	varchar(16)
	declare @split_char  		varchar(2)
	declare @split_char_length 	int
	declare @tree_id 		int
	declare @is_admin		int

	exec sp_check_is_admin @user_account, @is_admin output

	set @split_char='||'
	set @split_char_length = len(@split_char)

	CREATE TABLE #tmp_device_tree (
		[tree_id] 		[int]  ,
		[device_type_id] 	[smallint] ,
		[device_number]		 [varchar] (50)  ,
		[device_guid]		 [nvarchar] (36),
		[device_name]		 [varchar] (100) ,
		[parent_tree_id] 		[int]
	) 

	while  len(@video_server_sns) > 0
	begin
		set @position = charindex(@split_char,@video_server_sns)
	
		if @position >0
		begin
			set @video_server_sn = ltrim(rtrim(substring(@video_server_sns, 1, @position - 1)))
			set @video_server_sns = substring(@video_server_sns,@position + @split_char_length, len(@video_server_sns) - @position)
		end
		else 
		begin
			set @video_server_sn =  ltrim(rtrim(@video_server_sns))
			set @video_server_sns = ''
		end

		print @video_server_sn
		if exists(select tree_id from t_tree where device_type_id = 3 and device_guid = @video_server_sn)
			select @tree_id = tree_id from t_tree where device_type_id = 3 and device_guid = @video_server_sn
		else
			continue
		print @tree_id

		if @is_admin = 1
		begin
			insert into  #tmp_device_tree(tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id)
			 select tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id
			from t_tree where tree_id = @tree_id or parent_tree_id = @tree_id

			insert into  #tmp_device_tree(tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id)
			select tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id
			from t_tree where parent_tree_id in(select tree_id from t_tree where device_type_id = 4 and parent_tree_id = @tree_id) 
		end
		else
		begin
			insert into  #tmp_device_tree(tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id) 
			select tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id
			from v_useraccount_device where useraccount = @user_account and (tree_id = @tree_id or parent_tree_id = @tree_id)

			insert into  #tmp_device_tree(tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id) 
			select tree_id, device_type_id, device_number, device_guid, device_name, parent_tree_id
			from v_useraccount_device where useraccount = @user_account and (parent_tree_id in(select tree_id from t_tree where device_type_id = 4 and parent_tree_id = @tree_id))
		end
	end

	--将视频服务器作为树的第1级节点
	update #tmp_device_tree set parent_tree_id = 0 where device_type_id = 3

	select * from #tmp_device_tree
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

