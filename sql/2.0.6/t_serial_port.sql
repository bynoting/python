if exists( select 1 from sysobjects where name = 'DF_t_serial_port_data_bit')
	alter table t_serial_port drop constraint DF_t_serial_port_data_bit

ALTER TABLE [dbo].[t_serial_port] ADD 	CONSTRAINT [DF_t_serial_port_data_bit] DEFAULT (8) FOR [data_bit]
GO


if exists( select 1 from sysobjects where name = 'DF_t_serial_port_stop_bit')
	alter table t_serial_port drop constraint DF_t_serial_port_stop_bit

ALTER TABLE [dbo].[t_serial_port] ADD 	CONSTRAINT [DF_t_serial_port_stop_bit] DEFAULT (1) FOR [stop_bit]


if exists( select 1 from sysobjects where name = 'DF_t_serial_port_transmit_speed')
	alter table t_serial_port drop constraint DF_t_serial_port_transmit_speed

ALTER TABLE [dbo].[t_serial_port] ADD 	CONSTRAINT [DF_t_serial_port_transmit_speed] DEFAULT (9600) FOR [transmit_speed]
GO


EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[t_serial_port].[flow]'
GO

/** set defaul value for legacy data */
update t_serial_port set transmit_speed = 9600 where transmit_speed is null
update t_serial_port set stop_bit = 1 where stop_bit is null
update t_serial_port set data_bit = 8 where data_bit is null
update t_serial_port set flow = 0 where flow is null