// Virtual Machine Hardware Settings
vm_accelerator              = "kvm"
vm_boot_wait                = "30s"
vm_cpu_count                = 4
vm_disk_interface           = "virtio"
vm_disk_size                = 128000
vm_image_format             = "qcow2"
vm_headless                 = true
vm_net_device               = "virtio-net"
vm_mem_size                 = 8192
// vm_shutdown_command      = "shutdown /s /t 10 /f /d p:4:1 /c \"Shutdown by Packer\""
vm_shutdown_command         = "E:\\sysprep.bat"

// Communicator settings
vm_communicator                     = "ssh"
common_shutdown_timeout             = "15m"
communicator_timeout                = "5h"
communicator_port                   = 22
communicator_key_file               = "vagrant-key"
communicator_clear_authorized_keys  = true
communicator_read_write_timeout     = "60s"

// Provisioner: ansible settings
ansible_use_proxy                   = false
ansible_galaxy_force_with_deps      = false

// Removable Media Settings
iso_checksum        = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
iso_urls            = ["https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"]
iso_virtio_windows  = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"

// Installed Operating System Metadata
build_username                      = "vagrant"
build_password                      = "vagrant"
build_vmname                        = "vagrantvm"
build_orgname                       = "Detekt Labs"
vm_inst_os_language                 = "en-US"
vm_inst_os_keyboard                 = "en-US"
vm_inst_os_image_standard_core      = "Windows Server 2022 SERVERSTANDARDCORE"
vm_inst_os_image_standard_desktop   = "Windows Server 2022 SERVERSTANDARD"
vm_inst_os_image_datacenter_core    = "Windows Server 2022 SERVERDATACENTERCORE"
vm_inst_os_image_datacenter_desktop = "Windows Server 2022 SERVERDATACENTER"

vm_guest_os_language           = "en-US"
vm_guest_os_keyboard           = "en-US"
vm_guest_os_timezone           = "UTC"
vm_guest_os_family             = "windows"
vm_guest_os_name               = "server"
vm_guest_os_version            = "2022"
vm_guest_os_edition_standard   = "standard"
vm_guest_os_edition_datacenter = "datacenter"
vm_guest_os_experience_core    = "core"
vm_guest_os_experience_desktop = "desktop"
