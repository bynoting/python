if exists (select * from dbo.systypes where name = N'plan_type')
	EXEC sp_unbindrule N'plan_type'
else
	EXEC sp_addtype N'plan_type', N'int', N'null'

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[R_plan_type]') and OBJECTPROPERTY(id, N'IsRule') = 1)
	drop rule [dbo].[R_plan_type]
GO

create rule [R_plan_type] as @column is null or (@column in (0,1,2,3))
GO

EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[plan_type]'
GO

EXEC sp_bindrule N'[dbo].[R_plan_type]', N'[plan_type]'
GO

if exists (select * from dbo.systypes where name = N'plan_task_type')
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[plan_task_type]'

