-- 删除整改计划或巡检计划
DELETE FROM dbo.T_UI_MENU
WHERE (MENUTITLE LIKE '%整改计划%' OR MENUTITLE LIKE '%巡检计划%' OR MENUTITLE LIKE '%巡检管理%' OR MENUTITLE LIKE '%DEMO%')

DELETE FROM dbo.T_UI_PAGE
WHERE (PAGETITLE LIKE '%整改计划%' OR PAGETITLE LIKE '%巡检计划%' OR PAGETITLE LIKE '%巡检管理%' OR PAGETITLE LIKE '%DEMO%')
