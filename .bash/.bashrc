source '/usr/share/doc/git-1.8.1.4/contrib/completion/git-completion.bash'

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# This function implements a user-definited git_ps1() .
#
# Wherever you put this in your PS1, it will display:
# (branchName)   when in a git repo
# (branchName:U) when in a git repo with untracked changes.
# (branchName:S[-]) when in a git repo with unstaged changes.
# (branchName:S[+]) when in a git repo with staged (uncommitted)
#     changes.
# (branchName:S[+-]) when in a git repo with the previous two points.
# (branchName:U|S[+-]) when in a git repo where any/all of the
#     aforementioned statuses apply.
 
__local_git_ps1 ()
{
    local status=$(git status 2>/dev/null)

    local staged='Changes to be committed'
    local unstaged='Changes not staged for commit'
    local untracked='Untracked files'
    
    if [[ "$status" == *$untracked* ]]
    then
        git_state=$git_state"U"
    fi

    if [[ "$status" == *$staged* || "$status" == *$unstaged* ]]
    then

        if [[ ! -z $git_state ]]
        then
            git_state=$git_state"|"
        fi

        git_state=$git_state"S){"

        if [[ "$status" == *$staged* ]]
        then
            git_state=$git_state"+"
        fi
        if [[ "$status" == *$unstaged* ]]
        then
            git_state=$git_state"-"
        fi

        git_state=$git_state"}"
    fi

    if [[ ! -z "$git_state" ]]
    then
        git_state=":"$git_state
    fi

    local b="$(git symbolic-ref HEAD 2>/dev/null)"
    if [ -n "$b" ]; then
        printf '%s%s' "(${b##refs/heads/}" "${git_state})"
    else
        printf ""
    fi
}

__local_git_ps1_color ()
{
    local status=$(git status 2>/dev/null)

    local staged='Changes to be committed'
    local unstaged='Changes not staged for commit'
    local untracked='Untracked files'
    local unmerged='Unmerged paths'

    if [[ "$status" == *$untracked* ]]
    then
        git_state=$git_state"$(tput setaf 4)U"
    fi

    if [[ "$status" == *$unmerged* ]]
    then
        if [[ ! -z $git_state ]]
        then
            git_state=$git_state"$(tput setaf 7)|"
        fi

        git_state=$git_state"$(tput setaf 1)!"
    fi

    if [[ "$status" == *$staged* || "$status" == *$unstaged* ]]
    then

        if [[ ! -z $git_state ]]
        then
            git_state=$git_state"$(tput setaf 7)|"
        fi

        git_state=$git_state"$(tput setaf 4)S$(tput setaf 7){"

        if [[ "$status" == *$staged* ]]
        then
            git_state=$git_state"$(tput setaf 2)+"
        fi
        if [[ "$status" == *$unstaged* ]]
        then
            git_state=$git_state"$(tput setaf 1)-"
        fi

        git_state=$git_state"$(tput setaf 7)}"
    fi

    if [[ ! -z "$git_state" ]]
    then
        git_state=":"$git_state
    fi

    local b="$(git symbolic-ref HEAD 2>/dev/null)"
    if [ -n "$b" ]; then
        printf '%s%s' "$(tput setaf 3)(${b##refs/heads/}" "${git_state}$(tput setaf 3))"
    else
        printf ""
    fi
}

# This is my prompt.
# I use a color-prompt that looks like this:
#
# $ aaron-brown [12:80 PM] ~/projects/python_training
# (28) -> 
#
# If you want this, you will need to set force-color=true somewhere
# in your .bashrc .

if [ "$color_prompt" = yes ]; then
# Custom bash prompt via kirsle.net/wizards/ps1.html
    PS1='\[$(tput bold)\]\[$(tput setaf 2)\]\\$ \u \[$(tput setaf 5)\][\@] \[$(tput setaf 6)\]\w $(__local_git_ps1_color)\n\[$(tput setaf 7)\](\#) -> \[$(tput sgr0)\]'
else
    PS1='\\$ \u [\@] \w $(__local_git_ps1)\n(\#) -> '
fi
export PS1

# Use .bash/ directory structure to import my files.

if [ -f ~/.bash/aliases.bash ]; then
    . ~/.bash/aliases.bash
fi

if [ -f ~/.bash/aliases.bash ]; then
    . ~/.bash/env.bash
fi

# According to GVM this has to be last.
if [ -f ~/.bash/gvm.bash ]; then
    . ~/.bash/gvm.bash
fi
