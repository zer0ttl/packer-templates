<#
    .DESCRIPTION
    Enables SSH on Windows builds.
#>

# Make sure that OpenSSH is available
$OpenSSHServer = $(Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*').Name
$OpenSSHClient = $(Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*').Name

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name $OpenSSHClient

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name $OpenSSHServer

# Start the SSH service
Start-Service sshd

# OPTIONAL but recommended: Automatically start SSH service
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should automatically be put in by setup. Verify anyways.
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

 # Enable both launch-time authentication modes. Cloudbase-Init installs the
 # supplied key and creates the supplied account during first boot.
((Get-Content -path C:\ProgramData\ssh\sshd_config -Raw) `
-replace '#PubkeyAuthentication yes','PubkeyAuthentication yes' `
-replace '#PasswordAuthentication yes','PasswordAuthentication yes' `
-replace 'Match Group administrators','#Match Group administrators' `
-replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys','#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config

# Restart SSH service after changes
Restart-Service sshd

# Create the .ssh directory
New-item -Path $env:USERPROFILE -Name .ssh -ItemType Directory -force

# Set the default shell for OpenSSH to powershell.exe
# Reference: https://docs.ansible.com/ansible/latest/os_guide/windows_ssh.html#default-shell-configuration
$shellParams = @{
    Path         = 'HKLM:\SOFTWARE\OpenSSH'
    Name         = 'DefaultShell'
    Value        = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    PropertyType = 'String'
    Force        = $true
}
New-ItemProperty @shellParams

# Reset the autologon count.
# Reference: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0
