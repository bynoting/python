if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.deviceonlinelog')
            and   type = 'U')
   drop table dbo.deviceonlinelog
go


if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.DeviceOnlineStatus')
            and   type = 'U')
   drop table dbo.DeviceOnlineStatus
go

