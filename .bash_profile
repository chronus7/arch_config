#
# ~/.bash_profile
#

# LED-Locks
# seem only to work on tty, not in xterm...
setleds -D +num -caps -scroll &> /dev/null

# Shell-options
shopt extglob &> /dev/null

# Beep
setterm -blength 0 &> /dev/null     # this is for the tty (for xterm is in .xinitrc)

# Variables
export EDITOR=vim
export TERM=xterm
export DISPLAY=:0.0
export BROWSER=qutebrowser

# Expand PATH by ~/scripts
[ -d ~/.scripts/ ] && PATH=${PATH}:~/.scripts/
[ -d ~/.cabal/bin/ ] && PATH=${PATH}:~/.cabal/bin/

# SSH-Agent
# -- replaced by gpg-agent
#type ssh-agent &> /dev/null
#[[ $? -eq 0 ]] && [[ -z "$(pgrep ssh-agent)" ]] && eval $(ssh-agent -s)
#[[ $? -eq 0 ]] && [[ -z "$(pgrep -U $UID ssh-agent)" ]] && eval $(ssh-agent -s)

# GPG-Agent
unset SSH_AGENT_PID
[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ] && export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"

# .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start X, if not already running
[ -z "$(pidof xinit)" ] && [ $UID != 0 ] && startx
