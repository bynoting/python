use gtalarm
/** 批量查询后插入不写日志 */
exec sp_dboption 'gtalarm', 'select into/bulkcopy', 'true'
go



