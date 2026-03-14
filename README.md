# TODO

## Sat Mar 14 08:40:13 AM MDT 2026

There is an issue with linux ubuntu builds.
You have to run builds one by one. All builds cannot run at the same time. It seems the builds create the same box file.
Troubleshoot this and fix this. For now, you can run builds separately.

```bash
packer build -force -timestamp-ui -on-error=ask --only ubuntu-desktop.qemu.linux-ubuntu -var-file=variables.auto.pkrvars.hcl .
packer build -force -timestamp-ui -on-error=ask --only ubuntu-server.qemu.linux-ubuntu -var-file=variables.auto.pkrvars.hcl .
```

---

## Wed Jun  4 07:03:13 AM MDT 2025

2025-06-04T08:19:33-06:00: Build 'windows-desktop-enterprise.qemu.windows-desktop-enterprise' finished after 32 minutes 14 seconds.

```bash
chmod 0600 vagrant-key

# Inspect
packer inspect -var-file=variables.auto.pkrvars.hcl .

# Validate
packer validate -var-file=variables.auto.pkrvars.hcl .

# Build
packer build -force -timestamp-ui -on-error=ask -var-file=variables.auto.pkrvars.hcl .

# Debug Build
PACKER_LOG=1 packer build -force -timestamp-ui -on-error=ask -var-file=variables.auto.pkrvars.hcl .
PACKER_LOG=1 packer build -force -timestamp-ui -on-error=ask --only windows-desktop-enterprise.qemu.windows-desktop-enterprise -var-file=variables.auto.pkrvars.hcl .

# Remove old vagrant box
vagrant box remove zer0ttl/windows-10-enterprise

# Generate box metadata json
./box-metadata.sh packer_windows-desktop-10-22H2-enterprise_libvirt_amd64.box 

# Add vagrant box
vagrant box add "metadata-windows-10-enterprise.json"
```

The vmware repo has the following in their ansible code:
```yaml
ansible_os_installation_type != "Server Core"
```

Values for `ansible_os_installation_type` are:
- `Client` : Windows 10 Desktop

Ansible variables (`ansible_facts`) that can be used. These are from Microsoft Windows 10 Enterprise Desktop build.
- `ansible_os_family`: `Windows`
- `ansible_system`: `Win32NT`
- `ansible_windows_domain_role`: `Stand-alone workstation`
- `ansible_os_name`: `Microsoft Windows 10 Enterprise Evaluation`
- `ansible_distribution`: `Microsoft Windows 10 Enterprise Evaluation`
- `ansible_distribution_version`: `10.0.19045.0`
- `ansible_os_product_type`: `workstation`
- `ansible_windows_domain_member`: false
- `ansible_os_installation_type`: `Client`
- `ansible_kernel`: `10.0.19045.0`
- `ansible_windows_domain`: `WORKGROUP`

## Changes Made

- File: `variables.pkr.hcl`

```text
variable "communicator_clear_authorized_keys" {
  type        = bool
  description = "Packer will attempt to remove its temporary key from ~/.ssh/authorized_keys and /root/.ssh/authorized_keys"
}

variable "communicator_read_write_timeout" {
  type        = string
  description = "The amount of time to wait for a remote command to end. This is useful when packer hangs on a connection after a reboot."
}

variable "ansible_use_proxy" {
  type        = bool
  description = "Enable or disable setting up a localhost proxy adapter"
}

variable "ansible_galaxy_force_with_deps" {
  type        = bool
  description = "Force overwriting an existing role and its dependencies. Adds --force-with-deps option to ansible-galaxy command."
}
```

- File: `builds.pkr.hcl`

