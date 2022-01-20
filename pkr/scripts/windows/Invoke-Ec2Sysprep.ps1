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