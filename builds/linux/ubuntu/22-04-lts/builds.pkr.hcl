/*
    DESCRIPTION:
    Ubuntu 22.04 build definition.
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
    data_source_content = {
        "/meta-data" = file("${abspath(path.root)}/data/meta-data")
        "/user-data" = templatefile("${abspath(path.root)}/data/user-data.pkrtpl.hcl", {
            build_username           = var.build_username
            build_vmname             = var.build_vmname
            build_authorized_keys    = var.build_authorized_keys
            build_encrypted_password = var.build_encrypted_password
            vm_guest_os_language     = var.vm_guest_os_language
            vm_guest_os_keyboard     = var.vm_guest_os_keyboard
            vm_guest_os_timezone     = var.vm_guest_os_timezone
            vm_guest_os_family       = var.vm_guest_os_family
            network                  = file("${abspath(path.root)}/data/network.pkrtpl.hcl")
            storage                  = file("${abspath(path.root)}/data/storage.pkrtpl.hcl")
            additional_packages      = var.additional_packages
        })
    }
    vm_server      = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_server_edition}-${var.vm_guest_os_version}"
    vm_desktop     = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_desktop_edition}-${var.vm_guest_os_version}"
    project_root = "${abspath(path.root)}../../../.."
    ansible_path = "${abspath(path.root)}/../../../../ansible"
    scripts_path = "${abspath(path.root)}/../../../../scripts/${var.vm_guest_os_family}/common"
}

source "qemu" "linux-ubuntu" {
    accelerator = var.vm_accelerator
    boot_command = [
        "<wait3s>c<wait3s>",
        "set gfxpayload=keep<enter><wait>",
        "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ ---<enter>",
        "<wait>",
        "initrd /casper/initrd<wait><enter><wait>",
        "boot",
        "<enter>"
    ]
    boot_wait        = var.vm_boot_wait
    cpus             = var.vm_cpu_count
    disk_size        = var.vm_disk_size
    disk_interface   = var.vm_disk_interface
    format           = var.vm_image_format
    headless         = var.vm_headless
    http_content     = local.data_source_content
    iso_checksum     = var.iso_checksum
    iso_urls         = var.iso_urls
    memory           = var.vm_mem_size
    net_device       = var.vm_net_device
    shutdown_command = var.vm_shutdown_command
    shutdown_timeout = var.common_shutdown_timeout
    ssh_timeout      = var.communicator_timeout
    ssh_username     = var.build_username
    ssh_password     = var.build_password
    vnc_bind_address = var.vnc_bind_address
}

build {
    name = "ubuntu-server"

    sources = [
        "source.qemu.linux-ubuntu"
    ]

    provisioner "ansible" {
        user = var.build_username
        playbook_file = "${local.ansible_path}/linux-playbook.yml"
        roles_path = "${local.ansible_path}/roles"
        ansible_env_vars = [
        "ANSIBLE_CONFIG=${local.ansible_path}/ansible.cfg"
        ]
        extra_arguments = [
            "--extra-vars", "ansible_ssh_private_key_file=${abspath(path.root)}/${var.communicator_key_file}",
            "--extra-vars", "ansible_user='${var.build_username}'",
            "--extra-vars", "desktop_env=false"
        ]
    }

    post-processor "vagrant" {
        compression_level  = 9
        output             = "packer_${local.vm_server}_{{.Provider}}_{{.Architecture}}.box"
    }
}

build {
    name = "ubuntu-desktop"

    sources = [
        "source.qemu.linux-ubuntu"
    ]

    provisioner "ansible" {
        user = var.build_username
        playbook_file = "${local.ansible_path}/linux-playbook.yml"
        roles_path = "${local.ansible_path}/roles"
        ansible_env_vars = [
        "ANSIBLE_CONFIG=${local.ansible_path}/ansible.cfg"
        ]
        extra_arguments = [
            "--extra-vars", "ansible_ssh_private_key_file=${abspath(path.root)}/${var.communicator_key_file}",
            "--extra-vars", "ansible_user='${var.build_username}'",
            "--extra-vars", "desktop_env=true",
        ]
    }

    post-processor "vagrant" {
        compression_level  = 9
        output             = "packer_${local.vm_desktop}_{{.Provider}}_{{.Architecture}}.box"
    }
}