#!/usr/bin/env sh
# -*- coding: utf-8 -*-

# --- Arch Linux installation routine for VirtualBox-VMs.
#   - adjusted for Bro/Broker development
#
#   - VM settings:
#       - disk of at least 10GiB (dynamic) storage
#       - NO EFI emulation
#       - as much RAM as possible
#       - as many CPUs as possible
#       - as much Video Memory as possible (128MB)
#       - default NAT network
#       - shared folders are untested
#
#   - start-up the vm with an arch-iso.
#   - use `loadkeys de-latin1|uk` (see `ls /usr/share/kbd/keymapds/`) to adjust keymap
#   - get the init-script and execute it (`sh init_bro.sh`).
#   - the script restarts the vm, when done; then boot from disk!
#   - just login as `user` (if not otherwise specified)
#
#   - adjust your git settings in ~/.config/git/user
#   - execute ./key.install to setup the ssh-key
#   - execute ./bro.install to install bro
#   - execute ./docker.install to install docker (restarts VM)
#   - execute ./latex.install to install latex (no pandoc)
#
#   - Select "Arc-Dark"/"Arc" Theme
#   - Applications->Settings->Settings Manager
#       - Appearance->Style / Appearance->Icons / Window Manager->Style
#   - firefox add-on "Arc Dark Theme"
#
#   - https://wiki.archlinux.org/index.php/Xfce
#
#   - pdf-viewer: epdfview
#   - brower: firefox
#   - editors: ... vim, clion-stable
#
# Instant usage with:
# # bash <(curl -L https://raw.githubusercontent.com/chronus7/arch_config/master/init_bro.sh)
#
# Alternative method:
#   - run something like `python -m http.server` to host the file on the host-machine
#   - curl -LO http://<hostname>:<port>/init_bro.sh
#   - sh init_bro.sh -h
#
# --- by Dave J (https://github.com/chronus7)

DISK="/dev/sda"
PARTITIONING='0\nn\np\n1\n\n\nw'
FORMATS=('ext4 /dev/sda1')
MOUNTS=('/dev/sda1 /mnt')
PACSTRAP='base'
HOSTNAME='archvm'
TIMEZONE='/usr/share/zoneinfo/Europe/Berlin'
LOCALE='en_GB.UTF-8'
KEYMAP='de'

ENABLE_SUDO=true    # this might actually be necessary anyway for the user-specific installation
USER='user'
USER_SHELL='/bin/bash'
# TODO USER password?
# TODO ROOT password?

PACKAGES=(grub base-devel git vim openssh xorg xterm xorg-xinit xfce4 arc-gtk-theme arc-icon-theme feh bash-completion ttf-dejavu polkit firefox openssl epdfview expac yajl)
VIRTUALBOX=true     # installs packages and enables service

AUR=(cower pacaur)
AUR_INSTALLER='pacaur -S --needed --noedit --noconfirm'
AUR_INSTALL=(clion clion-jre clion-cmake clion-gdb clion-lldb)  # just to make sure...

# TODO make the output variable

function usage() { echo "Usage: $@ ..."; }
function print_help() { echo -e "
Options:
    -h          Print this help message and exit.
    -l          List all variables and exit.
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

info Setting mirror.
echo 'Server = http://mirror.metalgamer.eu/archlinux/$repo/os/$arch
Server = http://ftp.spline.inf.fu-berlin.de/mirrors/archlinux/$repo/os/$arch
Server = http://ftp.uni-hannover.de/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

info Installing base.
# TODO make /mnt variable
pacstrap /mnt $PACSTRAP

info Generating fstab.
genfstab -p /mnt >> /mnt/etc/fstab

info Chrooting.
arch-chroot /mnt <<CMD
    function info() { echo -e "\\e[31m>> \$@\\e[m"; }
    alias install="pacman -S --needed --noconfirm"

    info Hostname.
    echo $HOSTNAME > /etc/hostname

    info Localtime.
    ln -s $TIMEZONE /etc/localtime

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

    info Grub.
    # TODO change to bootctl?
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
        systemctl enable vboservice
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
        function info() { echo -e "\\e[31m>> \\\$@\\e[m"; }
        cd /home/$USER
        export LANG=$LOCALE
        # Git requires the LANG, but it is not accessible yet.

        info Dotfiles.
        git clone --recursive https://github.com/chronus7/arch_config.git
        info "  correcting PS1."
        sed -i 's/maybedouble/simple/' arch_config/.bashrc
        if $VIRTUALBOX; then
            info "  setting virtualbox up."
            sed -i '\$iVBoxClient-all' arch_config/.xinitrc
        fi
        info "  changing wm/de."
        sed -i 's/i3/startxfce4/' arch_config/.xinitrc
        info "  changing keylayout."
        sed -i 's/gb,de/de/' arch_config/10-keyboard.conf
        sed -i 's/extd,nodeadkeys/deadacute/' arch_config/10-keyboard.conf
        sed -i '/grp:alt_space_toggle,/d' arch_config/10-keyboard.conf
        info "  removing clutter."
        sed -i '/transset-df/d' arch_config/.bashrc
        sed -i '/gpg/d' arch_config/.bashrc
        sed -i 's/qutebrowser/firefox/' arch_config/.bash_profile
        sed -i 's/^#type/type/' arch_config/.bash_profile
        sed -i 's/^#\(\[\[[^U]\+U\)/\1/' arch_config/.bash_profile
        sed -i '/SSH/d' arch_config/.bash_profile
        info "  bootstrapping."
        ./arch_config/dotextract.sh

        info Optimize makepkg.
        sudo sed -i 's/.pkg.tar.xz/.pkg.tar/' /etc/makepkg.conf

        info Adjusting terminal font.
        mkdir -p .config/xfce4/terminal/
        echo '[Configuration]
        FontName=DejaVu Sans Mono 11' > .config/xfce4/terminal/terminalrc
        # TODO adjust to Arc Theme

        info AUR.
        # required...
        gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
        ./arch_config/aur -si --noconfirm ${AUR[@]}

        info AUR-Packages.
        $AUR_INSTALLER ${AUR_INSTALL[@]}

        info Adding git stub.
        echo "[user]
        name = $USER
        email = $USER@host" > .config/git/user

        info Adding setup script.
        echo "#!/usr/bin/env sh
        ssh-keygen -t ed25519 -C \\\\\$(hostname) -f ~/.ssh/id_ed25519
        echo Copy the following to Gitlab.
        cat ~/.ssh/id_ed25519.pub" > key.install
        chmod +x key.install

        info Adding docker install script.
        echo "#!/usr/bin/env sh
        sudo pacman --needed --noconfirm -S docker
        sudo systemctl enable docker
        sudo gpasswd -a \\\\\$(whoami) docker
        reboot" > docker.install
        chmod +x docker.install

        info Adding latex install script.
        echo "#!/usr/bin/env sh
        sudo pacman --needed --noconfirm -S texlive-most" > latex.install
        chmod +x latex.install

        info Bro.
        echo "#!/usr/bin/env sh
        sudo pacman -S --needed --noconfirm libpcap cmake swig bind python python2
        pacaur -S --needed --noedit --noconfirm actor-framework
        git clone --recursive https://github.com/bro/bro
        cd bro
        git checkout topic/mfischer/deep-cluster
        git submodule update
        cd aux/broker
        git checkout topic/mfischer/broker-multihop
        git submodule update
        cd ../broctl
        git checkout topic/mfischer/broctl-broker
        git submodule update
        cd ../..
        ./configure --with-python=/usr/bin/python2
        make
        sudo make install" > bro.install
        chmod +x bro.install
SU
CMD

info Restarting.
# TODO recursive unmount!
unmount /mnt
reboot
