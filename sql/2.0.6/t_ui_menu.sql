-- 删除工程队信息管理
delete from T_UI_MENU where PAGEID='89'
delete from T_UI_PAGE where PAGEID='89'

-- 删除巡检维修单制定
delete from T_UI_MENU where PAGEID='46'
delete from T_UI_PAGE where PAGEID='46'

-- 删除录象计划管理
delete from T_UI_MENU where PAGEID='28'
delete from T_UI_PAGE where PAGEID='28'

-- 删除电子地图信息维护
if exists (select 1 from t_sys_parameter where paramname = 'map_site_url' and paramtype='01')
	begin
		delete from T_UI_MENU where PAGEID='15'
		delete from T_UI_PAGE where PAGEID='15'
	end
