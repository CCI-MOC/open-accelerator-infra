#!/bin/bash
#
# Build a bootable ISO for disk discovery via iDRAC virtual media.
#
# The ISO boots a minimal Linux environment that displays disk info
# on the console and serves it via HTTP.
#
# Usage:
#   sudo ./build.sh [output.iso]
#
# Environment variables:
#   KERNEL_VERSION  - kernel version to use (default: running kernel)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="$(mktemp -d)"
ISO_DIR="${WORK_DIR}/iso"
OUTPUT="${1:-${SCRIPT_DIR}/discovery-r440.iso}"
KERNEL_VERSION="${KERNEL_VERSION:-$(uname -r)}"
KERNEL="/boot/vmlinuz-${KERNEL_VERSION}"

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

# Check prerequisites
missing=()
command -v dracut &>/dev/null || missing+=("dracut")
command -v xorriso &>/dev/null || missing+=("xorriso")
command -v grub2-mkstandalone &>/dev/null || missing+=("grub2-tools-extra")
command -v mkfs.vfat &>/dev/null || missing+=("dosfstools")
command -v mcopy &>/dev/null || missing+=("mtools")
command -v busybox &>/dev/null || missing+=("busybox")
[[ -f /usr/share/syslinux/isolinux.bin ]] || missing+=("syslinux")
[[ -d /usr/lib/grub/x86_64-efi ]] || missing+=("grub2-efi-x64-modules")

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "ERROR: Missing packages: ${missing[*]}"
  echo "Install with: sudo dnf install ${missing[*]}"
  exit 1
fi

if [[ ! -f "$KERNEL" ]]; then
  echo "ERROR: Kernel not found: $KERNEL"
  echo "Available kernels:"
  ls /boot/vmlinuz-* 2>/dev/null | sed 's|/boot/vmlinuz-|  |' || echo "  (none found)"
  echo "Set KERNEL_VERSION to specify a different kernel."
  exit 1
fi

if [[ ! -r "$KERNEL" ]]; then
  echo "ERROR: Cannot read $KERNEL (permission denied)"
  echo "Either run as root or: sudo chmod 644 $KERNEL"
  exit 1
fi

echo "Building discovery ISO..."
echo "  Kernel: ${KERNEL_VERSION}"
echo "  Output: ${OUTPUT}"

# ---------------------------------------------------------------------------
# Build initramfs with dracut
# ---------------------------------------------------------------------------
echo "==> Building initramfs..."
INITRD="${WORK_DIR}/initrd.img"

chmod 755 "${SCRIPT_DIR}/discovery-init" \
  "${SCRIPT_DIR}/discovery-report" \
  "${SCRIPT_DIR}/udhcpc-script" \
  "${SCRIPT_DIR}/clear"

dracut \
  --no-hostonly \
  --force \
  --modules "base udev-rules" \
  --install "lsblk lspci sh cat ip busybox mount umount mkdir printf udevadm poweroff reboot sleep curl setsid" \
  --add-drivers "ahci nvme megaraid_sas mpt3sas sd_mod sr_mod virtio_blk virtio_scsi e1000 e1000e igb ixgbe i40e ice mlx5_core tg3 bnx2 bnx2x bnxt_en virtio_net" \
  --include /usr/share/hwdata/pci.ids /usr/share/hwdata/pci.ids \
  --include "${SCRIPT_DIR}/discovery-init" /usr/bin/discovery-init \
  --include "${SCRIPT_DIR}/discovery-report" /usr/bin/discovery-report \
  --include "${SCRIPT_DIR}/udhcpc-script" /usr/bin/udhcpc-script \
  --include "${SCRIPT_DIR}/clear" /usr/bin/clear \
  "$INITRD" \
  "$KERNEL_VERSION"

# dracut's --add-drivers already runs depmod internally, so no
# manual unpack/repack needed.

# ---------------------------------------------------------------------------
# Create ISO directory structure
# ---------------------------------------------------------------------------
echo "==> Creating ISO layout..."
mkdir -p "${ISO_DIR}/boot/grub" "${ISO_DIR}/isolinux"

