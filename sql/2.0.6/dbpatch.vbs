''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Description: Script for patch GTCA database before v2.0.6
' Author:      Zhangtao, 200704, zhangtao.it@gmail.com 
' Usage:       run on console -> cscript dbpatch.vbs
' Modification: 
'   200801 出错后停止执行脚本
'   200801 在2007年2月的内网数据库
'   200802 加入计划录像相关的表
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
On Error GoTo 0 

WScript.Echo "------------------------------STEP 1----------------------------------"
checkAndStartService "SQLSERVERAGENT"

WScript.Echo "------------------------------STEP 2----------------------------------"
executeSql "change option of db", "db_option.sql"
executeSql "create default types","default.sql"
executeSql "create customized types","domain.sql"

WScript.Echo "------------------------------STEP 3----------------------------------"
executeSql "creat or alter utility procedure","spt_modify_column_type.sql"
executeSql "creat or alter utility procedure","spt_show_big_tables.sql"
executeSql "creat or alter utility procedure","spt_drop_index.sql"
executeSql "creat or alter utility procedure","spt_rebuild_all_index.sql"

executeSql "drop temporary tables","drop_tmp_tables.sql"
executeSql "drop table","protocal_command.sql"
executeSql "truncate","deviceonlinelog.sql"
executeSql "alter table t_alarm_transmit_log","t_alarm_transmit_log.sql"
executeSql "alter table t_kinescopt_para","t_kinescopt_para.sql"
executeSql "alter table t_login_log","t_login_log.sql"
executeSql "alter table t_online_user","t_online_user.sql"
executeSql "alter table t_serial_port","t_serial_port.sql"
executeSql "alter table t_services.sql","t_services.sql"

executeSql "create table for ptz preset position of alarm","am_alarm_ptz_preset.sql"
executeSql "create device fault table","am_device_fault.sql"
executeSql "create device fault history table","am_device_fault_log.sql"
executeSql "create table for relation between services and alarm","am_services_alarm.sql"
executeSql "create table","am_services_device.sql"
executeSql "create table t_ca_device","t_ca_device.sql"
executeSql "create table t_ca_user","t_ca_user.sql"
executeSql "create table t_config_file","t_config_file.sql" 
executeSql "create table t_device_update_log","t_device_update_log.sql"
executeSql "create table t_services_device","t_services_device.sql"

executeSql "create view v_services_isp_live.sql","v_services_isp_live.sql"

executeSql "modify video server sn datatype","video_server_sn.sql"

executeSql "creat or alter procedure","sp_add_handle_log.sql"
executeSql "creat or alter procedure","sp_alarm_preset_update.sql"
executeSql "creat or alter procedure","sp_analysis_ca_validity.sql"
executeSql "creat or alter procedure","sp_device_fault_insert.sql"
executeSql "creat or alter procedure","sp_dispatch_service.sql"
executeSql "creat or alter procedure","sp_dispatch_transmit_for_user.sql"
executeSql "creat or alter procedure","sp_online_user_update.sql"
executeSql "creat or alter procedure","sp_query_without_ca_device.sql"
executeSql "creat or alter procedure","sp_query_without_ca_user.sql"
executeSql "creat or alter procedure","sp_require_device_control.sql"

executeSql "creat or alter utility procedure","spt_move_device_fault_log.sql"

executeSql "delete job for device fault log","delete_job_device_fault_log.sql"
executeSql "creat job to clear token daily","job_clear_token_daily.sql"

WScript.Echo "------------------------------STEP 4----------------------------------"
' added 20070427
executeSql "f_cacl_zone_id","f_cacl_zone_id.sql"

executeSql "t_input_port.sql","t_input_port.sql"
executeSql "t_video_server.sql","t_video_server.sql"
executeSql "tmp_video_server.sql","tmp_video_server.sql"
executeSql "am_alarm_action_serials.sql","am_alarm_action_serials.sql"

WScript.Echo "------------------------------STEP 5----------------------------------"
' added 20070509
executeSql "modify user account datatype","user_account.sql"
executeSql "config gtalarm","gtalarm.sql"
executeSql "normalize zond id(include motion detection)","normalize_zone_id.sql"
executeSql "delete useless linkage configuration","t_alarm_linkage.sql"
executeSql "modify alarm log table","t_alarm_log.sql"
executeSql "dictionary table","t_codediction.sql"

'added 2007 0530
executeSql "modify t_alarm_type","t_alarm_type.sql"

'added 2007 0616 from PanLongQuan
WScript.Echo "------------------------------STEP 6(From Pan)----------------------------"

executeSql "sp_alarm_ptz_preset_update","sp_alarm_ptz_preset_update.sql"
executeSql "sp_analysis_data","sp_analysis_data.sql"
executeSql "sp_query_data_paged","sp_query_data_paged.sql"
executeSql "sp_query_data_paged_new","sp_query_data_paged_new.sql"

executeSql "update t_kinescope_plan","t_kinescope_plan.sql"

executeSql "v_sub_device","v_sub_device.sql"

executeSql "t_ptz","t_ptz.sql"

executeSql "v_user","v_user.sql"
executeSql "v_video_devices","v_video_devices.sql"

executeSql "t_video_input_port","t_video_input_port.sql"
executeSql "modify t_event_sender_set","t_event_sender_set.sql"
executeSql "create view v_zone_info.sql","v_zone_info.sql"

'20071031
executeSql "delete_procedure","delete_procedure.sql"

'20071107
executeSql "am_map_position","am_map_position.sql"
executeSql "t_ui_menu","t_ui_menu.sql"

