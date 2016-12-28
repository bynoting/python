''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Description: Script for patch GTCA database before v2.1.0
' Author:      Zhangtao, 200805, zhangtao.it@gmail.com 
' Usage:       run on console -> cscript dbpatch.vbs
' Modification: 

' Export Data:
'	>bcp "select * from [gtalarm]..EafFunctionTree" queryout EafFunctionTree.csv -c -T
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
On Error GoTo 0 

WScript.Echo "------------------------------STEP 1----------------------------------"
checkAndStartService "SQLSERVERAGENT"

' modified db for car recognition
executeSql "t_alarm_log_info","t_alarm_log_info.sql"
executeQuery "truncate table dbo.am_alarm_action_config"
importData "am_alarm_action_config","am_alarm_action_config.csv"

executeSql "t_alarm_type","t_alarm_type.sql"
executeQuery "truncate table dbo.t_alarm_type"
importData "t_alarm_type","t_alarm_type.csv"

'add  hbgk and AD protocal
executeSql "t_codecondition","t_codecondition.sql"

'add by panglongquan 20090515
executeSql "CustomerSqlScript","CustomerSqlScript.sql"
executeSql "trash","trash.sql"

executeSql "am_gps_location","am_gps_location.sql"
executeSql "am_gps_track","am_gps_track.sql"

'add by panlongquan 20100421
executeSql "spt_analysis_data","spt_analysis_data.sql"
executeSql "sp_delete_video_server","sp_delete_video_server.sql"
executeSql "t_video_server","update_t_video_server.sql"
executeSql "t_input_port","update_t_input_port.sql"
executeSql "EafFunctionTree","EafFunctionTree.sql"
importData "EafFunctionTree","EafFunctionTree.csv"
executeSql "ImportClientFunction","ImportClientFunction.sql"
executeSql "update_t_ui_menu","update_t_ui_menu.sql"

'add by lixingang 20100510
executeSql "gtmap_marker_icon","gtmap_marker_icon.sql"

'add by panlongquan 20100608 for plan photo
executeSql "am_switch_device","am_switch_device.sql"
executeSql "am_plan_photo","am_plan_photo.sql"
executeSql "v_video_devices","v_video_devices.sql"
executeSql "v_plan_record_log","v_plan_record_log.sql"
executeSql "sp_query_plan_valid","sp_query_plan_valid.sql"
executeSql "plan_photo","plan_photo.sql"
executeSql "v_biz_record_file_plan","v_biz_record_file_plan.sql"

' print_db_info must be the latest one'
executeSql "print_db_info","print_db_info.sql"
'WScript.Echo ""
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

	If WScript.fullname = WScript.Path & "\cscript.exe" Then
		WScript.StdOut.Write wsx.StdOut.ReadAll()
		WScript.StdErr.Write wsx.StdErr.ReadAll()
	Else 
		Dim errMsg
		errMsg = wsx.StdErr.ReadAll()
		If errMsg <> "" then
			WScript.Echo errMsg
		End If
	End If

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

