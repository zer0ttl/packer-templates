# Debian 12
# https://www.debian.org/releases/bookworm/amd64/

# Locale and Keyboard
d-i debian-installer/locale string ${vm_guest_os_language}
d-i keyboard-configuration/xkb-keymap select ${vm_guest_os_keyboard}

# Clock and Timezone
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true
d-i time/zone string ${vm_guest_os_timezone}

# Grub and Reboot Message
d-i finish-install/reboot_in_progress note
d-i grub-installer/only_debian boolean true

# Partitioning
d-i partman-auto/method string lvm
d-i partman-auto-lvm/guided_size string max
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto/choose_recipe select atomic
d-i partman-md/confirm boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Network configuration

# Set dev for grub boot
d-i grub-installer/bootdev string /dev/vda

# Mirror settings
d-i mirror/country string manual
d-i mirror/http/hostname string cdn-fastly.deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# User Configuration
d-i passwd/root-login boolean false
d-i passwd/user-fullname string ${build_username}
d-i passwd/username string ${build_username}
d-i passwd/user-password-crypted password ${build_password_encrypted}

# Package Configuration
d-i pkgsel/run_tasksel boolean false
d-i pkgsel/include string openssh-server open-vm-tools python3-apt perl ${additional_packages}

# Add User to Sudoers, remove cdrom from apt sources, and add vagrant public keys
d-i preseed/late_command string \
    sed -i '/^deb cdrom:/s/^/#/' /target/etc/apt/sources.list ; \
    echo '${build_username} ALL=(ALL) NOPASSWD: ALL' > /target/etc/sudoers.d/${build_username} ; \
    in-target chmod 440 /etc/sudoers.d/${build_username} ; \
    in-target /bin/sh -c "mkdir -p /home/${build_username}/.ssh" ; \
%{ for key in build_authorized_keys ~}
    in-target /bin/sh -c "echo '${key}' >> /home/${build_username}/.ssh/authorized_keys" ; \
%{ endfor ~}
    in-target /bin/sh -c "chown -R ${build_username}:${build_username} /home/vagrant/.ssh/" ; \
    in-target /bin/sh -c "chmod 644 /home/vagrant/.ssh/authorized_keys" ; \
    in-target /bin/sh -c "chmod 700 /home/vagrant/.ssh/" ;

%{ if common_data_source == "disk" ~}
# Umount preseed media early
d-i preseed/early_command string \
    umount /media && echo 1 > /sys/block/sr1/device/delete ;
%{ endif ~}
