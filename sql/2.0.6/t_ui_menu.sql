-- ɾ�����̶���Ϣ����
delete from T_UI_MENU where PAGEID='89'
delete from T_UI_PAGE where PAGEID='89'

-- ɾ��Ѳ��ά�޵��ƶ�
delete from T_UI_MENU where PAGEID='46'
delete from T_UI_PAGE where PAGEID='46'

-- ɾ��¼��ƻ�����
delete from T_UI_MENU where PAGEID='28'
delete from T_UI_PAGE where PAGEID='28'

-- ɾ�����ӵ�ͼ��Ϣά��
if exists (select 1 from t_sys_parameter where paramname = 'map_site_url' and paramtype='01')
	begin
		delete from T_UI_MENU where PAGEID='15'
		delete from T_UI_PAGE where PAGEID='15'
	end
