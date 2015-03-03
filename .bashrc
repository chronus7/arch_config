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
function _root_color()
{
    if [ ${UID} -eq 0 ]; then
        echo '1'
	elif [ ${UID} -eq 1000 ]; then
        echo '2'
	else
		echo '5'
    fi
}
function _special_prompt() {
	length=0
	venv=""
	if [[ -n "$VIRTUAL_ENV" ]]; then
		venv="($(basename $VIRTUAL_ENV))"
		length=$(expr length "$venv")
	fi
	git=""
	branch=$(git branch 2>&1)
	res=$?
	if [[ $res -eq 0 ]]; then
		git="{${branch/\* /}}"
		l=$(expr length "$git")
		length=$((length + l))
	fi
	path=$(pwd)
	path=${path/$HOME/\~}
	plength=$(expr length "$path")
	length=$((plength + length))
	width=$((COLUMNS - length - 3))
	spaced=$(python -c "print(' '*$width)")
	PS1="$spaced$git$venv[\[\033[3$(_root_color)m\]$path\[\033[m\]]\r\[\033[3$(_root_color)m\]―――\[\033[m\] "
}
#PS1='[\[\e[3$(_root_color)m\]\w\e[m] '
PROMPT_COMMAND=_special_prompt
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

