#New-SSHSession -ComputerName '192.168.4.22' -Credential (Get-Credential sys320)
$running = true
while ($running)
{
    $the_cmd = Read-Host -Prompt "Please enter a command"
    
    (Invoke-SSHCommand -index 0 $the_cmd).Output

    if ($the_cmd -eq "exit")
    {
        $running = false
    }
}

Set-SCPFile -ComputerName '192.168.4.22' -Credential (Get-Credential sys320) `
-RemotePath '/home/champuser' -LocalFile '.\test.txt'