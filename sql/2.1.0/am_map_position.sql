---------------------------------------------------------------------------------
-- É¾³ýµØÍ¼Ãû³Æ×Ö¶Î
---------------------------------------------------------------------------------
if exists( select 1 from dbo.syscolumns s where name ='map_name'
	and id = object_id(N'am_map_position'))
begin
	alter table am_map_position drop column map_name
end
