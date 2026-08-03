:: Remove the temporary Packer identity and all shared bootstrap keys.
net user packer /active:no
net user packer /delete
net user Administrator /active:no
del /f /q C:\Users\packer\.ssh\authorized_keys 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /f 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /f 2>NUL

:: Restore the host security boundary after image preparation.
netsh advfirewall set allprofiles state on
netsh advfirewall firewall set rule name="OpenSSH SSH Server (sshd)" new action=allow
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=block
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f

:: Remove the unencrypted WinRM listener; Cloudbase-Init creates HTTPS on first boot.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $false"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem WSMan:\localhost\Listener | Where-Object { $_.Keys -match 'Transport=HTTP' } | Remove-Item -Recurse -Force"

:: slmgr.vbs will run silently to rearm the 90 days evaluation period
%windir%\System32\wscript.exe /b "%windir%\System32\slmgr.vbs" /rearm
