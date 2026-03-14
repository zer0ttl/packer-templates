#cloud-config

# Ubuntu Server 24.04 LTS

autoinstall:
  version: 1
  apt:
    preserve_sources_list: false
    mirror-selection:
      primary:
        - country-mirror
        - arches: [i386, amd64]
          uri: "http://archive.ubuntu.com/ubuntu"
        - arches: [default]
          uri: "http://ports.ubuntu.com/ubuntu-ports"
    fallback: abort
    geoip: true
  early-commands:
    - sudo systemctl stop ssh
  locale: ${vm_guest_os_language}
  keyboard:
    layout: ${vm_guest_os_keyboard}
    variant: ""
    toggle: ""
${storage}
${network}
  identity:
    hostname: ${build_vmname}
    username: ${build_username}
    password: ${build_encrypted_password}
  ssh:
    install-server: true
    allow-pw: true
    authorized-keys:
%{ for key in build_authorized_keys ~}
      - ${key}
%{ endfor ~}
  packages:
    - openssh-server
%{ for package in additional_packages ~}
    - ${package}
%{ endfor ~}
  user-data:
    disable_root: false
    timezone: ${vm_guest_os_timezone}
  late-commands:
    # Disable Predictable Network Interface names and use eth0
    - sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT=="\1 net.ifnames=0 biosdevname=0"/g' /target/etc/default/grub
    - sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=" net.ifnames/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames/g' /target/etc/default/grub
    - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
    - echo '${build_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${build_username}
    - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${build_username}
    - curtin in-target --target=/target -- update-grub
