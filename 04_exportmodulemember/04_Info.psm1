function Get-Info04
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info04]'
    $class = Get-Class04
    Get-WmiObject -ComputerName $ComputerName -Class $class
}

function Get-Class04
{
    return 'Win32_BIOS'
}

Export-ModuleMember -Function Get-Info04
