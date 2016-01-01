''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Description: Script for patch GTCA database before v2.1.0
' Author:      Zhangtao, 200805, zhangtao.it@gmail.com 
' Usage:       run on console -> cscript dbpatch.vbs
' Modification: 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
On Error GoTo 0 

WScript.Echo "------------------------------STEP 1----------------------------------"
checkAndStartService "SQLSERVERAGENT"

executeSql "domain","domain.sql"

executeSql "spt_id_to_guid","spt_id_to_guid.sql"

executeSql "sp_get_record_ftp_info","sp_get_record_ftp_info.sql"
executeSql "sp_tree","sp_tree.sql"

WScript.Echo "new data for CHECKTYPE in t_codediction"
executeQuery "delete t_codediction where codetype ='CHECKTYPE'"
importData "t_codediction","t_codediction_checktype.cvs"

executeSql "t_alarm_type","t_alarm_type.sql"
executeQuery "truncate table t_alarm_type"
importData "t_alarm_type","t_alarm_type.cvs"

executeSql "am_alarm_action","am_alarm_action.sql"
importData "am_alarm_action","am_alarm_action.cvs"

executeSql "am_alarm_action_config","am_alarm_action_config.sql"
importData "am_alarm_action_config","am_alarm_action_config.cvs"

' from panlongquan
executeSql "sp_alarm_statistics","sp_alarm_statistics.sql"
executeSql "sp_query_alarm","sp_query_alarm.sql"
executeSql "sp_query_devicelock","sp_query_devicelock.sql"
executeSql "sp_query_devicelock_log","sp_query_devicelock_log.sql"
executeSql "t_codediction","t_codediction.sql"
executeSql "v_alarmDayCollect","v_alarmDayCollect.sql"
executeSql "v_case_alarm_report","v_case_alarm_report.sql"
executeSql "v_zone_state_log","v_zone_state_log.sql"

' from panlongquan 20080620
executeSql "am_map_marker_type.sql","am_map_marker_type.sql"
executeSql "am_map_markers","am_map_markers.sql"
executeSql "am_map_position","am_map_position.sql"
executeSql "am_notice","am_notice.sql"
executeSql "am_notice_receiver","am_notice_receiver.sql"
executeSql "am_notice_receipt","am_notice_receipt.sql"
executeSql "am_notice_read_user","am_notice_read_user.sql"
executeSql "v_am_notice_query","v_am_notice_query.sql"
executeSql "v_watch_point_device","v_watch_point_device.sql"
executeSql "v_autocheck_result","v_autocheck_result.sql"
executeSql "sp_get_link_device","sp_get_link_device.sql"
executeSql "sp_query_online_user","sp_query_online_user.sql"
executeSql "sp_alarm_statistics","sp_alarm_statistics.sql"

WScript.Echo "new data for NOTICE_STATE NOTICE_TYPE in t_codediction"
executeQuery "delete t_codediction where codetype ='NOTICE_TYPE'"
executeQuery "delete t_codediction where codetype ='NOTICE_STATE'"
importData "t_codediction","t_codediction_notice.cvs"

'200807
executeSql "f_cacl_zone_id_linkage","f_cacl_zone_id_linkage.sql"
executeSql "t_alarm_linkage","t_alarm_linkage.sql"

'200808
executeSql "t_map","t_map.sql"
executeSql "t_video_encoder","t_video_encoder.sql"

'200810
executeSql "update_notice_state_job","update_notice_state_job.sql"
executeSql "gtmap_update_20081024","gtmap_update_20081024.sql"

'200811
executeSql "sp_delete_video_server","sp_delete_video_server.sql"
executeSql "vc_video_conference","vc_video_conference.sql"
executeSql "am_device_fault","am_device_fault.sql"
executeSql "sp_device_fault_insert","sp_device_fault_insert.sql"
executeSql "am_group","am_group.sql"

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

function executeQuery(query)
    WScript.Echo ">>" & query 
    executeQuery = run("osql -E -r -n -b -d gtalarm -Q """ & query & """")

    if executeQuery <> 0 then
	Err.Raise vbObjectError,, "Failed to execute " & query 
    end if
end function 


function importData(table,dataFile)
    WScript.Echo ">> import data to " & table & "(" & dataFile & ")"

    importData = run("bcp gtalarm.." & table & " in " & dataFile & " -c -T")

    if importData <> 0 then
	Err.Raise vbObjectError,, "Failed to import " & dataFile 
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

