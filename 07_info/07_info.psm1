function Get-Info07
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info07]'
    $class = Get-Class07
    Get-WmiObject -ComputerName $ComputerName -Class $class
}

function Get-Class07
{
    return 'Win32_BIOS'
}

Export-ModuleMember -Function Get-Info07
