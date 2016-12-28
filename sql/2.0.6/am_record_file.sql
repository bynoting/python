/*==============================================================*/
/* Table: am_record_file                                        */
/*==============================================================*/
if not exists (select 1 from  sysobjects  where  id = object_id('am_record_file')  and   type = 'U')
begin
  create table am_record_file (
     guid                 guid                 not null,
     name                 chinese_name         not null,
     begin_time           datetime             null,
     file_path            url                  not null,
     width                int                  not null,
     height               int                  not null,
     video_format         nvarchar(30)         not null,
     is_has_audio         bool                 null,
     is_valid             bool                 null,
     duration_s           int                  not null,
     size_k               int                  not null,
     data_create_user     user_account         null,
     data_create_time     data_create_time     null,
     constraint PK_AM_RECORD_FILE primary key  (guid)
  )

  execute sp_bindefault zero_or_false, 'am_record_file.width'
  execute sp_bindefault zero_or_false, 'am_record_file.height'
  execute sp_bindefault null_string, 'am_record_file.video_format'
  execute sp_bindefault one_or_true, 'am_record_file.is_valid'
  execute sp_bindefault zero_or_false, 'am_record_file.is_has_audio'
  execute sp_bindefault zero_or_false, 'am_record_file.duration_s'
  execute sp_bindefault zero_or_false, 'am_record_file.size_k'
  execute sp_bindefault system_account, 'am_record_file.data_create_user'
end

go