```hcl
locals {
ansible_path = "${abspath(path.root)}/../../../../ansible"
}

source "qemu" "windows-desktop-enterprise" {
  ssh_clear_authorized_keys = var.communicator_clear_authorized_keys
  ssh_read_write_timeout    = var.communicator_read_write_timeout

  # Comment the next two lines after testing
  vnc_port_max              = 5959
  vnc_port_min              = 5959
}

build {
  provisioner "ansible" {
      user                    = var.build_username
      use_proxy               = var.ansible_use_proxy
      galaxy_file             = "${local.ansible_path}/windows-requirements.yml"
      galaxy_force_with_deps  = var.ansible_galaxy_force_with_deps
      playbook_file           = "${local.ansible_path}/windows-playbook.yml"
      roles_path              = "${local.ansible_path}/roles"
      ansible_env_vars        = [
                                  "ANSIBLE_CONFIG=${local.ansible_path}/ansible.cfg"
                                ]
      ansible_ssh_extra_args  = ["'-o ControlMaster=no -o ControlPersist=60s -o IdentitiesOnly=yes -o ServerAliveInterval=30 -o TCPKeepAlive=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"]
      extra_arguments         = [
                                  "--extra-vars", "ansible_connection='${var.vm_communicator}'",
                                  "--extra-vars", "ansible_shell_type='powershell'",
                                  "--extra-vars", "ansible_shell_executable='none'",
                                  "--extra-vars", "ansible_ssh_private_key_file=${abspath(path.root)}/${var.communicator_key_file}",
                                  "--extra-vars", "ansible_user='${var.build_username}'",
                                  "--extra-vars", "build_username='${var.build_username}'",
                                  "-vvvv"
                                ]
  }
}
```

- File: `variables.auto.pkvars.hcl`

```hcl
vm_communicator                     = "ssh" // change this to winrm if you want to switch communicator
communicator_clear_authorized_keys  = true
communicator_read_write_timeout     = "60s"

// Provisioner: ansible settings
ansible_use_proxy                   = false
ansible_galaxy_force_with_deps      = true
```





---

# RESUME HERE

- #todo Add windows 10 boxes
- #todo Add windows 2019 boxes
- #todo Add windows 2025 boxes
- #todo
- [x] make ansible roles for spice-agent.sh | DONE
- [x] make ansible roles for qemu-agent.sh | DONE
- [x] make ansible roles for network.sh | DONE
- [x] make ansible roles for updates.sh | DONE
- [x] make ansible roles for fixes.sh
- [x] make ansible roles for desktop.sh
- [x] make ansible roles for setup-vagrant.sh NOT REQUIRED | DONE

- hosts.yml
```yaml
ubuntu_servers:
  hosts:
    demo_us999:
      ansible_host: 192.168.13.216
  vars:
    ansible_user: vagrant
    ansible_ssh_private_key_file: vagrant-key
```
- ansible.cfg
```ini
[defaults]
display_skipped_hosts = false
host_key_checking = false
timeout = 60

[ssh_connection]
ssh_args = -o UserKnownHostsFile=/dev/null
```

```bash
chmod 0600 vagrant-key
```

- Sort this:

```bash
packer inspect -var-file=windows.pkrvars.hcl .
packer validate -var-file=windows.pkrvars.hcl .
packer build -force -timestamp-ui -on-error=ask --only windows-server-standard-desktop.qemu.windows-server-standard-desktop -var-file=windows.pkrvars.hcl .
```

```bash
PACKER_LOG=1 packer build -force -timestamp-ui -on-error=ask --only qemu.windows-server-standard-core -var-file=windows.pkrvars.hcl .

PACKER_LOG=1 packer build -timestamp-ui -on-error=ask -var-file=parrotos.pkrvars.hcl .
packer build -timestamp-ui -on-error=ask -var-file=parrotos.pkrvars.hcl .

packer inspect -var-file=windows-server.pkvars.hcl .
packer validate -var-file=windows-server.pkvars.hcl .

packer build -force -on-error=ask --only qemu.windows-server-standard-desktop -var-file=windows-server.pkvars.hcl .
packer build -force -on-error=ask --only windows-server-datacenter-desktop.* -var-file=windows-server.pkvars.hcl .
```

# do not use -var-file=variable.pkr.hcl
# that is the variable declaration file
# that file is automatically included by packer when doing `packer build`


# RESUME HERE

Adapt your autounattend.xml for vmware examples

windows iso is d drive
packer iso is e drive
virtio drivers iso is f drive

so this is the order of drives:
a:\ is the floppy
c:\ is the installation
d:\ is windows iso
e:\
    when using floppy, this is virtio drivers iso
    when using cd, this is the packer created iso
