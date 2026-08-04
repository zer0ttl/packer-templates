/*
    DESCRIPTION:
    Windows Server 2022 Standard build definition.
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
  vm_name_ent                = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_ent}"
  vm_name_pro                = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_pro}"
  scripts_path               = "${abspath(path.root)}/../../../../scripts/${var.vm_guest_os_family}/common"
  vm_cd_files_core           = [
                                "${local.scripts_path}/install-openssh.ps1",
                                "${local.scripts_path}/install-virtio-guest-tools.ps1",
                                "${local.scripts_path}/configure-power.ps1",
                                "${local.scripts_path}/apply-common-fixes.ps1",
                                "${local.scripts_path}/stage-setup-complete.ps1",
                                "${local.scripts_path}/SetupComplete.cmd",
                                "${local.scripts_path}/sysprep.bat"
                              ]
  vm_cd_files_desktop        = [
                                "${local.scripts_path}/install-openssh.ps1",
                                "${local.scripts_path}/install-virtio-guest-tools.ps1",
                                "${local.scripts_path}/install-spice-tools.ps1",
                                "${local.scripts_path}/install-bginfo.ps1",
                                "${local.scripts_path}/bginfo.bgi",
                                "${local.scripts_path}/configure-power.ps1",
                                "${local.scripts_path}/apply-common-fixes.ps1",
                                "${local.scripts_path}/stage-setup-complete.ps1",
                                "${local.scripts_path}/SetupComplete.cmd",
                                "${local.scripts_path}/sysprep.bat"
                              ]
  vm_provision_files_core    = [
                                "${local.scripts_path}/install-virtio-guest-tools.ps1",
                                "${local.scripts_path}/configure-power.ps1",
                                "${local.scripts_path}/apply-common-fixes.ps1",
                                "${local.scripts_path}/stage-setup-complete.ps1"
                                ]
  vm_provision_files_desktop = [
                                "${local.scripts_path}/install-virtio-guest-tools.ps1",
                                "${local.scripts_path}/install-spice-tools.ps1",
                                "${local.scripts_path}/install-bginfo.ps1",
                                "${local.scripts_path}/configure-power.ps1",
                                "${local.scripts_path}/apply-common-fixes.ps1",
                                "${local.scripts_path}/stage-setup-complete.ps1"
                                ]
}

source "qemu" "enterprise" {
  accelerator           = var.vm_accelerator
  boot_wait             = var.vm_boot_wait
  boot_command          = var.vm_boot_command
  communicator          = var.vm_communicator
  cpus                  = var.vm_cpu_count
  cpu_model             = var.vm_cpu_model
  disk_interface        = var.vm_disk_interface
  disk_size             = var.vm_disk_size
  machine_type          = var.vm_machine_type
  efi_boot              = true
  efi_firmware_code     = var.vm_efi_firmware_code
  efi_firmware_vars     = var.vm_efi_firmware_vars
  cd_files              = local.vm_cd_files_core
  cd_content            = {
                            "Autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
                                build_username       = var.build_username
                                build_password       = var.build_password
                                build_orgname        = var.build_orgname
                                vm_inst_os_language  = var.vm_inst_os_language
                                vm_inst_os_keyboard  = var.vm_inst_os_keyboard
                                vm_inst_os_image     = var.vm_inst_os_image_ent
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
  format               = var.vm_image_format
  headless             = var.vm_headless
  iso_checksum         = var.iso_checksum
  iso_urls             = var.iso_urls
  net_device           = var.vm_net_device
  qemuargs             = [
                            ["-cdrom", "${var.iso_virtio_windows}"],
                            ["-global", "driver=cfi.pflash01,property=secure,value=on"]
                         ]
  memory               = var.vm_mem_size
  shutdown_command     = var.vm_shutdown_command
  shutdown_timeout     = var.common_shutdown_timeout
  ssh_username         = var.build_username
  ssh_private_key_file = var.communicator_key_file
  ssh_wait_timeout     = var.communicator_timeout
  vnc_bind_address     = var.vnc_bind_address
  vtpm                 = var.vm_vtpm
}

// source "qemu" "professional" {
//   accelerator           = var.vm_accelerator
//   boot_wait             = var.vm_boot_wait
//   boot_command          = var.vm_boot_command
//   communicator          = var.vm_communicator
//   cpus                  = var.vm_cpu_count
//   cpu_model             = var.vm_cpu_model
//   disk_interface        = var.vm_disk_interface
//   disk_size             = var.vm_disk_size
//   machine_type          = var.vm_machine_type
//   efi_boot              = true
//   efi_firmware_code     = var.vm_efi_firmware_code
//   efi_firmware_vars     = var.vm_efi_firmware_vars
//   cd_files              = local.vm_cd_files_desktop
//   cd_content            = {
//                             "Autounattend.xml" = templatefile("${abspath(path.root)}/data/autounattend.pkrtpl.hcl", {
//                                 build_username       = var.build_username
//                                 build_password       = var.build_password
//                                 build_orgname        = var.build_orgname
//                                 vm_inst_os_language  = var.vm_inst_os_language
//                                 vm_inst_os_keyboard  = var.vm_inst_os_keyboard
//                                 vm_inst_os_image     = var.vm_inst_os_image_pro
//                                 vm_guest_os_language = var.vm_guest_os_language
//                                 vm_guest_os_keyboard = var.vm_guest_os_keyboard
//                                 vm_guest_os_timezone = var.vm_guest_os_timezone
//                             }),
//                             "unattend.xml" = templatefile("${abspath(path.root)}/data/unattend.pkrtpl.hcl", {
//                                 build_username       = var.build_username
//                                 build_password       = var.build_password
//                                 build_vmname         = var.build_vmname
//                                 vm_guest_os_timezone = var.vm_guest_os_timezone
//                             })
//                         }
//   format               = var.vm_image_format
//   headless             = var.vm_headless
//   iso_checksum         = var.iso_checksum
//   iso_urls             = var.iso_urls
//   net_device           = var.vm_net_device
//   qemuargs             = [
//                             ["-cdrom", "${var.iso_virtio_windows}"],
//                             ["-global", "driver=cfi.pflash01,property=secure,value=on"]
//                          ]
//   memory               = var.vm_mem_size
//   shutdown_command     = var.vm_shutdown_command
//   shutdown_timeout     = var.common_shutdown_timeout
//   ssh_username         = var.build_username
//   ssh_private_key_file = var.communicator_key_file
//   ssh_wait_timeout     = var.communicator_timeout
//   vnc_bind_address     = var.vnc_bind_address
//   vtpm                 = var.vm_vtpm
// }

build {
  name = "enterprise"

  sources = [
      "source.qemu.enterprise"
  ]

  provisioner "powershell" {
    elevated_user        = var.build_username
    elevated_password    = var.build_password
    scripts              = local.vm_provision_files_core
  }

  post-processor "vagrant" {
      compression_level  = 9
      output             = "packer_${local.vm_name_ent}_{{.Provider}}_{{.Architecture}}.box"
  }
}

// build {

//   name = "professional"

//   sources = [
//       "source.qemu.professional"
//   ]

//   provisioner "powershell" {
//     elevated_user        = var.build_username
//     elevated_password    = var.build_password
//     scripts              = local.vm_provision_files_desktop
//   }

//   post-processor "vagrant" {
//       compression_level  = 9
//       output             = "packer_${local.vm_name_pro}_{{.Provider}}_{{.Architecture}}.box"
//   }
// }
