// Virtual Machine Hardware Settings
vm_accelerator = "kvm"
vm_boot_wait = "120s"
vm_cpu_count = 4
vm_disk_interface = "virtio"
vm_disk_size = 128000
vm_image_format = "qcow2"
vm_headless = true
vm_net_device = "virtio-net"
vm_mem_size = 8192
vm_machine_type = "q35"
// vm_shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Shutdown by Packer\""
vm_shutdown_command = "E:\\sysprep.bat"

// Communicator settings
vm_communicator = "ssh"
common_shutdown_timeout = "15m"
communicator_timeout = "5h"
communicator_port = 22
communicator_key_file = "vagrant-key"

// Removable Media Settings
iso_checksum = "sha256:d0ef4502e350e3c6c53c15b1b3020d38a5ded011bf04998e950720ac8579b23d"
iso_urls = ["https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"]
iso_virtio_windows = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"


// Installation Operating System Metadata
build_username = "vagrant"
build_password = "vagrant"
build_vmname = "vagrantvm"
build_orgname  = "Detekt Labs"
vm_inst_os_language = "en-US"
vm_inst_os_keyboard = "en-US"
vm_inst_os_image_standard_core      = "Windows Server 2025 SERVERSTANDARDCORE"
vm_inst_os_image_standard_desktop   = "Windows Server 2025 SERVERSTANDARD"
vm_inst_os_image_datacenter_core    = "Windows Server 2025 SERVERDATACENTERCORE"
vm_inst_os_image_datacenter_desktop = "Windows Server 2025 SERVERDATACENTER"

vm_guest_os_language = "en-US"
vm_guest_os_keyboard = "en-US"
vm_guest_os_timezone = "UTC"

vm_guest_os_family             = "windows"
vm_guest_os_name               = "server"
vm_guest_os_version            = "2025"
vm_guest_os_edition_standard   = "standard"
vm_guest_os_edition_datacenter = "datacenter"
vm_guest_os_experience_core    = "core"
vm_guest_os_experience_desktop = "desktop"
