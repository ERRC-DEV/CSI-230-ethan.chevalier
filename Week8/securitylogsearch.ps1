# Review security event log

$myDir = "C:\Users\champuser\Desktop"

# List logs
Get-EventLog -list

# Prompt user for selecting what log to view
$whichLog = Read-host -Prompt "Please select which log to review from the above list"
$searchString = Read-host -Prompt "Please enter the string you would like to search for"

# Print results
Get-EventLog -Logname $whichlog -Newest 40 | where {$_.Message -ilike "*$searchString*"} | export-csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"