# TODO

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


