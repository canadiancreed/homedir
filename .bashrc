# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

[ ! -e ~/.ssh ] && install -d -m 700 ~/.ssh
[ -e ~/.ssh ] && chmod 700 ~/.ssh
grep -q "HashKnownHosts" ~/.ssh/config || printf -- "HashKnownHosts no\n" >> ~/.ssh/config

for i in ~/.vim/backups ~/.vim/swaps ~/.vim/undo; do
    [ ! -d $i ] && mkdir -p $i
done

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Custom exports
[ -f ~/.bash_exports ] && . ~/.bash_exports

# Custom PS1 PS2 prompt
[ -f ~/.bash_prompt ] && . ~/.bash_prompt

# Custom PATH
[ -f ~/.bash_path ] && . ~/.bash_path

# Custom completion
[ -f ~/.bash_completion ] && . ~/.bash_completion

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
fi
