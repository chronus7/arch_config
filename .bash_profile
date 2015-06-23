#
# ~/.bash_profile
#

# LED-Locks
# seem only to work on tty, not in xterm...
setleds -D +num -caps -scroll &> /dev/null

# Shell-options
shopt extglob &> /dev/null

# Variables
export EDITOR=vim
export TERM=xterm
export DISPLAY=:0.0
 # v= does this work? =v
export BROWSER=qutebrowser

# SSH-Agent
type ssh-agent &> /dev/null
[[ $? -eq 0 ]] && [[ -z "$(pidof ssh-agent)" ]] && eval $(ssh-agent -s)

# .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start X, if not already running
[ -z "$(pidof xinit)" ] && startx
