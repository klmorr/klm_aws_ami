<#
    .SYNOPSIS
        Bootstap EC2Instance

    .DESCRIPTION
        Boot straps ec2 instance utilizing user data file

        Configures WinRm over HTTPS using the existing RDP certificate

        Creates WinRM over HTTPS firewall rule

    .NOTES
        version: 1.0.0
        author: kmo

#>
<powershell>
Write-Host "Disabling WinRM over HTTP..."

Disable-NetFirewallRule -Name "WINRM-HTTP-In-TCP"
Disable-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC"

Remove-Item -Path "WSMan:\config\listener\*" -Recurse

Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-WSManQuickConfig -SkipNetworkProfileCheck -Force

Set-WSManInstance -ResourceURI "winrm/config" -ValueSet @{MaxTimeoutms = 18000 }

Set-WSManInstance -ResourceURI "winrm/config/winrs" -ValueSet @{MaxMemoryPerShellMB = 1024 }

Set-WSManInstance -ResourceURI "winrm/config/service" @{AllowUnencrypted = "False" }

Set-WSManInstance -ResourceURI "winrm/config/service/auth" -ValueSet @{Basic = "true" }

Restart-Service -Name WinRM

$wsmanHttpsArgs = @{
    Name        = "WINRM-HTTPS-In-TCP"
    DisplayName = "Windows Remote Management (HTTPS-In)"
    Description = "Inbound rule for Windows Remote Management via WS-Management(TCP 5986)"
    Group       = "Windows Remote Management"
    Program     = "System"
    Protocol    = "TCP"
    LocalPort   = "5986" 
    Action      = "Allow"
    Profile     = "Any"
}

New-NetFirewallRule @wsmanHttpsArgs

Write-Host "Finding the Remote Desktop Certificate"
$SourceStoreScope = 'LocalMachine'
$SourceStorename = 'Remote Desktop'
$SourceStore = New-Object  -TypeName System.Security.Cryptography.X509Certificates.X509Store  -ArgumentList $SourceStorename, $SourceStoreScope
$SourceStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)
$cert = $SourceStore.Certificates | Where-Object  -FilterScript {
    $_.subject -like '*'
}

Write-Host "Binding RDP Certificate to WinRM HTTPS Listener"
$DestStoreScope = 'LocalMachine'
$DestStoreName = 'My'
$DestStore = New-Object  -TypeName System.Security.Cryptography.X509Certificates.X509Store  -ArgumentList $DestStoreName, $DestStoreScope
$DestStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$DestStore.Add($cert)

$SourceStore.Close()
$DestStore.Close()
winrm create winrm/config/listener?Address=*+Transport=HTTPS  `@`{Hostname=`"($certId)`"`;CertificateThumbprint=`"($cert.Thumbprint)`"`}

Write-Host "Restarting WinRM Service..."


Write-Host "Enabling remote execution of PowerShell scripts"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

Write-Host "Installing Chocolatey"
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

</powershell>