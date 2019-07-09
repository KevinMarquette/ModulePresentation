#region Cleanup
Remove-Item "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\06_info" -Recurse -Force -ErrorAction Ignore
Remove-Item .\07_info\07_info.psd1 -ErrorAction Ignore
Remove-Item .\08_info\08_info.psd1 -ErrorAction Ignore
Remove-Item '.\09_info' -ErrorAction Ignore -Recurse
Remove-Item '.\10_info' -ErrorAction Ignore -Recurse
Remove-Item 'c:\temp\MyRepository' -ErrorAction Ignore -Recurse
Get-PSRepository -Name MyRepository -ErrorAction Ignore | Unregister-PSRepository
function prompt {"AZPowerShell:>"}
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
code .\01_dotsource\Get-Info01.ps1
. .\01_dotsource\Get-Info01.ps1
Get-Info01 -ComputerName localhost



# Import-Module ps1
code .\02_importps1\Get-Info02.ps1
Import-Module .\02_importps1\Get-Info02.ps1 -Verbose
Get-Info02 -ComputerName localhost

Get-Module Get-Info02


# Import-Module psm1
code .\03_importpsm1\Get-Info03.psm1
Import-Module .\03_importpsm1\Get-Info03.psm1 -Verbose
Get-Info03 -ComputerName localhost

Get-Module Get-Info03




# Export-ModuleMember
code .\04_exportmodulemember\04_Info.psm1
Import-Module .\04_exportmodulemember\04_Info.psm1 -Verbose
Get-Info04 -ComputerName localhost

Get-Module 04_Info

# Private function
Get-Class04

InModuleScope -ModuleName 04_Info {
    Get-Class04
}





# folder names for modules

<#
Scripts
│   myscript.ps1
│
└───05_info
        05_info.psm1
#>

Import-Module .\05_info -Verbose
Get-Info05 -ComputerName localhost





# $ENV:PSModulePath
$ENV:PSModulePath -split ';'
<#
C:\Users\kmarquette\Documents\PowerShell\Modules
C:\Program Files\PowerShell\Modules
C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
#>

# Installing from PSGallery
Install-Module -Name dependson -scope AllUsers


# Installing by hand
$copyItemSplat = @{
    Path = '.\06_info'
    Destination = "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\"
    Recurse = $true
}
Copy-Item @copyItemSplat

Get-ChildItem "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\"

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
Get-Module 08*
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
Get-Info -ComputerName localhost




# Module Patterns:

#> Single file per function, build to single output
code C:\ldx\TFVC

#> Development psm1
    Write-Verbose "Importing Functions"

    # Import everything in these folders
    foreach($folder in @('private', 'public', 'classes', 'imports'))
    {
        $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
        if(Test-Path -Path $root)
        {
            Write-Verbose "processing folder $root"
            $fileList = Get-ChildItem -Path $root -Filter *.ps1 |
                where-Object{ $_.name -NotLike '*.Tests.ps1'}

            # dot source each file
            foreach($file in $fileList)
            {
                Write-Verbose -Message $file.basename
                . $file.FullName
            }
        }
    }

# Build Script
    $path = '.\output\module.psm1'
    Set-Content -Path $path -Value ''

    foreach($folder in @('private', 'public', 'classes', 'imports'))
    {
        $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
        if(Test-Path -Path $root)
        {
            Write-Verbose "processing folder $root"
            $files = Get-ChildItem -Path $root -Filter *.ps1 |
                where-Object{ $_.name -NotLike '*.Tests.ps1'}

            # add to psm1 file
            $files | ForEach-Object{
                Write-Verbose $_.name;
                Get-Content -Path $_.FullName |
                    Add-Content -Path $path
            }
        }
    }


#> public vs private functions
code C:\ldx\LDXSet




# library module pattern
#> requires TFVC.libraries
code C:\ldx\TFVC
#> imports with RequiredAssemblies
code C:\ldx\TFVC.libraries



# Binary modules
mkdir .\09_info
Push-Location .\09_info
dotnet new --install Microsoft.PowerShell.Standard.Module.Template --nuget-source https://api.nuget.org/v3/index.json
dotnet new psmodule --nuget-source https://api.nuget.org/v3/index.json
dotnet restore --source https://api.nuget.org/v3/index.json
dotnet build

Import-Module .\bin\Debug\netstandard2.0\_09_info.dll

Get-Module _09_info
code .\TestSampleCmdletCommand.cs

Test-SampleCmdlet -FavoriteNumber 6 -FavoritePet dog

Pop-Location

# hybrid module pattern
#> uses root module and nested module
code C:\workspace\DependsOn




# Publish to PSGallery
$Path = '\\Server\Share\MyRepository'
$Path = 'c:\temp\MyRepository'
mkdir $path

Import-Module PowerShellGet

$repo = @{
    Name = 'MyRepository'
    SourceLocation = $Path
    PublishLocation = $Path
    InstallationPolicy = 'Trusted'
}
Register-PSRepository @repo

Get-PSRepository

Publish-Module -Name 06_info -Repository MyRepository -Verbose
Publish-Module -Name DependsOn -Repository MyRepository -RequiredVersion 1.0.2.1

Find-Module DependsOn -Repository MyRepository

Install-Module -Name DependsOn -Repository MyRepository -Scope CurrentUser



# Tips and Tricks


# Dealing with classes
#> Reload sessions every import
#>   re-import does not refresh classes
#> Load classes in order
#>   May have to build classes then import them (for dev import)
#> Use Pester's inModule Scope for testing

# Binary modules
#> Reload session every build
#>   dll's get locked after loading
#>   One dll loaded per session



#> Global Module Scope
$Script:variable


#> Create a PSModuleRoot variable
$Script:PSModuleRoot = $PSScriptRoot



#> create a .\data or .\resources folder
Get-Content -Path "$Script:PSModuleRoot\data\info.json"



#> Save psd1 file as UTF8 (for git)
$data = Get-Content -path $path
$data | Set-Content -Path -Encoding UTF8




#> Create "connections" to reduce common parameters
code C:\ldx\LDXGet\LDXGet\public\Get-ESConnection.ps1
code C:\ldx\LDXGet




#> Plaster templates https://github.com/KevinMarquette/PlasterTemplates
mkdir 10_info
Invoke-Plaster -TemplatePath C:\workspace\PlasterTemplates\FullModuleTemplate -DestinationPath 10_info
Push-Location .\10_info
tree
Pop-Location



#> Module Common Files https://github.com/loanDepot/ModuleCommonFiles
code C:\ldx\ModuleCommonFiles
Invoke-Git 'remote -v' -Path C:\ldx\LDTestFramework

