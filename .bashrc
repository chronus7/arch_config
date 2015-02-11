#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -n "$XTERM_VERSION" ] && transset-df -a 0.75 > /dev/null

alias cdp='cd -P'
alias ls='ls --color=auto'
alias lsl='ls -lAhv --color=auto'
alias aur='yaourt'
alias vi3='vim ~/.i3/config'
alias xt='xterm &'
alias f='find . -iname'
alias runs='ps -ef | grep -v grep | grep'
alias pu="pip install -U \$(pip list | awk '{print \$1}')"
alias myip='echo $(curl -s http://myip.dnsomatic.com 2> /dev/null)'
alias fuck='sudo $(history -p \!\!)'

# ---
# spelling
# ---
function spell()
{
	dict="en_GB"
	file="$1"
	if [[ "$1" == "-d" ]]; then
		dict="$2"
		file="$3"
	fi
	hunspell -a -m -d $dict "$file" | grep "&"
}
alias spellde='spell -d de_DE'

# ---
# continuous
# ---
function continuous()
{
	# arg1: timeout
	# arg2: sleep-time
	# arg*: command
	while :
	do
		timeout $1 ${*:3}
		echo -e "\e[31m >>>\e[m"
		sleep $2
	done
}

# ---
# prompt
# ---
#PS1='[\u@\h \W]\$ '
function _root_color()
{
    if [ ${UID} -eq 0 ]; then
        echo '1'
    else
        echo '2'
    fi
}
PS1='[\[\e[3$(_root_color)m\]\w\e[m] '
PS2='... '

# ---
# man
# ---
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

