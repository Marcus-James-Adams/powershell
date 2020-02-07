<#
.Filename or Function name 
    format-terraform.ps1
.Author(s)
    Marcus James Adams
.Version
    1.5
.Description
    Scans a given folder for terrform files, if found runs terraform fmt to tidy them up.
    Then creates a readme.md for the folder optionally including a content section if content.md exists.
    Finally pushes to git.
.Pre-requisits 
    requires the following to be installed:
    * Terraform - https://www.terraform.io/downloads.html
    * Terraform-docs - https://github.com/segmentio/terraform-docs
    * Git - https://git-scm.com/download/win
.Link
    https://github.com/Marcus-James-Adams/powershell/scripts/format-terraform.ps1
.Notes  
    You can add several informations here
    Changelog:
    * 07/02/2020 - update description
#>
 $Path = 'C:\terraform\'
# 
Get-ChildItem -Path $Path -Recurse -Directory   | 
    ForEach-Object{
    $tffolder=$_.FullName
    write-host $tffolder
    #sleep 5
        if (Test-Path "$tffolder\*.tf" ) {
            cd $tffolder
            write-host "checking $tffolder"
            terraform fmt
            if (-not(Test-Path "$tffolder\header.md")) { 
                write-host "Creating basic header.md"
                Set-Content -Path "$tffolder\header.md" -Value "[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D0.12.0-blue.svg)](https://www.terraform.io/docs/configuration/index.html)"
                Add-Content -Path "$tffolder\header.md" -Value "[![License MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)"
                Add-Content -Path "$tffolder\header.md" -Value "[![Cloud provider Azure](https://img.shields.io/badge/Cloud%20Provider-Azure-0078D7)](https://portal.azure.com/)"
                Add-Content -Path "$tffolder\header.md" -Value "[![Azure TF provider](https://img.shields.io/badge/Azure%20TF-%3E1.35.0-blue.svg)](https://www.terraform.io/docs/configuration/index.html)"
                Add-Content -Path "$tffolder\header.md" -Value ""
                Add-Content -Path "$tffolder\header.md" -Value "# $_  terraform" 
                                }
             terraform-docs markdown table . >docs.md
             Get-Content -Path "$tffolder\header.md" | Set-Content -Path .\README.MD
             if (Test-Path "$tffolder\content.md") { 
                Get-Content -Path "$tffolder\content.md" | Add-Content -Path .\README.MD
                }
             Get-Content -Path "$tffolder\docs.md" | Add-Content -Path .\README.MD
             remove-item -Path "$tffolder\docs.md" -force
             remove-item -Path "$tffolder\header.md" -force
             git add .
             git commit -m "lint and update README.MD"
             git push
 
        }
    }
cd $Path

