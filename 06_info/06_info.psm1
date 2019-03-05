function Get-Info06
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info06]'
    $class = Get-Class06
    Get-WmiObject -ComputerName $ComputerName -Class $class
}

function Get-Class06
{
    return 'Win32_BIOS'
}

Export-ModuleMember -Function Get-Info06
