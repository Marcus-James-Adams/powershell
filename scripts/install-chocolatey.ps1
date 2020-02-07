<#
.Filename or Function name 
    install-chocolatey.ps1
.Author(s)
    Marcus James Adams
.Version
    1.0.0
.Synopsis
    Installs choclately package manager.
.Description
    requires reboot after.
.Parameter param1 
    describe param1
.Parameter param2
    describe param2
.Example
    Give sample usage of your script
.Link
    https://github.com/Marcus-James-Adams/powershell/
.Notes  
    Changelog:
    * 
#>
# ------------------------------------------------------
# Do not alter this section
clear-host
Set-ExecutionPolicy -Scope CurrentUser Unrestricted -Force
# Remeber to check dir path for module
Import-Module $PSScriptRoot\..\_modules\common.ps1
LogWrite "----------------------------------------------------------------------------------------------------------------------------"
LogWrite "INFO: Starting $($MyInvocation.MyCommand.Path)"
LogWrite "----------------------------------------------------------------------------------------------------------------------------"
# ------------------------------------------------------
<# BEGIN CODE BELOW #>
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Start-Sleep -s 30