function Get-Info02
{
    param($ComputerName)
    Write-Verbose -Verbose 'Executing [Get-Info02]'
    Get-WmiObject -ComputerName $ComputerName -Class Win32_BIOS
}
