#!/bin/bash
#-- The setup, done by root after rebooting

install="pacman -S --noconfirm"
aurinst="bash <(curl aur.sh) -si --noconfirm" #TODO seems not to work!

$install sudo
nano /etc/sudoers
# >> change this to be automated (copy sudoers file)

#-- Install basics
$install base-devel
$install git
$install vim-python3

#-- Install GUI
$install xorg xterm xorg-xinit
$install slim
$install i3 dmenu

#-- Install yaourt
$aurinst package-query
$aurinst yaourt
rm -rf package-query yaourt

#-- Create normal user
echo "Create user:"
read user
useradd -m -G wheel -s /bin/bash $user
passwd -d $user
# >> the password will be asked later.

#-- Clone repo and initialize
su $user <<CMD
cd /home/$user
git clone https://github.com/DaveAtGit/arch_config.git
. /home/$user/arch_config/setup.sh
CMD

#-- Set password of $user
echo "Set password of $user:"
passwd $user