f:\
    when using cd, this is the virtio drivers iso

```hcl
provisioner "ansible" {
    user = var.build_username
    use_proxy = false
    playbook_file = "${abspath(path.root)}/../../ansible/windows-playbook.yml"
    roles_path = "${abspath(path.root)}/../../ansible/roles"
    ansible_env_vars = [
    "ANSIBLE_CONFIG=${abspath(path.root)}/../../ansible/ansible.cfg"
    ]
    extra_arguments = [
    "--extra-vars", "use_proxy=false",
    "--extra-vars", "ansible_ssh_private_key_file=${abspath(path.root)}/${var.communicator_key_file}",
    "--extra-vars", "ansible_connection=ssh",
    "--extra-vars", "ansible_shell_type=cmd",
    "--extra-vars", "ansible_user='${var.build_username}'",
    "-vvvv",
    ]
}

build {
  sources = [
      "source.qemu.windows-server-standard-core",
      "source.qemu.windows-server-standard-desktop",
      "source.qemu.windows-server-datacenter-core",
      "source.qemu.windows-server-datacenter-desktop"
  ]

  provisioner "powershell" {
    elevated_user        = "${var.build_username}"
    elevated_password    = "${var.build_password}"
    scripts = [
      "${local.scripts_path}/qemu-agent.ps1",
      "${local.scripts_path}/post-setup.ps1"
    ]
    only                 = ["qemu.windows-server-standard-core", "qemu.windows-server-datacenter-core"]
  }

  provisioner "powershell" {
    elevated_user        = "${var.build_username}"
    elevated_password    = "${var.build_password}"
    scripts = [
      "${local.scripts_path}/qemu-agent.ps1",
      "${local.scripts_path}/spice-tools.ps1",
      "${local.scripts_path}/post-setup.ps1"
    ]
    only                 = ["qemu.windows-server-standard-desktop", "qemu.windows-server-datacenter-desktop"]
  }

  post-processor "vagrant" {
      compression_level    = 9
      output               = "packer_${local.vm_name_standard_core}_{{.Provider}}_{{.Architecture}}.box"
      only                 = ["qemu.windows-server-standard-core"]
  }

  post-processor "vagrant" {
      compression_level    = 9
      output               = "packer_${local.vm_name_datacenter_core}_{{.Provider}}_{{.Architecture}}.box"
      only                 = ["qemu.windows-server-standard-desktop"]
  }

  post-processor "vagrant" {
      compression_level    = 9
      output               = "packer_${local.vm_name_datacenter_core}_{{.Provider}}_{{.Architecture}}.box"
      only                 = ["qemu.windows-server-datacenter-core"]
  }

  post-processor "vagrant" {
      compression_level    = 9
      output               = "packer_${local.vm_name_datacenter_desktop}_{{.Provider}}_{{.Architecture}}.box"
      only                 = ["qemu.windows-server-datacenter-desktop"]
  }
}
```

---

# packer-templates

This repo contains code to build Vagrant box images for VirtualBox provider using Packer.

Vagrant boxes built with these packer templates are available at: https://app.vagrantup.com/zer0ttl/

## Prerequisites

* Packer - www.packer.io
* Vagrant - www.vagrantup.com
* Virtualbox - https://www.virtualbox.org

## Usage

`git clone https://github.com/zer0ttl/packer-templates.git`

```bash
cd parrot-os
packer build -var-file=variables.pkvars.hcl parrotos.pkr.hcl
```

This will output a `parrotos-5.3-Electro-Ara-x64-virtualbox.box` file in your current directory.

Add this box to Vagrant using the following:

```bash
vagrant box add --name parrot-5.3 parrotos-5.3-Electro-Ara-x64-virtualbox.box
```

Create a new Vagrant file using `touch Vagrantfile` or `vagrant init parrotos-5.3`.

You can then use the newly added box to spin up a vm with VirtualBox using `vagrant up`.

## Vagrantfiles

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "parrotos-5.3"
  config.vm.guest = "debian"
end
```

## Changelog

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D


