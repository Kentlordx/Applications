Clear-Host
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)

$MyConfigFileloc = ("$env:Settings\Applications\Settings.xml")
[xml]$MyConfigFile = (Get-Content $MyConfigFileLoc)

$PackageName = "Import Certificate VCS"
$LogPS = "${env:SystemRoot}" + "\Temp\$PackageName PS Wrapper.log"

$Certificates = $MyConfigFile.Settings.Microsoft.Certificates

copy-item "$Certificates\Wildcard.pfx" -Destination C:\Windows\Temp\wildcard.pfx 
copy-item "$Certificates\Wildcard.txt" -Destination C:\Windows\Temp\wildcard.txt
 
$PFXPath="C:\Windows\Temp\wildcard.pfx"
$PFXPassword="poshacme"
$strThumb = Get-Content C:\Windows\Temp\wildcard.txt

certutil -f -importpfx -p $PFXPassword $PFXPath

Remove-Item C:\Windows\Temp\wildcard.* -Force

$cert = Get-ChildItem -Path Cert:\LocalMachine\My | where{ $_.Subject –like "CN=$env:computername*" }
$Thumbprint = $cert.Thumbprint
(Get-ChildItem -Path Cert:\LocalMachine\My\$Thumbprint).FriendlyName = 'old vdm'
 
(Get-ChildItem -Path Cert:\LocalMachine\My\$strThumb).FriendlyName = 'vdm'

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript
