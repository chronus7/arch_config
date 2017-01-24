#!/usr/bin/env sh
# -*- coding: utf-8 -*-

# --- Arch Linux installation routine for VirtualBox-VMs.
#
# Instant usage with:
## bash <(curl -L https://raw.githubusercontent.com/chronus7/arch_config/master/init.sh)
#
# --- by Dave J (https://github.com/chronus7)

DISK="/dev/sda"
PARTITIONING='0\nn\np\n1\n\n\nw'
FORMATS=('ext4 /dev/sda1')
MOUNTS=('/dev/sda1 /mnt')
PACSTRAP='base'
HOSTNAME='arch'
TIMEZONE='/usr/share/zoneinfo/GMT'
LOCALE='en_GB.UTF-8'
KEYMAP='uk'

ENABLE_SUDO=true    # this might actually be necessary anyway for the user-specific installation
USER='user'
USER_SHELL='/bin/bash'
# TODO USER password?
# TODO ROOT password?

PACKAGES=(grub base-devel git vim xorg xterm xorg-xinit i3 feh bash-completion ttf-dejavu polkit transset-df qutebrowser)
VIRTUALBOX=true     # installs packages and enables service

# TODO maybe make dotfiles variable

# TODO switch over to pacaur
AUR=(package-query yaourt)
AUR_INSTALLER='yaourt -Si --noconfirm'
AUR_INSTALL=(dmenu-xft-mouse-height-fuzzy-history)

# TODO make the output variable

function usage() { echo "Usage: $@ ..."; }
function print_help() { echo -e "
Options:
    -h          Print this help message and exit.
    -l          List all variables and exit.
    -s          Disable sudo for the user.
    -u user     Set user name.
    -v          Disable virtualbox install."
    exit 0
}
function list_vars() {
    echo "Set variables:
    DISK            = $DISK
    PARTITIONING    = $PARTITIONING
    FORMATS         = ${FORMATS[@]}
    MOUNTS          = ${MOUNTS[@]}
    PACSTRAP        = $PACSTRAP
    HOSTNAME        = $HOSTNAME
    TIMEZONE        = $TIMEZONE
    LOCALE          = $LOCALE
    KEYMAP          = $KEYMAP
    ENABLE_SUDO     = $ENABLE_SUDO
    USER            = $USER
    USER_SHELL      = $USER_SHELL
    PACKAGES        = ${PACKAGES[@]}
    VIRTUALBOX      = $VIRTUALBOX
    AUR             = ${AUR[@]}
    AUR_INSTALLER   = $AUR_INSTALLER
    AUR_INSTALL     = ${AUR_INSTALL[@]}
"
}

# TODO more options
while getopts "hlsu:v" opt; do
    case $opt in
        h)  # help
            usage
            print_help
            ;;
        # TODO learn how to set arrays...
        l)  # list
            LIST_VARS=true
            ;;
        s)  # sudo
            ENABLE_SUDO=false
            ;;
        u)  # user
            USER=$OPTARG
            ;;
        v)  # virtualbox
            VIRTUALBOX=false
            ;;
        \?|*)
            echo "Invalid argument -$OPTARG" >&2
            usage
            exit 1
    esac
done

${LIST_VARS:-false} && { list_vars; exit 0; }

function info() { echo -e "\\e[31m>> $@\\e[m"; }

# :: ROUTINE

# TODO make optional
set -e

[ -z "$USER" ] && { info "Normal user:"; read USER; }   # ask here, so no further interaction may be required

info Partitioning.
echo -e "$PARTITIONING" | fdisk $DISK

info Formatting.
for i in "${FORMATS}"; do
    mkfs -t $i
done

info Mounting.
for i in "${MOUNTS}"; do
    # TODO create directory if necessary
    mount $i
done

info Installing base.
# TODO make /mnt variable
pacstrap /mnt $PACSTRAP

info Generating fstab.
genfstab -p /mnt >> /mnt/etc/fstab

info Chrooting.
arch-chroot /mnt <<CMD
    set -e
    function info() { echo -e "\\e[31m>> \$@\\e[m"; }
    alias install="pacman -S --noconfirm"

    info Hostname.
    echo $HOSTNAME > /etc/hostname

    info Localtime.
    ln -sf $TIMEZONE /etc/localtime

    info Locales.
    echo "$LOCALE UTF-8" > /etc/locale.gen
    locale-gen

    info Language.
    echo "LANG=$LOCALE" > /etc/locale.conf
    export LANG=$LOCALE

    info Keymap.
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

    info Ramdisk.
    mkinitcpio -p linux

    info Gub.
    install grub
    grub-install $DISK
    grub-mkconfig -o /boot/grub/grub.cfg

    info Network.
    systemctl enable dhcpcd

    info Packages.
    install ${PACKAGES[@]}

    if $VIRTUALBOX; then
        info Virtualbox.
        install virtualbox-guest-modules-arch virtualbox-guest-utils
        systemctl enable vboxservice
    fi

    if $ENABLE_SUDO; then
        # TODO correct this!
        info Sudo.
        sed -i 's/# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers
    fi

    info Creating user "$USER".
    useradd -m -G wheel -g users -s $USER_SHELL $USER
    passwd -d $USER

    info $USER settings.
    su $USER <<SU
        set -e
        function info() { echo -e "\\e[31m>> \$@\\e[m"; }
        cd /home/$USER
        export LANG=$LOCALE
        # Git requires the LANG, but it is not accessible yet.

        info Dotfiles.
        git clone --recursive https://github.com/chronus7/arch_config.git
        info "  correcting PS1."
        sed -i 's/maybedouble/simple/' arch_config/.bashrc
        if $VIRTUALBOX; then
            info "  setting virtualbox up."
            sed -i '\\\$iVBoxClient-all' arch_config/.xinitrc
        fi
        info "  bootstrapping."
        ./arch_config/dotextract.sh

        info AUR.
        ./arch_config/aur -si --noconfirm ${AUR[@]}

        info AUR-Packages.
        $AUR_INSTALLER ${AUR_INSTALL[@]}
SU
CMD

info Restarting.
umount -R /mnt
reboot
