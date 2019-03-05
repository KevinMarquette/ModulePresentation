function Get-Info01
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info01]'
    Get-WmiObject -ComputerName $ComputerName -Class Win32_BIOS
}
