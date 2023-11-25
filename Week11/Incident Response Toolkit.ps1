$userDir = Read-Host "Enter the directory to save the information to. Type `"default`" to save to C:\Users\champuser\CSI-230-ethan.chevalier\Week11"

if ( $userDir -eq "default" )
{
    $userDir = "C:\Users\champuser\CSI-230-ethan.chevalier\Week11"
}


Get-Process | Select-Object Name, Path | export-csv -NoTypeInformation -Path "$userDir\processes.csv"
Get-WmiObject -Class Win32_Service -Filter "state='Running'" | export-csv -NoTypeInformation -Path "$userDir\services.csv"
Get-NetTCPConnection | export-csv -NoTypeInformation -Path "$userDir\TCP_Sockets.csv"
Get-WmiObject -Class Win32_UserAccount | export-csv -NoTypeInformation -Path "$userDir\user_Accounts.csv"
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | export-csv -NoTypeInformation -Path "$userDir\network_Config.csv"

# 4 cmdlets

# Security event logs will be useful as it will allow you to see if changes were made recently to your security
Get-EventLog -LogName Security | export-csv -NoTypeInformation -Path "$userDir\security_EventLogs.csv"
# System event logs will also prove useful to check if something has embedded itself in your system, created a backdoor, changed settings, etc.
Get-EventLog -LogName System | export-csv -NoTypeInformation -Path "$userDir\system_EventLogs.csv"
# Similarly, application event logs will be very helpful to have as well to see if anything has embedded itself in your applications or if a new application is issuing hazardous commands
Get-EventLog -LogName Application | export-csv -NoTypeInformation -Path "$userDir\application_EventLogs.csv"
# Checking which (if any) accounts have administrator privilages can help you to see if anything has given itself administrator privilages on your machine
Get-LocalGroupMember -Group Administrators | export-csv -NoTypeInformation -Path "$userDir\administrator_Users.csv"

