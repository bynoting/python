if exists( select 1 from sysobjects 
	where name = 'DF_t_kinescope_param_ahead_time')
	alter table t_kinescope_param drop constraint DF_t_kinescope_param_ahead_time
	
if exists( select 1 from sysobjects 
	where name = 'DF_t_kinescope_param_delay_time')
	alter table t_kinescope_param drop constraint DF_t_kinescope_param_delay_time

if exists( select 1 from sysobjects 
	where name = 'DF_t_kinescope_param_file_length')
	alter table t_kinescope_param drop constraint DF_t_kinescope_param_file_length

if exists( select 1 from sysobjects 
	where name = 'DF_t_kinescope_param_sample_rate')
	alter table t_kinescope_param drop constraint DF_t_kinescope_param_sample_rate

if exists( select 1 from sysobjects 
	where name = 'DF_t_kinescope_param_sample_precision')
	alter table t_kinescope_param drop constraint DF_t_kinescope_param_sample_precision


ALTER TABLE [dbo].[t_kinescope_param] ADD 
	CONSTRAINT [DF_t_kinescope_param_ahead_time] DEFAULT (0) FOR [ahead_time],
	CONSTRAINT [DF_t_kinescope_param_delay_time] DEFAULT (0) FOR [delay_time],
	CONSTRAINT [DF_t_kinescope_param_file_length] DEFAULT (0) FOR [file_length],
	CONSTRAINT [DF_t_kinescope_param_sample_rate] DEFAULT (0) FOR [sample_rate],
	CONSTRAINT [DF_t_kinescope_param_sample_precision] DEFAULT (0) FOR [sample_precision]
GO

