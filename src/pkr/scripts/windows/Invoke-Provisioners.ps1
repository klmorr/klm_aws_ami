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

function Install-AWSPowershell
{
    [CmdletBinding()]
    param()

    if ( -Not ( Get-Module -Name AWSPowershell -ListAvailable ))
    {
        Install-Module -Name AWSPowershell -Confirm:$False -Force
    }
}

function Invoke-Ec2Sysprep
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

Install-AWSPowershell -Verbose

$chocoPackage = @(
    "python",
    "awscli",
    "googlechrome"
)

Write-Output "Installing chocolatey"

Install-Chocolatey -Verbose

foreach ( $package in $chocoPackage ) 
{
    Install-ChocolateyPackage -Name $package -Verbose
}

Invoke-Ec2Sysprep