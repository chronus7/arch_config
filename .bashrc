#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -n "$XTERM_VERSION" ] && transset-df -a 0.75 > /dev/null

alias ls='ls --color=auto'
alias lsl='ls -lAhv --color=auto'
alias xt='xterm &'

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

