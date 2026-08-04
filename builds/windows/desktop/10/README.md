## Update Fri Mar 22 09:34:52 PM UTC 2024

Disregard below.

Now all windows templates run `E:\configure-winrm.ps1` and `E:\install-openssh.ps1` during unattended setup.

All windows tempaltes use winrm as the communicator.

The `sysprep.bat` then sets the following firewall rules in *block* mode.
- Windows Remote Management (HTTP-In)
- OpenSSH SSH Server (sshd)
The `SetupComplete.cmd` then sets the same rules to *allow* mode once the box has booted.

That's all folks!


## Update: Fri Mar 22 01:43:04 PM UTC 2024

- Static IP address gets set via WinRM build.
- SSH build has an issue as Vagrant tries to execute commands via WinRM. I think WinRM needs to be enabled for SSH build.

Windows 10 build:
- Both SSH and WinRM builds have been tested to be working.
- In order to change the communicator, changes have to be made in 4 places.
    1. `autounattend.pkrtpl.hcl` line 191: Change `E:\configure-winrm.ps1` to `E:\install-openssh.ps1`
    2. `windows.pkrvars.hcl` line 15: Change `vm_communicator = "winrm"` to `vm_communicator = "ssh"`
    3. `sysprep.bat`: Comment the firewall block rule for winrm and uncomment the firewall block rule for ssh
    4. `SetupComplete.cmd`: Comment the firewall allow rule for winrm and uncomment the firewall allow rule for ssh

Following lines have to be added to Vagrantfile

```ruby
config.vm.communicator = winrm
config.winrm.username  = vagrant
config.winrm.password  = vagrant
```

### SSH

### WinRM

- Execute commands using vagrant.

```bash
vagrant winrm -c 'test-wsman'
vagrant winrm -s powershell -c 'Get-NetIPAddress -AddressFamily IPv4'



