
---------------------------------------------------------------------------------------------------
-- ��ϵͳ�������м����ͼվ���ַ
---------------------------------------------------------------------------------------------------
if not exists (select 1 from t_sys_parameter where paramname = 'map_site_url' and paramtype='01')
	insert into t_sys_parameter (paramtype,paramname,paradesc,paraval) values ('01','map_site_url','��ͼվ���ַ','http://www.gtalarm.net.cn/map')	
go

delete T_SYS_PARAMETER where PARAMTYPE='01' and PARAMNAME='map_range'
insert into T_SYS_PARAMETER (PARAMTYPE, PARAMNAME, PARAVAL, PARADESC, PARAREMARK)
values('01', 'map_range', '200,500,1000,2000', '��ͼ�ɹ�ѡ�����ʾ��Χ', '�����","�ָ�')
---------------------------------------------------------------------------------------------------
-- ȥ���ֵ���ж�����豸���ϵ�������
---------------------------------------------------------------------------------------------------
delete T_CODEDICTION where CODETYPE = 'POSITION'


---------------------------------------------------------------------------------------------------
-- ����һ�����ݿ��ɫ��Ϊ��̨ϵͳʹ��
---------------------------------------------------------------------------------------------------
declare @logindb nvarchar(132)
declare @loginlang nvarchar(132) 
declare @user nvarchar(50)

select @logindb = N'gtalarm', @loginlang = N'��������',@user = N'gtalarm'

if not exists (select * from master..syslogins where name = N'gtalarm')
BEGIN	
	exec sp_addlogin @user, null, @logindb, @loginlang	
	exec sp_password Null ,'gt.dev.db.4',@user 
END

Use gtalarm
Go

if not exists (select * from sysusers where name = 'gtalarm')
	EXEC sp_grantdbaccess gtalarm, 'gtalarm'
GO

exec sp_addrolemember N'db_owner', 'gtalarm'
go

