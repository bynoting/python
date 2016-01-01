
if not exists (select 1 from t_codediction where codetype='control_protocal' and codevalue='Hbgk Matrix Protocol')
	insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) values ('control_protocal','串口控制协议','Hbgk Matrix Protocol','汉邦高科矩阵协议',0)		

if not exists (select 1 from t_codediction where codetype='control_protocal' and codevalue='AD Protocol')
	insert into t_codediction (codetype,codetypename,codevalue,codename,maintflag) values ('control_protocal','串口控制协议','AD Protocol','AD 矩阵协议',0)		

go