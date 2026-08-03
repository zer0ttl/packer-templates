/*

  Build definition for different versions of Windows Server 2022.
*/

packer {
  required_version = ">= 1.10.0"
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

locals {
  vm_name_datacenter_core    = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_datacenter}-${var.vm_guest_os_experience_core}"
  vm_name_datacenter_desktop = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_datacenter}-${var.vm_guest_os_experience_desktop}"
  vm_name_standard_core      = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_standard}-${var.vm_guest_os_experience_core}"
  vm_name_standard_desktop   = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_standard}-${var.vm_guest_os_experience_desktop}"
  ansible_path = "${abspath(path.root)}/../../../../ansible"
  scripts_path               = "${abspath(path.root)}/../../../../scripts/${var.vm_guest_os_family}/common"
  vm_cd_files_core           = [
                                "${local.scripts_path}/setup-openssh.ps1",
                                "${local.scripts_path}/setup-winrm.ps1",
                                "${local.scripts_path}/setup-cloudbase-init.ps1",
                                "${local.scripts_path}/qemu-agent.ps1",
                                "${local.scripts_path}/power.ps1",
                                "${local.scripts_path}/common-fixes.ps1",
                                "${local.scripts_path}/post-setup.ps1",
                                "${local.scripts_path}/SetupComplete.cmd",
                                "${local.scripts_path}/sysprep.bat"
                              ]
  vm_cd_files_desktop        = concat(local.vm_cd_files_core, [
                                "${local.scripts_path}/spice-tools.ps1",
                                "${local.scripts_path}/bginfo.ps1",
                                "${local.scripts_path}/bginfo.bgi"
                              ])
  vm_provision_files_core    = [
                                "${local.scripts_path}/qemu-agent.ps1",
                                "${local.scripts_path}/power.ps1",
                                "${local.scripts_path}/common-fixes.ps1",
                                "${local.scripts_path}/post-setup.ps1"
                                ]
  vm_provision_files_desktop = concat(local.vm_provision_files_core, [
                                "${local.scripts_path}/spice-tools.ps1",
                                "${local.scripts_path}/bginfo.ps1"
                                ])
}

source "qemu" "windows-server-standard-core" {
  accelerator               = var.vm_accelerator
  boot_wait                 = var.vm_boot_wait
  communicator              = var.vm_communicator
  cpus                      = var.vm_cpu_count
  disk_interface            = var.vm_disk_interface
  disk_size                 = var.vm_disk_size
  cd_files                  = local.vm_cd_files_core
  cd_content                = {
                                "Autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_orgname        = var.build_orgname
                                    vm_inst_os_language  = var.vm_inst_os_language
                                    vm_inst_os_keyboard  = var.vm_inst_os_keyboard
                                    vm_inst_os_image     = var.vm_inst_os_image_standard_core
                                    vm_guest_os_language = var.vm_guest_os_language
                                    vm_guest_os_keyboard = var.vm_guest_os_keyboard
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                }),
                                "unattend.xml" = templatefile("${abspath(path.root)}/data/unattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_vmname         = var.build_vmname
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                })
                            }
  format                    = var.vm_image_format
  headless                  = var.vm_headless
  iso_checksum              = var.iso_checksum
  iso_urls                  = var.iso_urls
  net_device                = var.vm_net_device
  qemuargs                  = [
                               ["-cdrom", "${var.iso_virtio_windows}"]
                            ]
  memory                    = var.vm_mem_size
  shutdown_command          = var.vm_shutdown_command
  shutdown_timeout          = var.common_shutdown_timeout
  ssh_username              = var.build_username
  temporary_key_pair_type   = "ed25519"
  ssh_timeout               = var.communicator_timeout
  vnc_bind_address          = var.vnc_bind_address
}

