if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.t_services_device')
            and   type = 'U')
   drop table dbo.t_services_device
go

