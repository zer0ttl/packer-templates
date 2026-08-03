/*
  Input variables for different versions of Microsoft Windows Server 2019.
*/


variable "vm_accelerator" {
  type        = string
  description = "The virtualization platform."
  default     = "kvm"
}

variable "vm_boot_wait" {
  type        = string
  description = "The time to wait before boot."
}

variable "vm_communicator" {
  type        = string
  description = "The type of connection will be established to the machine."
  default     = "ssh"
}

variable "vm_cpu_count" {
  type        = number
  description = "The number of virtual CPUs."
}

variable "vm_disk_interface" {
  type        = string
  description = "The interface to use for the disk."
  default     = "virtio"
}

variable "vm_disk_size" {
  type        = number
  description = "The size for the virtual disk in MB."
}

variable "vm_mem_size" {
  type        = number
  description = "The size for the virtual memory in MB."
}

variable "vm_image_format" {
  type        = string
  description = "The output format of the virtual machine image."
  default     = "qcow2"
}

variable "vm_headless" {
  type        = bool
  description = "Start the VM with or without a console."
  default     = false
}

variable "iso_checksum" {
  type        = string
  description = "The checksum for the ISO file or virtual hard drive file."
/*
  Examples:
  md5:090992ba9fd140077b0661cb75f7ce13
  090992ba9fd140077b0661cb75f7ce13
  sha1:ebfb681885ddf1234c18094a45bbeafd91467911
  ebfb681885ddf1234c18094a45bbeafd91467911
  sha256:ed363350696a726b7932db864dda019bd2017365c9e299627830f06954643f93
  ed363350696a726b7932db864dda019bd2017365c9e299627830f06954643f93
  file:http://releases.ubuntu.com/20.04/SHA256SUMS
  file:file://./local/path/file.sum
  file:./local/path/file.sum
  none Although the checksum will not be verified when it is set to "none", this is not recommended since these files can be very large and corruption does happen from time to time.
*/
}

variable "iso_urls" {
  type        = list(string)
  description = "Multiple URLs for the ISO to download."
  default     = []
}

variable "vm_net_device" {
  type        = string
  description = "The virtual network card type."
  default     = "virtio-net"
}

variable "iso_virtio_windows" {
  type        = string
  description = "ISO URL for Virtio drivers for Microsoft Windows Operating Systems" 
}

variable "vm_output_directory" {
  type        = string
  description = "The output directory for the virtual machine image."
  default     = "output"
}

variable "vm_shutdown_command" {
  type        = string
  description = "Command(s) for guest operating system shutdown."
}

variable "common_shutdown_timeout" {
  type        = string
  description = "Time to wait for guest operating system shutdown."
}

variable "communicator_timeout" {
  type        = string
  description = "The timeout for the communicator protocol."
}

variable "communicator_port" {
  type        = string
  description = "The port for the communicator protocol."
}

variable "communicator_read_write_timeout" {
  type        = string
  description = "The amount of time to wait for a remote command to end. This is useful when packer hangs on a connection after a reboot."
}

variable "ansible_use_proxy" {
  type        = bool
  description = "Enable or disable setting up a localhost proxy adapter"
  default     = true
}

variable "ansible_galaxy_force_with_deps" {
  type        = bool
  description = "Force overwriting an existing role and its dependencies. Adds --force-with-deps option to ansible-galaxy command."
}

variable "vnc_bind_address" {
  type        = string
  description = "The IP address that should be binded to for VNC."
  default     = "0.0.0.0"
}

// variables for template file: autounattend.pkrtpl.hcl 

variable "build_username" {
  type        = string
  description = "The username to login to the guest operating system."
  sensitive   = true
}

variable "build_password" {
  type        = string
  description = "The password to login to the guest operating system."
  sensitive   = true
}

variable "build_vmname" {
  type        = string
  description = "The hostname of the guest operating system."
  sensitive   = false
}

variable "build_orgname" {
  type        = string
  description = "The org name to login to the guest operating system."
}

variable "vm_inst_os_language" {
  type        = string
  description = "The installation operating system lanugage."
  default     = "en-US"
}

variable "vm_inst_os_keyboard" {
  type        = string
  description = "The installation operating system keyboard input."
  default     = "en-US"
}

variable "vm_inst_os_image_standard_core" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Standard Core."
}

variable "vm_inst_os_image_standard_desktop" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Standard."
}

variable "vm_inst_os_image_datacenter_core" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Datacenter Core."
}

variable "vm_inst_os_image_datacenter_desktop" {
  type        = string
  description = "The installation operating system image input for Microsoft Windows Datacenter."
}

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system lanugage."
  default     = "en-US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "en-US"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone."
  default     = "UTC"
}

variable "vm_guest_os_family" {
  type        = string
  description = "The guest operating system family. Used for naming and VMware Tools."
}

variable "vm_guest_os_name" {
  type        = string
  description = "The guest operating system name. Used for naming."
}

variable "vm_guest_os_version" {
  type        = string
  description = "The guest operating system version. Used for naming."
}

variable "vm_guest_os_edition_standard" {
  type        = string
  description = "The guest operating system edition. Used for naming."
  default     = "standard"
}

variable "vm_guest_os_edition_datacenter" {
  type        = string
  description = "The guest operating system edition. Used for naming."
  default     = "datacenter"
}

variable "vm_guest_os_experience_core" {
  type        = string
  description = "The guest operating system minimal experience. Used for naming."
  default     = "core"
}

variable "vm_guest_os_experience_desktop" {
  type        = string
  description = "The guest operating system desktop experience. Used for naming."
  default     = "desktop"
}
