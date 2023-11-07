function main_Menu() 
{
    cls
    $serviceSearch = Read-host -Prompt "Would you like to view: `n[A]ll Services`n[R]unning Services`n[S]topped Services`nOr`n[E]xit"

    printChoice -search $serviceSearch
}

function printChoice()
{
    #argument passed
    Param([string]$search)
    
    if ($search -match "^[aA]$")
    {
        Get-WmiObject -Class Win32_Service
    }
    if ($search -match "^[rR]$")
    {
        Get-WmiObject -Class Win32_Service -Filter "state='Running'"
    }
    if ($search -match "^[sS]$")
    {
        Get-WmiObject -Class Win32_Service -Filter "state='Stopped'"
    }
    if ($search -match "^[eE]$")
    {
        Exit
    }
    Read-host -Prompt "`n`nPress enter to continue"
    main_Menu
}

main_Menu