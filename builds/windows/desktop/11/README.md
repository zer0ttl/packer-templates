# Windows 11 Desktop

This template builds Windows 11 Enterprise Evaluation with the hardware features
required by Windows 11: a compatible host CPU, UEFI Secure Boot, TPM 2.0, at
least 4 GB of memory, and at least 64 GB of storage. The answer file does not
bypass Windows hardware checks.

## Build host requirements

The build host must provide:

- An x86-64 CPU supported by Windows 11 with hardware virtualization enabled.
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
model. Compare the processor reported by `lscpu` with Microsoft's
[Windows 11 22H2 and 23H2 supported Intel processors](https://learn.microsoft.com/en-us/windows-hardware/design/minimum/supported/windows-11-22h2-supported-intel-processors)
or the corresponding AMD list. The Xeon E5-2620 v3 recorded in this repository's
existing Server 2025 build log is not on the Windows 11 support list; a build on
that processor can still fail the CPU check. This template intentionally does
not bypass that check.

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

## Runtime requirements

The installed disk uses GPT and an EFI system partition. A VM created from the
image must therefore boot with UEFI firmware rather than legacy BIOS. To retain
the Windows 11 security posture, configure the runtime with Secure Boot using
Microsoft-enrolled keys and attach a TPM 2.0 device with persistent TPM state.
