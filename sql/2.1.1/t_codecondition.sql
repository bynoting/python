
if not exists (select 1 from t_codediction where codetype='control_protocal' and codevalue='Hbgk Matrix Protocol')
	insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) values ('control_protocal','���ڿ���Э��','Hbgk Matrix Protocol','����߿ƾ���Э��',0)		

if not exists (select 1 from t_codediction where codetype='control_protocal' and codevalue='AD Protocol')
	insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) values ('control_protocal','���ڿ���Э��','AD Protocol','AD ����Э��',0)		

go