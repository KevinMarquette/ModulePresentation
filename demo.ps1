#region Cleanup
Remove-Item "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\06_info" -Recurse -Force -ErrorAction Ignore
Remove-Item .\07_info\07_info.psd1 -ErrorAction Ignore
Remove-Item .\08_info\08_info.psd1 -ErrorAction Ignore
break;
#endregion


# Function
function Get-Info
{
    param($ComputerName)
    Get-WmiObject -ComputerName $ComputerName -Class Win32_BIOS
}

Get-Info -ComputerName localhost




# Dot sourcing

. .\01_dotsource\Get-Info01.ps1
Get-Info01 -ComputerName localhost

Get-Module Get-Info*



# Import-Module
Import-Module .\03_importpsm1\Get-Info03.psm1 -Verbose
Get-Info03 -ComputerName localhost

Get-Module Get-Info*




# Export-ModuleMember
Import-Module .\04_exportmodulemember\04_Info.psm1 -Verbose
Get-Info04 -ComputerName localhost

Get-Module Info*

Get-Class04

InModuleScope -ModuleName Info04 {
    Get-Class04
}





# folder names

<#
Scripts
│   myscript.ps1
│
└───GetInfo
        GetInfo.psm1
#>

Import-Module .\05_info -Verbose
Get-Info05 -ComputerName localhost





# $ENV:PSModulePath
$ENV:PSModulePath -split ';'
<#
C:\Users\kmarquette\Documents\WindowsPowerShell\Modules
C:\Program Files\WindowsPowerShell\Modules
C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
#>

$copyItemSplat = @{
    Path = '.\06_info'
    Destination = "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\"
    Recurse = $true
}
Copy-Item @copyItemSplat

LS "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\"

Get-Module 06_info -ListAvailable

# Auto Import
Get-Info06 -ComputerName localhost




# $PSModuleAutoloadingPreference 
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-6

$PSModuleAutoloadingPreference = 'none'
$PSModuleAutoloadingPreference = 'ModuleQualified' # MyModule\MyCommand
$PSModuleAutoloadingPreference = 'All'





# Module Manifest
tree /f 

$manifest = @{
    Path              = '.\07_info\07_info.psd1'
    RootModule        = '07_info.psm1' 
    Author            = 'Kevin Marquette'
}
New-ModuleManifest @manifest 

Import-Module .\07_info -Verbose
Get-Info07 -ComputerName localhost

code .\07_info\07_info.psd1





# FunctionsToExport
# remove Export-ModuleMember

$manifest = @{
    Path              = '.\08_info\08_info.psd1'
    RootModule        = '08_info.psm1' 
    Author            = 'Kevin Marquette'
    FunctionsToExport = 'Get-Info08'
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
New-ModuleManifest @manifest

Import-Module .\08_info -Verbose
Get-Info08 -ComputerName localhost

code .\08_info\08_info.psd1



# other manifest properties
#> requiredModules
@{
    RequiredModules = @(
        'ActiveDirectory'
    )
}
code C:\ldx\ldxset\LDXSet\LDXSet.psd1

#> NestedModules
@{
    NestedModules     = @(
        'bin\DependsOn.dll'
    )
}

code C:\workspace\DependsOn\DependsOn\DependsOn.psd1

#> 

# way to do requires

#> Requires statment at top of script
#Requires -Modules GetInfo
GetInfo -ComputerName localhost



# Binary modules