'20071124
executeSql "sp_dispatch_service_for_device","sp_dispatch_service_for_device.sql"

'200801
executeSql "sp_query_by_split_page","sp_query_by_split_page.sql"

'200801 move to here from above
executeSql "v_watch_point_device.sql","v_watch_point_device.sql"
executeSql "v_autocheck_result","v_autocheck_result.sql"
executeSql "v_device_fault_all","v_device_fault_all.sql"
executeSql "v_device_fault_all_static","v_device_fault_all_static.sql"
executeSql "creat or alter procedure","sp_manage_gateway.sql"

'20080215
executeSql "am_zone_state_log","am_zone_state_log.sql"

'200802 for plan
executeSql "f_replace_time","f_replace_time.sql"
executeSql "f_days_of_month","f_days_of_month.sql"
executeSql "am_plan","am_plan.sql"
executeSql "am_plan_record","am_plan_record.sql"
executeSql "am_plan_log","am_plan_log.sql"
executeSql "sp_query_plan_valid","sp_query_plan_valid.sql"
executeSql "v_plan_task_timeout","v_plan_task_timeout.sql"

'200803 for record
executeSql "am_record_file","am_record_file.sql"
executeSql "am_record_biz","am_record_biz.sql"
executeSql "v_plan_record_log","v_plan_record_log.sql"
executeSql "v_biz_record_file","v_biz_record_file.sql"
executeSql "v_biz_record_file_plan","v_biz_record_file_plan.sql"
executeSql "v_biz_record_file_alarm","v_biz_record_file_alarm.sql"

'20080332 add by Panlongquan
WScript.Echo "------------------------------STEP 7(From Pan)----------------------------"
executeSql "v_alarm_record_file","v_alarm_record_file.sql"
executeSql "v_alarmDayCollect","v_alarmDayCollect.sql"
executeSql "v_case_alarm_report","v_case_alarm_report.sql"
executeSql "v_user_login_report","v_user_login_report.sql"

executeSql "spt_analysis_data","spt_analysis_data.sql"
executeSql "sp_alarm_statistics","sp_alarm_statistics.sql"
executeSql "sp_delete_matrix","sp_delete_matrix.sql"
executeSql "sp_delete_ptz","sp_delete_ptz.sql"
executeSql "sp_delete_lens","sp_delete_lens.sql"
executeSql "sp_delete_video_server","sp_delete_video_server.sql"
executeSql "creat or alter procedure","sp_issue_ca_device.sql"
executeSql "creat or alter procedure","sp_issue_ca_user.sql"
executeSql "sp_query_alarm","sp_query_alarm.sql"
executeSql "sp_query_devicelock","sp_query_devicelock.sql"
executeSql "sp_query_devicelock_log","sp_query_devicelock_log.sql"
executeSql "sp_query_photo","sp_query_photo.sql"
executeSql "sp_query_record","sp_query_record.sql"
executeSql "sp_query_record_by_alarm","sp_query_record_by_alarm.sql"

executeSql "sp_get_record_ftp_info","sp_get_record_ftp_info.sql"

executeSql "sp_tree","sp_tree.sql"

' print_db_info must be the latest one'
executeSql "print_db_info","print_db_info.sql"
WScript.Echo ""
WScript.Echo "--> DB PATCH IS DONE."
WScript.Echo "--> Please read output CAREFULLY to confirm a successful patch."

'execute a sql script file on local sqlserver
function executeSql(info,sqlFile)
    WScript.Echo ">>" & sqlFile & "(" & info & ")"
    executeSql = run("osql -E -r -n -b -d gtalarm -i " & sqlFile)

    if executeSql <> 0 then
	Err.Raise vbObjectError,, "Failed to execute " & sqlFile 
    end if
end function 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' runs an external program and pipes it's output to the StdOut and StdErr streams of the current script.
' Returns the exit code of the external program.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function run (ByVal cmd)
    Dim sh: Set sh = CreateObject("WScript.Shell")
    Dim wsx: Set wsx = Sh.Exec(cmd)

    If wsx.ProcessID = 0 And wsx.Status = 1 Then
	' (The Win98 version of VBScript does not detect WshShell.Exec errors)
	Err.Raise vbObjectError,,"WshShell.Exec failed."
    End If
    Do
	Dim Status: Status = wsx.Status

	WScript.StdOut.Write wsx.StdOut.ReadAll()
	WScript.StdErr.Write wsx.StdErr.ReadAll()

	If Status <> 0 Then Exit Do
	WScript.Sleep 10
    Loop
    run = wsx.ExitCode
End Function

' runs an internal command interpreter command.      ' %ComSpec% : the full path of cmd.exe
Function runCommand (ByVal cmd)
    runCommand = run("%ComSpec% /c " & cmd)
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Check and start the status of service
' If it's status isn't running, change service to be automatic start and start it
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function checkAndStartService(serviceName)
    set objService = findServiceObject(serviceName)
    if objService.State <> "running" then
	Wscript.Echo ">>start service: " & serviceName 
	WScript.Echo "  - change service to automatic: " & objService.Change( , , , , "Automatic")   
	WScript.Echo "  - start service : " & objService.StartService()
	Wscript.Echo "<<start service: " & serviceName 
    end if
end function

function findServiceObject(serviceName)
    strComputer = "."
    Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
    Set services = objWMIService.ExecQuery ("Select * from Win32_Service Where Name = '" & serviceName & "'")
    For Each objService in services
	set findServiceObject = objService
	exit function
    Next
end function

