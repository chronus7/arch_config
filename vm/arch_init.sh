#!/bin/bash
#-- Init-script for arch-linux-vms.

#-- Partitioning disk with default size, naming it
#   "archlinux" and formatting it to ext4.

# !! -A 1:set:2 should switch bootable, but it seems
#    not possible with sgdisk. And it seems to use the
#    wrong table-format...
#sgdisk -n 1:2048:0 -c 1:"archlinux" -t 1:8300 /dev/sda
cfdisk /dev/sda     # !! currently requires user-interaction...
mkfs.ext4 -L archlinux /dev/sda1

#-- Mounting and base-installation
mount /dev/sda1 /mnt
pacstrap /mnt base
genfstab -p /mnt >> /mnt/etc/fstab
mv arch_init_chroot.sh /mnt/root/arch_init_chroot.sh
arch-chroot /mnt ./root/arch_init_chroot.sh

#-- Unmounting and restarting
umount /mnt
reboot
