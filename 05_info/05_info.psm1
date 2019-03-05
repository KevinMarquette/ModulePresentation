function Get-Info05
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info05]'
    $class = Get-Class05
    Get-WmiObject -ComputerName $ComputerName -Class $class
}

function Get-Class05
{
    return 'Win32_BIOS'
}

Export-ModuleMember -Function Get-Info05
