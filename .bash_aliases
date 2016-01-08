#
# ~/.bash_aliases
#

# -- general --
alias ls='ls --color=auto'
alias lsl='ls -lAhv --color=auto'   # listed + hidden
alias ll='ls -lhv --color=auto'     # listed
alias la='ls -lAhv --color=auto'    # listed + hidden
alias cdp='cd -P'   # follow symlink
alias fuck='sudo $(history -p \!\!)'
alias rcp='rsync --recursive -P'    # recursive copy
alias dir='watch --color -n1 tree -L 2 -C -F'      # shadows dir (which seems equal to ls)
alias wgit='watch --color -n5 "git status; python -c \"print(\\\"-\\\"*int(\\\"$(stty size)\\\".split()[1]))\"; git ls --all --date-order"'

# -- configs --
alias vi3='vim ~/.i3/config'
alias vbc='vim ~/.bashrc'
alias vba='vim ~/.bash_aliases'
alias vbm='vim ~/coding/misc/startpage/bookmarks.js'
alias vib='vim ~/coding/misc/statusbar/bar.sh'
alias vrc='vim ~/.vimrc'

# -- system --
alias aur='yaourt'
alias runs='ps -ef | grep -v grep | grep'
alias update='sudo pacman -Syu && yaourt -Syua'
alias myip='curl icanhazip.com'
alias nspawn='sudo systemd-nspawn -bD'
alias mntfat='sudo mount -t vfat -o rw,uid=$UID,gid=users'
alias mntntfs='sudo mount -t ntfs-3g -o permissions'
function mntsmb() { sudo mount -t cifs //DAVETOWER/$1 /mnt/samba -o user=Dave,uid=$UID,gid=$UID; }
function fsof() { sudo file -s $1 | awk -v RS=',' -F';' '/ (FAT|NTFS)/{ print $NF }'; }

# -- python --
alias pu='pip install -U $(pip list | cut -d" " -f1)'
function pyenv() { . "${1:-env}/bin/activate"; }

# -- programs --
alias xt='xterm -e bash &'
alias lmk='latexmk -time -pvc -pdf -new-viewer- -view=pdf -output-directory=tex_output -recorder'
function pdf() { mupdf "$@" & }
function continuous() { while :; do timeout $1 ${*:3}; echo -e "\e[31m$(date +%H:%M:%S) >>>\e[m"; sleep $2; done; }
function spell() { hunspell -a -m -d ${1:-"en_GB"} "${2:-$1}" | grep "&"; }
function spellde() { spell "de_DE" $@; }

# -- find --
alias f='find . -iname'
alias fr='find . -regex'
function fstr() { find . -type f -exec grep -n --color=always -E "$1" {} +; }
#function pdfgrep() { for i in *.pdf; do echo "# -- FILE: $i"; pdftotext "$i" - | grep "$@"; done; }
function pdfgrep() { for i in ${@:3}; do pdftotext "$i" - | awk "BEGIN{page=1}//{page+=1}/${1}/{ printf \"\033[33m%s\033[m[\033[32m%3d\033[m] %s\n\", \"$i\", page, \$0 }" | grep "${1}" --color; done; }

# -- highlighting --
function hless() { [[ -n "$2" ]] && option="-S $2"; highlight -O ANSI $option "$1" | less -R; }
function hcat() { [[ -n "$2" ]] && option="-S $2"; highlight -O ANSI $option "$1"; }
function md() { pandoc -s -f markdown -t man "$*" | man -l -; }