source "qemu" "windows-server-standard-desktop" {
  accelerator               = var.vm_accelerator
  boot_wait                 = var.vm_boot_wait
  communicator              = var.vm_communicator
  cpus                      = var.vm_cpu_count
  disk_interface            = var.vm_disk_interface
  disk_size                 = var.vm_disk_size
  cd_files                  = local.vm_cd_files_desktop
  cd_content                = {
                                "Autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_orgname        = var.build_orgname
                                    vm_inst_os_language  = var.vm_inst_os_language
                                    vm_inst_os_keyboard  = var.vm_inst_os_keyboard
                                    vm_inst_os_image     = var.vm_inst_os_image_standard_desktop
                                    vm_guest_os_language = var.vm_guest_os_language
                                    vm_guest_os_keyboard = var.vm_guest_os_keyboard
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                }),
                                "unattend.xml" = templatefile("${abspath(path.root)}/data/unattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_vmname         = var.build_vmname
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                })
                            }
  format                    = var.vm_image_format
  headless                  = var.vm_headless
  iso_checksum              = var.iso_checksum
  iso_urls                  = var.iso_urls
  net_device                = var.vm_net_device
  qemuargs                  = [
                                 ["-cdrom", "${var.iso_virtio_windows}"]
                              ]
  memory                    = var.vm_mem_size
  shutdown_command          = var.vm_shutdown_command
  shutdown_timeout          = var.common_shutdown_timeout
  ssh_username              = var.build_username
  temporary_key_pair_type   = "ed25519"
  ssh_timeout               = var.communicator_timeout
  vnc_bind_address          = var.vnc_bind_address
  # Comment the next two lines after testing
  vnc_port_max              = 5959
  vnc_port_min              = 5959
}

source "qemu" "windows-server-datacenter-core" {
  accelerator               = var.vm_accelerator
  boot_wait                 = var.vm_boot_wait
  communicator              = var.vm_communicator
  cpus                      = var.vm_cpu_count
  disk_interface            = var.vm_disk_interface
  disk_size                 = var.vm_disk_size
  cd_files                  = local.vm_cd_files_core
  cd_content                = {
                                "Autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_orgname        = var.build_orgname
                                    vm_inst_os_language  = var.vm_inst_os_language
                                    vm_inst_os_keyboard  = var.vm_inst_os_keyboard
                                    vm_inst_os_image     = var.vm_inst_os_image_datacenter_core
                                    vm_guest_os_language = var.vm_guest_os_language
                                    vm_guest_os_keyboard = var.vm_guest_os_keyboard
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                }),
                                "unattend.xml" = templatefile("${abspath(path.root)}/data/unattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_vmname         = var.build_vmname
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                })
                            }
  format                    = var.vm_image_format
  headless                  = var.vm_headless
  iso_checksum              = var.iso_checksum
  iso_urls                  = var.iso_urls
  net_device                = var.vm_net_device
  qemuargs                  = [
                               ["-cdrom", "${var.iso_virtio_windows}"]
                            ]
  memory                    = var.vm_mem_size
  shutdown_command          = var.vm_shutdown_command
  shutdown_timeout          = var.common_shutdown_timeout
  ssh_username              = var.build_username
  temporary_key_pair_type   = "ed25519"
  ssh_timeout               = var.communicator_timeout
  vnc_bind_address          = var.vnc_bind_address
}

source "qemu" "windows-server-datacenter-desktop" {
  accelerator               = var.vm_accelerator
  boot_wait                 = var.vm_boot_wait
  communicator              = var.vm_communicator
  cpus                      = var.vm_cpu_count
  disk_interface            = var.vm_disk_interface
  disk_size                 = var.vm_disk_size
  cd_files                  = local.vm_cd_files_desktop
  cd_content                = {
                                "Autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_orgname        = var.build_orgname
                                    vm_inst_os_language  = var.vm_inst_os_language
                                    vm_inst_os_keyboard  = var.vm_inst_os_keyboard
                                    vm_inst_os_image     = var.vm_inst_os_image_datacenter_desktop
                                    vm_guest_os_language = var.vm_guest_os_language
                                    vm_guest_os_keyboard = var.vm_guest_os_keyboard
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                }),
                                "unattend.xml" = templatefile("${abspath(path.root)}/data/unattend.pkrtpl.hcl", {
                                    build_username       = var.build_username
                                    build_password       = var.build_password
                                    build_vmname         = var.build_vmname
                                    vm_guest_os_timezone = var.vm_guest_os_timezone
                                })
                            }
  format                    = var.vm_image_format
  headless                  = var.vm_headless
  iso_checksum              = var.iso_checksum
  iso_urls                  = var.iso_urls
  net_device                = var.vm_net_device
  qemuargs                  = [
                                 ["-cdrom", "${var.iso_virtio_windows}"]
                              ]
  memory                    = var.vm_mem_size
  shutdown_command          = var.vm_shutdown_command
  shutdown_timeout          = var.common_shutdown_timeout
  ssh_username              = var.build_username
  temporary_key_pair_type   = "ed25519"
  ssh_timeout               = var.communicator_timeout
  vnc_bind_address          = var.vnc_bind_address
}

