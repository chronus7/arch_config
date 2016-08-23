#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -n "$XTERM_VERSION" ] && transset-df -a 0.75 > /dev/null

source ~/.bash_aliases

# ---
# prompt
# ---
PS1='[\[\e[37;1m\]\w\[\e[m\]] '
PS2='... '
source ~/.bash_prompt
PROMPT_COMMAND=_bprompt_maybedouble

# ---
# gpg
# ---
if [ "$UID" != "0" ]; then
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
fi

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

