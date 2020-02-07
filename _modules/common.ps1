<#
.Filename or Function name 
    common.ps1
.Author(s)
    Marcus Adams
.Version
    0.0.1
.Synopsis
    Series of useful functions for use by other powershell scripts 
.Description
    use by dot refrencing eg ". .\scripts\windows\functions\common.ps1"
.Function LogWrite
    writes to both screen and log
.Example
    LogWrite {message}
.Function AddToEnviromentVariable
    Creates/updates an enviroment variable
    If the EnviromentType parameter is left off it defults to machine.
.Example
    AddToEnviromentVariable {EnvironmentVariableToModify, ValueToAdd, EnvironmentType}
.Function DownloadFromGit
    Download a repo without needing to install git and register private keys
.Example
    DownloadFromGit organization, repo name, destination, (optional) branch
.Link
    https://github.com/Marcus-James-Adams/scripts/windows/functions/
.Notes  
    Changelog:
    07/02/2020 set OAuth Token to be a passed parameter
#>
Clear-Host
function LogWrite {
  Param ([string]$logString)
  $logFile = $MyInvocation.MyCommand.Name.TrimEnd('.ps1') 
  $now = Get-Date -format s
  $logDir = "C:\log"
  $hostFQDN=[System.Net.Dns]::GetHostEntry([string]$Env:computername).HostName
  If(!(test-path $logDir))
    {
    New-Item -ItemType Directory -Force -Path $logDir
    Add-Content $Logfile -value "$now $hostFQDN WARN: $logDir missing created"
    Write-Host "$now WARN: $logDir missing created"
    }
  Add-Content "$logDir\$Logfile.log.txt" -value "$now $hostFQDN $logString"
  Write-Host $logString
}

function AddToEnviromentVariable ($EnvironmentVariableToModify, $ValueToAdd,$EnvironmentType='machine') {
  #
  #A way of quckly updating enviroment variables 
  #must pass $EnvironmentVariableToModify and $ValueToAdd but if $EnvironmentType is missed off default to machine
  #
  #EXAMPLES
  #AddToEnviromentVariable "PATH" "C:\Yeti\2018\bin;C:\Yeti\2018.5\bin;C:\Yeti\2018\bin"
  #AddToEnviromentVariable "VRAY_PLUGINS_x64" "C:\Yeti\2018\bin"
  #AddToEnviromentVariable "VRAY_FOR_MAYA2018_5_PLUGINS_x64" "C:\Yeti\2018.5\bin"
  # quick validation
  $d = Get-date -Format F
  LogWrite "INFO: AddToEnviromentVariable has been called with the following parameters"
  LogWrite "INFO: Variable to Modify: `t $EnvironmentVariableToModify"
  LogWrite "INFO: Value to Add: `t`t`t $ValueToAdd"
  LogWrite "INFO: Type of Variable: `t`t $EnvironmentType"
  If (-not $EnvironmentVariableToModify -or -not $ValueToAdd ) 
    { 
       LogWrite "ERROR: you must pass EnvironmentVariableToModify and ValueToAdd as a minimum for this function"
       throw "$d ERROR: you must pass EnvironmentVariableToModify and ValueToAdd as a minimum for this function"
       exit
     }
  If ( $EnvironmentType -Notlike 'machine' -and  $EnvironmentType -notlike 'user'-and  $EnvironmentType -notlike 'process' ) 
     { 
       LogWrite "ERROR: Enviroment Type must be one of process, user, machine.  Leave blank to default to machine"
       throw "$d ERROR: Enviroment Type must be one of process, user, machine.  Leave blank to default to machine"
       exit
     }
  $oldValue = [Environment]::GetEnvironmentVariable($EnvironmentVariableToModify,$EnvironmentType)
  LogWrite "INFO: $EnvironmentVariableToModify currently set to $oldValue `n"
  If ($oldValue) 
    {
    # the eniroment varibale allready exists so append to it
    # first make sure no hidden nsatys o break things
    $trimvalue=$oldValue.Trim()
    $cleanvlaue=$trimvalue -replace '[^\x20-\x7E]+', ''
    $newValue = $cleanvlaue+";$ValueToAdd"
    }
  Else
    {
    # the enviroment variable did not exist so create it from scratch
    $newValue = $ValueToAdd
    }
  [Environment]::SetEnvironmentVariable("$EnvironmentVariableToModify",$newValue,$EnvironmentType)
  LogWrite "INFO: $EnvironmentVariableToModify now set to $newValue `n"
}

function DownloadFromGit {
  if ($($args.count) -lt 3) {
    LogWrite  "ERROR: Usage $thisBuild arguments Organization Repo_name OAuth_Token" Destination (optional) Branch NOT supplied"
    LogWrite  "EXAMPLE: $thisBuild arguments myOrg myRepo C:\ HUE787...Kioh$ij== master
    exit 99
  }
  $GIT_organization=$($args[0])
  $GIT_repo_name=$($args[1])
  $GIT_destination=$($args[2])
  $GIT_OAUth=$($args[3])
  if ($($args.count) -lt 5) {
    $GIT_branch="master"
  } else {
    $GIT_branch=$($args[4])    
  }
  LogWrite "INFO: Organization is: $GIT_organization"
  LogWrite "INFO: Repo is: $GIT_repo_name"
  LogWrite "INFO: Destination is: $GIT_destination"
  LogWrite "INFO: Branch is: $GIT_branch"
  $http_url="https://github.com/$GIT_organization/$GIT_repo_name/archive/$GIT_branch.zip"
  LogWrite "INFO: HTTPS string is: $http_url"
  New-Item -ItemType Directory -Force -Path "$GIT_destination" -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path C:\temp -ErrorAction SilentlyContinue
  LogWrite "INFO: Downloading scripts from $GIT_branch Branch of github"
  # Download build scripts
  New-Item -ItemType Directory -Force -Path C:\temp -ErrorAction SilentlyContinue
  LogWrite "INFO: Downloading scripts from $GIT_branch Branch of github"
  #check for exsting zip or extracted folder and erase
  If((test-path c:\temp\$GIT_branch.zip ))
    {
    Remove-Item c:\temp\$GIT_branch.zip -Force 
    LogWrite "WARN: pre-exsting $GIT_branch.zip existed removing"
    }
  If((test-path c:\temp\$GIT_repo_name-$GIT_branch ))
    {
    Remove-Item c:\temp\$GIT_repo_name-$GIT_branch  -Force -Recurse
    LogWrite "WARN: pre-exsting $GIT_repo_name-$GIT_branch existed removing"
    }
  try {
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    $client = New-Object System.Net.WebClient
    $client.Headers.Add("Authorization","token $GIT_OAUth")
    $client.Headers.Add("Accept","application/vnd.github.v3.raw")
    $client.DownloadFile("https://github.com/$GIT_organization/$GIT_repo_name/archive/$GIT_branch.zip","c:\temp\$GIT_branch.zip")
    }
  catch {
    LogWrite "ERROR: Could NOT download from GITHUB"
    throw "$_.Exception ERROR: Could NOT download from GITHUB"
    #, or throw $_.Exception
    throw "ERROR: Could NOT download from GITHUB"
    }
  LogWrite "INFO: Unzipping files"
  [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
  [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\$GIT_branch.zip", 'c:\temp\')
  LogWrite "INFO: Moving BuildScripts to correcct location"
  New-Item -ItemType Directory -Force -Path $GIT_destination -ErrorAction SilentlyContinue
  Copy-Item "C:\temp\$GIT_repo_name-$GIT_branch\*" "$GIT_destination" -Recurse -Force -Verbose
}