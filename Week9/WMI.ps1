$myDir = "C:\Users\champuser\Desktop"

#GETTING IPS
Get-WmiObject -Class Win32_NetworkAdapterConfiguration

# Get and export running services
Read-host -Prompt "The running services segment begins here"
Get-WmiObject -Class Win32_Service -Filter "state='Running'" | export-csv -NoTypeInformation -Path "$myDir\runningServices.csv"
Get-WmiObject -Class Win32_Service -Filter "state='Running'"

# CALCULATOR
Read-host -Prompt "The calculator segment begins here"
Start-Process win32calc.exe
Read-host
$p = Get-Process -Name win32calc
Stop-Process -InputObject $p