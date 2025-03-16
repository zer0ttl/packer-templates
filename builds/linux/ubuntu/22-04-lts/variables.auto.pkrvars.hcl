// Virtual Machine Hardware Settings
vm_accelerator = "kvm"
vm_boot_wait = "10s"
vm_cpu_count = 4
vm_disk_interface = "virtio"
vm_disk_size = 128000
vm_image_format = "qcow2"
vm_headless = true
vm_net_device = "virtio-net"
vm_mem_size = 4096
vm_network_device = "eth0"
vm_shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"


// Additional Packages
additional_packages= [
    "sed",
    "curl",
    "sudo"
]

// Removable Media Settings
iso_checksum = "sha256:45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2"
iso_urls = ["https://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"]

// Communicator settings
vm_communicator = "ssh"
common_shutdown_timeout = "15m"
communicator_timeout = "5h"
communicator_port = 22
communicator_key_file = "vagrant-key"

// Installation Operating System Metadata
build_username = "vagrant"
build_password = "vagrant"
build_vmname = "vagrantvm"
build_encrypted_password = "$1$9bp.cPKY$BeaZIuXT4PyfJBnTu74c4."
build_authorized_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
]

vm_guest_os_language = "en_US.UTF-8"
vm_guest_os_keyboard = "us"
vm_guest_os_timezone = "UTC"

vm_guest_os_family             = "linux"
vm_guest_os_name               = "ubuntu"
vm_guest_server_edition        = "server"
vm_guest_desktop_edition       = "desktop"
vm_guest_os_version            = "22.04.4"