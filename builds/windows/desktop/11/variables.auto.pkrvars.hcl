// Virtual Machine Hardware Settings
vm_accelerator = "kvm"
vm_boot_wait = "30s"
vm_cpu_count = 4
vm_disk_interface = "virtio"
vm_disk_size = 128000
vm_image_format = "qcow2"
vm_headless = true
vm_vtpm = true
vm_net_device = "virtio-net"
vm_mem_size = 8192
// vm_shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Shutdown by Packer\""
vm_shutdown_command = "E:\\sysprep.bat"

// Communicator settings
vm_communicator = "ssh"
common_shutdown_timeout = "15m"
communicator_timeout = "5h"
communicator_port = 22
communicator_key_file = "vagrant-key"

// Removable Media Settings
iso_checksum = "sha256:C8DBC96B61D04C8B01FAF6CE0794FDF33965C7B350EAA3EB1E6697019902945C"
iso_urls = ["https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/22631.2428.231001-0608.23H2_NI_RELEASE_SVC_REFRESH_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"]
iso_virtio_windows = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"

// Installation Operating System Metadata
build_username = "vagrant"
build_password = "vagrant"
build_vmname = "vagrantvm"
build_orgname  = "Detekt Labs"
vm_inst_os_language = "en-US"
vm_inst_os_keyboard = "en-US"
vm_inst_os_image_standard_core      = "Windows Server 2022 SERVERSTANDARDCORE"
vm_inst_os_image_standard_desktop   = "Windows Server 2022 SERVERSTANDARD"
vm_inst_os_image_datacenter_core    = "Windows Server 2022 SERVERDATACENTERCORE"
vm_inst_os_image_datacenter_desktop = "Windows Server 2022 SERVERDATACENTER"
vm_inst_os_image_ent                = "Windows 11 Enterprise Evaluation"
vm_inst_os_image_pro                = "Windows 11 Enterprise Evaluation"

vm_guest_os_language = "en-US"
vm_guest_os_keyboard = "en-US"
vm_guest_os_timezone = "UTC"

vm_guest_os_family             = "windows"
vm_guest_os_name               = "desktop"
vm_guest_os_version            = "11-23H2"
vm_guest_os_edition_pro        = "pro"
vm_guest_os_edition_ent        = "ent"
