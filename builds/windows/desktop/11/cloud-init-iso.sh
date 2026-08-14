#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_DATA="${SCRIPT_DIR}/user-data"
META_DATA="${SCRIPT_DIR}/meta-data"

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Generate a cloud-init seed ISO for Windows VMs built with cloudbase-init.

The ISO is attached to the VM at launch. On first boot, cloudbase-init reads
it and sets the Administrator password, SSH keys, and hostname.

Options:
    -o, --output PATH    Output ISO path (default: ./seed.iso)
    -h, --help           Show this help

Configuration:
    Edit user-data to set your password and SSH public key.
    The template is at: ${USER_DATA}
EOF
}

OUTPUT="./seed.iso"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ ! -f "$USER_DATA" ]]; then
    echo "ERROR: user-data not found at $USER_DATA"
    exit 1
fi

echo "Generating cloud-init seed ISO..."
echo "  user-data: ${USER_DATA}"
echo "  meta-data: ${META_DATA}"
echo "  output:    ${OUTPUT}"

if command -v cloud-localds &>/dev/null; then
    cloud-localds "$OUTPUT" "$USER_DATA" "${META_DATA:-}"
elif command -v mkisofs &>/dev/null; then
    TMPDIR=$(mktemp -d)
    trap "rm -rf $TMPDIR" EXIT
    cp "$USER_DATA" "$TMPDIR/user-data"
    if [[ -f "$META_DATA" ]]; then
        cp "$META_DATA" "$TMPDIR/meta-data"
    fi
    mkisofs -o "$OUTPUT" -V cidata -J -rock "$TMPDIR"
elif command -v genisoimage &>/dev/null; then
    TMPDIR=$(mktemp -d)
    trap "rm -rf $TMPDIR" EXIT
    cp "$USER_DATA" "$TMPDIR/user-data"
    if [[ -f "$META_DATA" ]]; then
        cp "$META_DATA" "$TMPDIR/meta-data"
    fi
    genisoimage -o "$OUTPUT" -V cidata -J -rock "$TMPDIR"
else
    echo "ERROR: Neither cloud-localds, mkisofs, nor genisoimage found."
    echo "Install one of: cloud-image-utils (apt) / cloud-utils (dnf)"
    exit 1
fi

echo "Seed ISO created at: ${OUTPUT}"
echo ""
echo "Attach to VM with virsh:"
echo "  virt-install --import --disk /path/to/image.qcow2 --disk ${OUTPUT},device=cdrom ..."
echo ""
echo "Or add to an existing VM:"
echo "  virsh attach-disk <domain> ${OUTPUT} sda --type cdrom --config"
