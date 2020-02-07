<#
.Filename or Function name 
    Name of the script or function
.Author(s)
    Who crated/modified it
.Version
    Version number in semver 2.0 format
.Synopsis
    Brief description
.Description
    details of the script
.Parameter param1 
    describe param1
.Parameter param2
    describe param2
.Example
    Give sample usage of your script
.Link
    https://github.com/Marcus-James-Adams/powershell
.Notes  
    You can add several informations here
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
