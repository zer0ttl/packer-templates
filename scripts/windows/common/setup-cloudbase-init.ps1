<#
    Install and configure Cloudbase-Init for first-boot Windows customization.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$installRoot = 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init'
$downloadRoot = 'C:\Windows\Temp\cloudbase-init'
$installer = Join-Path $downloadRoot 'CloudbaseInitSetup_Stable_x64.msi'
$installerUrl = 'https://www.cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi'

New-Item -Path $downloadRoot -ItemType Directory -Force | Out-Null
Invoke-WebRequest -Uri $installerUrl -OutFile $installer -UseBasicParsing

$signature = Get-AuthenticodeSignature -FilePath $installer
if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notmatch 'Cloudbase') {
    throw 'Cloudbase-Init installer signature validation failed'
}

Start-Process msiexec.exe -Wait -NoNewWindow -ArgumentList @(
    '/i', $installer,
    '/qn',
    '/norestart',
    'RUNSERVICEASLOCALSYSTEM=1',
    'USERNAME=Administrator',
    'USERGROUPS=Administrators',
    'INJECTMETADATAPASSWORD=0'
)

$installRoot = 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init'
$confRoot = Join-Path $installRoot 'conf'
New-Item -Path $confRoot -ItemType Directory -Force | Out-Null

$common = @'
[DEFAULT]
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
metadata_services=cloudbaseinit.metadata.services.nocloudservice.NoCloudConfigDriveService,cloudbaseinit.metadata.services.configdrive.ConfigDriveService,cloudbaseinit.metadata.services.httpservice.HttpService,cloudbaseinit.metadata.services.ec2service.EC2Service
plugins=cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,cloudbaseinit.plugins.common.userdata.UserDataPlugin,cloudbaseinit.plugins.common.localscripts.LocalScriptsPlugin,cloudbaseinit.plugins.windows.winrmlistener.ConfigWinRMListenerPlugin
username=
groups=Administrators
inject_user_password=false
first_logon_behaviour=no
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts
logdir=C:\ProgramData\Cloudbase-Init\log
verbose=false
debug=false
winrm_configure_http_listener=false
winrm_configure_https_listener=true
winrm_enable_basic_auth=true
stop_service_on_exit=false
'@

$unattend = @"
$common
logfile=cloudbase-init-unattend.log
"@
$normal = @"
$common
logfile=cloudbase-init.log
"@

Set-Content -Path (Join-Path $confRoot 'cloudbase-init-unattend.conf') -Value $unattend -Encoding ascii
Set-Content -Path (Join-Path $confRoot 'cloudbase-init.conf') -Value $normal -Encoding ascii

Get-Service -Name 'cloudbase-init*' -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue
Get-Service -Name 'cloudbase-init' -ErrorAction SilentlyContinue | Set-Service -StartupType Automatic
Get-Service -Name 'cloudbase-init-unattend' -ErrorAction SilentlyContinue | Set-Service -StartupType Manual

Remove-Item -Path $downloadRoot -Recurse -Force -ErrorAction SilentlyContinue
