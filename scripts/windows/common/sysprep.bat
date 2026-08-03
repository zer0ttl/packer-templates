:: NOTE: Both WinRM and SSH rules need to be enabled as Windows Desktop boxes use WinRM and Windows Server boxes use SSH for provisioning.
:: Disable firewall rules while Sysprep is preparing the image. SetupComplete
:: restores the required access rules before Cloudbase-Init runs.

:: Winrm
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=block

:: OpenSSH
netsh advfirewall firewall set rule name="OpenSSH SSH Server (sshd)" new action=block

@REM Run Sysprep
%WINDIR%\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:E:\unattend.xml
