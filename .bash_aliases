#
# ~/.bash_aliases
#

# -- general --
alias ls='ls --color=auto'
alias lsl='ls -lAhv --color=auto'   # listed + hidden
alias ll='ls -lhv --color=auto'     # listed
alias la='ls -lAhv --color=auto'    # listed + hidden
alias cdp='cd -P'                   # follow symlink
alias sudo='sudo '                  # allow aliases in sudo
alias fuck='sudo $(history -p \!\!)'
alias _='$(history -p \!:0)'        # btw. $_ are the last args
alias rcp='rsync --recursive -P'    # recursive copy
alias wgit='watch --color -n5 "git status; python -c \"print(\\\"-\\\"*int(\\\"$(stty size)\\\".split()[1]))\"; git ls --all --date-order"'
alias gitst='diff -y <(find ~ -type d -name .git -execdir git st {} +) <(find ~ -type d -name .git)'
function gitlog() { for i in "$@"; do
    [ -d "$i" ] || continue
    python -c "print('\033[31;1m{:-<{}}\033[m'.format('-- $i ', $(stty size | cut -d' ' -f2)))";
    git -C "$i" log --branches --author="$(git config --get user.name)" --since="1 week ago" --format="%cd | %h | %C(yellow)%s%Creset%d" --date="format:%y-%m-%d / %Hh / %a"
done; }
function dir() { while :; do clear; date; tree -C -F "${@:2}"  -I __pycache__ "${1:-.}"; inotifywait -e modify -r "${1:-.}"; done; }

# -- configs --
alias vi3='vim ~/.config/i3/config'
alias vbc='vim ~/.bashrc'
alias vba='vim ~/.bash_aliases'
alias vbm='vim ~/coding/misc/startpage/bookmarks.js'
alias vib='vim ~/coding/shell/statusbar/bar.sh'
alias vrc='vim ~/.vimrc'

# -- system --
alias aur='pacaur'
alias runs='ps -ef | grep -v grep | grep'
alias update='sudo pacman -Syu && pacaur -Syua'
alias poweroff='[ -z "$(ps -ef | grep -v grep | grep qutebrowser)" ] && poweroff || echo -e "\033[31;1mQutebrowser still running.\033[m"'
alias reboot='[ -z "$(ps -ef | grep -v grep | grep qutebrowser)" ] && reboot || echo -e "\033[31;1mQutebrowser still running.\033[m"'
alias myip='curl icanhazip.com'
alias nspawn='sudo systemd-nspawn -bD'
alias mntfat='sudo mount -t vfat -o rw,uid=$UID,gid=users'
alias mntntfs='sudo mount -t ntfs-3g -o permissions'
function mntsmb() { sudo mount -t cifs //norloch/$1 /mnt/samba -o user=Dave,uid=$UID,gid=$UID; }
function fsof() { sudo file -s $1 | awk -v RS=',' -F';' '/ (FAT|NTFS)/{ print $NF }'; }

# -- python --
alias pu='pip install -U $(pip list --format=legacy | cut -d" " -f1)'
alias pdb='python -m pdb'
function pyenv() { . "${1:-env}/bin/activate"; }
function pyc() { python <<< "print($@)"; }

# -- programs --
alias xt='xterm -e bash &'
alias lmk='latexmk -time -pvc -pdf -new-viewer- -view=pdf -output-directory=tex_output -recorder'
alias scrot='maim'
function xtitle() { printf "]2;$*\a"; }   # set xterm title
function pdf() { mupdf "$@" & }
function continuous() { while :; do timeout $1 ${*:3}; echo -e "\e[31m$(date +%H:%M:%S) >>>\e[m"; sleep $2; done; }
function spell() { hunspell -a -m -d ${2:-"en_GB"} "${1}" | grep "&"; }
function spellde() { spell "de_DE" $@; }
#function play() { for i in $1; do ffplay -nodisp -autoexit "$i"; done }
function rplay() { for i in $(curl -L "$1" | grep "<li>" | cut -d'"' -f2); do ffplay -nodisp -autoexit <(curl -L "$1$i"); done }
alias ffmpd='ffplay http://norloch:9999'
function pass-get() { pass show $2 | grep $1 | sed "s/$1://"; }

# -- find --
alias f='find . -iname'
alias fr='find . -regex'
function fstr() { find . -type f -exec grep -n --color=always -E "$1" {} +; }
function pdfgrep() { for i in ${@:3}; do pdftotext "$i" - | awk "BEGIN{page=1}//{page+=1}/${1}/{ printf \"\033[33m%s\033[m[\033[32m%3d\033[m] %s\n\", \"$i\", page, \$0 }" | grep -i "${1}" --color; done; }

# -- highlighting --
function hless() { [[ -n "$2" ]] && option="-S $2"; highlight -O ANSI $option "$1" | less -R; }
function hcat() { [[ -n "$2" ]] && option="-S $2"; highlight -O ANSI $option "$1"; }
function md() { pandoc -s -f markdown -t man "$*" | man -l -; }
