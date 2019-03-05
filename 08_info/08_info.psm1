function Get-Info08
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info08]'
    $class = Get-Class08
    Get-WmiObject -ComputerName $ComputerName -Class $class
}

function Get-Class08
{
    return 'Win32_BIOS'
}
