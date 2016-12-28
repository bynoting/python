/*==============================================================*/
/* Table: am_record_biz                                         */
/*==============================================================*/
if not exists (select 1 from  sysobjects where  id = object_id('am_record_biz') and   type = 'U')
begin
  create table am_record_biz (
     guid                 guid                 not null,
     biz_guid             guid                 not null,
     biz_type             record_biz_type      not null,
     record_type          record_type          not null,
     record_state         task_state           not null,
     file_guid            guid                 not null,
     message              nvarchar(255)        null,
     data_create_user     user_account         null,
     data_create_time     data_create_time     null,
     constraint PK_AM_RECORD_BIZ primary key  (guid)
  )
 
  /*==============================================================*/
  /* Index: idx_am_record_biz_guid                                */
  /*==============================================================*/
  create   index idx_am_record_biz_guid on am_record_biz (  biz_guid ASC  )  
  create   index idx_am_record_biz_file_guid on am_record_biz (  file_guid ASC  )  
  
  execute sp_bindefault system_account, 'am_record_biz.data_create_user'
end    
go


