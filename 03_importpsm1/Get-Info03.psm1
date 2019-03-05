function Get-Info03
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info03]'
    Get-WmiObject -ComputerName $ComputerName -Class Win32_BIOS
}
