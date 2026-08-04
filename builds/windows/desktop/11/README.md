# Windows 11 Desktop

This template builds Windows 11 Enterprise Evaluation with UEFI Secure Boot,
TPM 2.0, at least 4 GB of memory, and at least 64 GB of storage. The answer file
bypasses only the Windows Setup CPU eligibility check so the image can be built
on the Xeon E5-2620 v3 host. TPM, Secure Boot, memory, and storage checks remain
enabled.

## Build host requirements

The build host must provide:

- An x86-64 CPU with hardware virtualization enabled. The CPU eligibility
  exception for this build host is documented below.
- Linux KVM access for the user running Packer (`/dev/kvm` must be readable and
  writable).
- Packer 1.10 or newer and the plugins declared in `builds.pkr.hcl`.
- QEMU with x86-64, KVM, TPM, and pflash support.
- `swtpm` and `swtpm-tools` for the TPM 2.0 emulator used by Packer's `vtpm`
  option.
- OVMF Secure Boot firmware and a variables template containing Microsoft's
  enrolled keys.
- Vagrant with the libvirt provider for the Vagrant post-processor.

The template uses `cpu_model = "host"`, so Windows sees the build host's CPU
model. The Xeon E5-2620 v3 is not on Microsoft's
[Windows 11 22H2 and 23H2 supported Intel processors](https://learn.microsoft.com/en-us/windows-hardware/design/minimum/supported/windows-11-22h2-supported-intel-processors)
list. The unattended setup therefore sets only `BypassCPUCheck`; the resulting
Windows installation is unsupported by Microsoft even though the remaining
Windows 11 hardware and security requirements are satisfied.

On Ubuntu or Debian, install the virtualization dependencies with:

```shell
sudo apt-get install qemu-system-x86 qemu-utils ovmf swtpm swtpm-tools
```

Confirm the required devices, commands, and firmware files before building:

```shell
test -r /dev/kvm && test -w /dev/kvm
lscpu
command -v qemu-system-x86_64
command -v swtpm
test -r /usr/share/OVMF/OVMF_CODE_4M.secboot.fd
test -r /usr/share/OVMF/OVMF_VARS_4M.ms.fd
```

Run `packer init .` in this directory before the first build so Packer installs
the required plugins.

## Installation media layout

The QEMU build attaches the Windows installation ISO, Packer's generated
configuration CD, and the VirtIO driver ISO. Windows Setup must enumerate the
VirtIO ISO as `F:` because the `windowsPE` driver paths use that drive. The
answer file validates `F:\viostor\w11\amd64\viostor.inf` before installation
and stops immediately if the media layout is incorrect, instead of continuing
to an interactive disk or driver prompt.

The generated configuration CD does not require a fixed drive letter. During
the first automatic logon, the answer file searches mounted filesystem drives
for `install-openssh.ps1` and runs the copy found at the root of that CD.

## Runtime requirements

The installed disk uses GPT and an EFI system partition. A VM created from the
image must therefore boot with UEFI firmware rather than legacy BIOS. To retain
the Windows 11 security posture, configure the runtime with Secure Boot using
Microsoft-enrolled keys and attach a TPM 2.0 device with persistent TPM state.
