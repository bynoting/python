if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vc_video_conference]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	alter table vc_video_conference alter column [name] nvarchar(60) not null
	alter table vc_video_conference alter column [compere] nvarchar(32) not null
	alter table vc_video_conference alter column [remark] nvarchar(100) null
end