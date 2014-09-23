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

#-- Get installation script
curl "https://raw.githubusercontent/DaveAtGit/arch_config/master/vm/root_setup.sh" > /root/setup.sh
chmod u+x /root/setup.sh

#-- Set root-password
echo -e "\\e[1;31m>> Set root-password:\\e[;m"
passwd

#-- Internet connection for next time?!
systemctl enable dhcpcd

exit
