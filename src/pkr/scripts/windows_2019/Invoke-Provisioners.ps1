function Install-Chocolatey
{
    [CmdletBinding()]
    param()

    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    refreshenv
}

function Install-ChocolateyPackage
{
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Chocolatey package name"
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    $Command = "choco install $($Name) -y"

    Invoke-Expression -Command $Command
}

function Invoke-PostBuild
{
    [CmdletBinding()]
    param()

    if ( Test-Path -Path  "C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\SendWindowsIsReady.ps1" )
    {
        Set-Location "C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts"
        .\SendWindowsIsReady.ps1 -Schedule
        .\InitializeInstance.ps1 -Schedule
        .\SysprepInstance.ps1 -NoShutdown
    }

    elseif ( Test-Path -Path "$ENV:ProgramFiles/Amazon/EC2Launch/EC2Launch.exe" )
    {
        $ec2LaunchExe = "$ENV:ProgramFiles/Amazon/EC2Launch/EC2Launch.exe"
        & $ec2LaunchExe sysprep
    }

    else
    {
        Write-Output "Amazon launch config not found"
    }
}

Write-Output "Installing chocolatey"
Install-Chocolatey -Verbose

Write-Output "Installing aws-cli-session-manager"
Install-ChocolateyPackage -Name "awscli-session-manager" -Verbose

Write-Output "Executing sysprep"
Invoke-PostBuild

