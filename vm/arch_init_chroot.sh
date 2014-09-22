#!/bin/bash
#-- Second part of the init-script.

#-- Hostname and timezone
echo arch > /etc/hostname
ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

#-- Locales etc.
echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "KEYMAP=uk" > /etc/vconsole.conf

#-- Create initial ramdisk
mkinitcpio -p linux

#-- Install GRUB
pacman -S --noconfirm grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

#-- General additional installations
#pacman -S --noconfirm sudo
# make changes in /etc/sudoers
#pacman -S --noconfirm base-devel
#pacman -S --noconfirm git
#pacman -S --noconfirm vim-python3
#pacman -S --noconfirm vimprobable2
# install yaourt
# get init-scripts

#-- Set root-password
echo "Set root-password:"
passwd

#-- Set new (normal) user
#echo "Create user:"
#useradd -m -G wheel -s /bin/bash user

#-- Internet connection for next time?!
#systemctl enable dhcpcd

exit