# windows-server-standard-core
build {
  name = "windows-server-standard-core"

  sources = [
      "qemu.windows-server-standard-core"
  ]

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
      extra_arguments         = [
                                  "--extra-vars", "ansible_connection='${var.vm_communicator}'",
                                  "--extra-vars", "ansible_shell_type='powershell'",
                                  "--extra-vars", "ansible_shell_executable='none'",
                                  "--extra-vars", "ansible_user='${var.build_username}'",
                                  "--extra-vars", "build_username='${var.build_username}'",
                                  "-vvvv"
                                ]
  }

  post-processor "vagrant" {
      keep_input_artifact = true
      compression_level  = 9
      vagrantfile_template = "${abspath(path.root)}/../../../../vagrant/windows/Vagrantfile"
      output             = "packer_${local.vm_name_standard_core}_{{.Provider}}_{{.Architecture}}.box"
  }
}

# windows-server-standard-desktop
build {

  name = "windows-server-standard-desktop"

  sources = [
      "qemu.windows-server-standard-desktop"
  ]

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
      extra_arguments         = [
                                  "--extra-vars", "ansible_connection='${var.vm_communicator}'",
                                  "--extra-vars", "ansible_shell_type='powershell'",
                                  "--extra-vars", "ansible_shell_executable='none'",
                                  "--extra-vars", "ansible_user='${var.build_username}'",
                                  "--extra-vars", "build_username='${var.build_username}'",
                                  "-vvvv"
                                ]
  }

  post-processor "vagrant" {
      keep_input_artifact = true
      compression_level  = 9
      vagrantfile_template = "${abspath(path.root)}/../../../../vagrant/windows/Vagrantfile"
      output             = "packer_${local.vm_name_standard_desktop}_{{.Provider}}_{{.Architecture}}.box"
  }
}

# windows-server-datacenter-core
build {
  name = "windows-server-datacenter-core"

  sources = [
      "qemu.windows-server-datacenter-core"
  ]

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
      extra_arguments         = [
                                  "--extra-vars", "ansible_connection='${var.vm_communicator}'",
                                  "--extra-vars", "ansible_shell_type='powershell'",
                                  "--extra-vars", "ansible_shell_executable='none'",
                                  "--extra-vars", "ansible_user='${var.build_username}'",
                                  "--extra-vars", "build_username='${var.build_username}'",
                                  "-vvvv"
                                ]
  }

  post-processor "vagrant" {
      keep_input_artifact = true
      compression_level  = 9
      vagrantfile_template = "${abspath(path.root)}/../../../../vagrant/windows/Vagrantfile"
      output             = "packer_${local.vm_name_datacenter_core}_{{.Provider}}_{{.Architecture}}.box"
  }
}

# windows-server-datacenter-desktop
build {

  name = "windows-server-datacenter-desktop"

  sources = [
      "qemu.windows-server-datacenter-desktop"
  ]

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
      extra_arguments         = [
                                  "--extra-vars", "ansible_connection='${var.vm_communicator}'",
                                  "--extra-vars", "ansible_shell_type='powershell'",
                                  "--extra-vars", "ansible_shell_executable='none'",
                                  "--extra-vars", "ansible_user='${var.build_username}'",
                                  "--extra-vars", "build_username='${var.build_username}'",
                                  "-vvvv"
                                ]
  }

  post-processor "vagrant" {
      keep_input_artifact = true
      compression_level  = 9
      vagrantfile_template = "${abspath(path.root)}/../../../../vagrant/windows/Vagrantfile"
      output             = "packer_${local.vm_name_datacenter_desktop}_{{.Provider}}_{{.Architecture}}.box"
  }
}