cp "$KERNEL" "${ISO_DIR}/boot/vmlinuz"
cp "$INITRD" "${ISO_DIR}/boot/initrd.img"

CMDLINE="rdinit=/usr/bin/discovery-init console=ttyS0,115200n8 console=ttyS1,115200n8 console=tty0"

# GRUB configuration (UEFI)
cat >"${ISO_DIR}/boot/grub/grub.cfg" <<EOF
set timeout=3
set default=0

menuentry "Disk Discovery" {
    linux /boot/vmlinuz ${CMDLINE}
    initrd /boot/initrd.img
}
EOF

# ISOLINUX configuration (BIOS)
cp /usr/share/syslinux/isolinux.bin "${ISO_DIR}/isolinux/"
cp /usr/share/syslinux/ldlinux.c32 "${ISO_DIR}/isolinux/"
cp /usr/share/syslinux/libcom32.c32 "${ISO_DIR}/isolinux/" 2>/dev/null || true

cat >"${ISO_DIR}/isolinux/isolinux.cfg" <<EOF
DEFAULT discovery
LABEL discovery
    KERNEL /boot/vmlinuz
    APPEND initrd=/boot/initrd.img ${CMDLINE}
EOF

# ---------------------------------------------------------------------------
# Create EFI boot image
# ---------------------------------------------------------------------------
echo "==> Creating EFI boot image..."

GRUB_EMBED_CFG="${WORK_DIR}/grub-embed.cfg"
cat >"$GRUB_EMBED_CFG" <<'EOF'
set prefix=(memdisk)/boot/grub
insmod normal
insmod iso9660
set root=(cd0)
configfile ($root)/boot/grub/grub.cfg
EOF

GRUB_EFI="${WORK_DIR}/bootx64.efi"
grub2-mkstandalone \
  --format=x86_64-efi \
  --output="$GRUB_EFI" \
  --locales="" \
  --fonts="" \
  --modules="iso9660 part_gpt part_msdos" \
  "boot/grub/grub.cfg=${GRUB_EMBED_CFG}"

EFI_IMG="${ISO_DIR}/efi.img"
EFI_IMG_SIZE=$(($(stat -c%s "$GRUB_EFI") / 1048576 + 4))
dd if=/dev/zero of="$EFI_IMG" bs=1M count="$EFI_IMG_SIZE" 2>/dev/null
mkfs.vfat "$EFI_IMG" >/dev/null
mmd -i "$EFI_IMG" ::/EFI ::/EFI/BOOT
mcopy -i "$EFI_IMG" "$GRUB_EFI" ::/EFI/BOOT/BOOTX64.EFI

# ---------------------------------------------------------------------------
# Build hybrid ISO (BIOS + UEFI)
# ---------------------------------------------------------------------------
echo "==> Building ISO..."
xorriso -as mkisofs \
  -o "$OUTPUT" \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "DISCOVERY" \
  --sort-weight 4 /isolinux \
  --sort-weight 3 /efi.img \
  --sort-weight 2 /boot/vmlinuz \
  --sort-weight 1 /boot/initrd.img \
  -eltorito-boot isolinux/isolinux.bin \
  -eltorito-catalog isolinux/boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -isohybrid-mbr /usr/share/syslinux/isohdpfx.bin \
  -eltorito-alt-boot \
  -e efi.img \
  -no-emul-boot \
  -isohybrid-gpt-basdat \
  "$ISO_DIR"

echo ""
echo "Done! ISO created: ${OUTPUT}"
echo "Size: $(du -h "$OUTPUT" | cut -f1)"
echo ""
echo "To use with iDRAC:"
echo "  1. Open iDRAC web console"
echo "  2. Go to Configuration > Virtual Media"
echo "  3. Map the ISO as a virtual CD/DVD"
echo "  4. Set next boot to virtual CD/DVD"
echo "  5. Reboot the server"
