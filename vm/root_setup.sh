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
systemctl enable slim
$install i3 dmenu


#-- Create normal user
echo -e "\\e[1;31m>> Create user:\\e[;m"
read user
useradd -m -G wheel -s /bin/bash $user
passwd -d $user
# >> the password will be asked later.

#-- Install yaourt, clone repo and initialize
su $user <<CMD
cd /home/$user

$aurinst package-query
$aurinst yaourt
rm -rf package-query yaourt

git clone https://github.com/DaveAtGit/arch_config.git
. /home/$user/arch_config/setup.sh
CMD

#-- Set password of $user
echo -e "\\e[1;31m>> Set password for $user:\\e[;m"
passwd $user
