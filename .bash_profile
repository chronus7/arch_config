#
# ~/.bash_profile
#

# seem only to work on tty, not in xterm...
setleds -D +num -caps -scroll &> /dev/null

shopt extglob

# Variables
export EDITOR=vim
export TERM=xterm
export DISPLAY=:0.0
 # v= does this work? =v
export BROWSER=qutebrowser

type ssh-agent &> /dev/null
[[ $? -eq 0 ]] && [[ -z "$(pidof ssh-agent)" ]] && eval $(ssh-agent -s)

[[ -f ~/.bashrc ]] && . ~/.bashrc
