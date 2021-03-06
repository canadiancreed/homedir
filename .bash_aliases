#!/usr/bin/env bash

alias g=git
alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'

# MacOs aliases
if [ -e /Users ]; then
  alias ls="ls -G"
  alias free="top -l 1 -s 0 | grep PhysMem | sed 's, (.*),,'"
  alias iftop="sudo /usr/local/sbin/iftop -nBP"
  alias zl="zfs list -oname,lused,usedds,usedchild,usedsnap,used,avail,refer,encryption,mountpoint,mounted,canmount"
  alias zll="zfs list -oname,dedup,compress,compressratio,checksum,sync,quota,copies,atime,devices,exec,rdonly,setuid,xattr,aclinherit,casesensitivity,normalization"
  alias zls="zfs list -t snap -oname,used,avail,refer"
  alias zpl="zpool list -oname,size,alloc,free,cap,dedup,health,frag,ashift,freeing,expandsz,expand,replace,readonly,altroot"
  alias zs="zpool status"
  alias zio="zpool iostat"
else
  alias ls='ls --color=auto'
  # Add an "alert" alias for long running commands.  Use like so:
  #   sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
  alias iftop="sudo /usr/sbin/iftop -nBP"
  alias dd="sudo /bin/dd status=progress"
  alias zl="sudo zfs list -oname,lused,usedds,usedchild,usedsnap,used,avail,refer,mountpoint,mounted,canmount"
  alias zll="sudo zfs list -oname,dedup,compress,compressratio,checksum,sync,quota,copies,atime,devices,exec,rdonly,setuid,xattr,acltype,aclinherit"
  alias zls="sudo zfs list -t snap -oname,used,avail,refer"
  alias zpl="sudo zpool list -oname,size,alloc,free,cap,dedup,health,frag,ashift,freeing,expandsz,expand,replace,readonly,altroot"
  alias zs="sudo zpool status"
  alias zio="sudo zpool iostat"
  whatismydhcpserver() {
    for i in $(ps aux | grep -o '[/]var/lib/NetworkManager/\S*.lease') \
      $(ps aux | grep -o '[/]var/lib/dhcp/dhclient\S*.leases'); do
      [ -f "${i}" ] && grep "dhcp-server-identifier" "${i}"
    done
  }
  copypubkey2clipboard() {
    for i in ~/.ssh/id_*.pub; do
      [ -e "${i}" ] && cat "${i}" | xsel --clipboard
    done
  }
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rsynca="rsync -viaP --exclude-from=${HOME}/.rsync_exclude"
alias rsyncc="rsync -virchlmP --exclude-from=${HOME}/.rsync_exclude"
alias rsynct="rsync -virthlmP --exclude-from=${HOME}/.rsync_exclude"

# Linux 'which' doesn't have -s so we redirect output to /dev/null
if which git >/dev/null 2>/dev/null; then
  # Use Git’s colored diff when available
  diff() {
    if [ -z "${1}" ]; then
      git diff --ignore-space-change
    elif [ -z "${2}" ]; then
      git diff --ignore-space-change "$@"
    else
      git diff --no-index --ignore-space-change "$@"
    fi
  }
fi

t() {
  tmux attach || tmux
}

firstlastline() {
  head -n1 "${1}"
  tail -n1 "${1}"
}

# Usage: json '{"foo":42}' or echo '{"foo":42}' | json
# Syntax-highlight JSON strings or files
json() {
  if [ -t 0 ]; then
    # has argument
    python -mjson.tool <<<"$*" | pygmentize -l javascript
  else
    # is piped
    python -mjson.tool | pygmentize -l javascript
  fi
}

# Usage: ppgrep bash
ppgrep() {
  pgrep "$@" | xargs --no-run-if-empty ps fp
}

d() {
  case "${1}" in
  i)
    # docker image list
    set -- docker images
    ;;
  p)
    # docker container list -a
    set -- docker ps -a
    ;;
  v)
    set -- docker volume ls
    ;;
  n)
    set -- docker network ls
    ;;
  e)
    shift
    set -- docker exec -it "${@}"
    ;;
  gca)
    # remove exited containers
    docker container prune -f
    # for i in $(docker ps -q -f status=exited); do
    #     docker rm "${i}"
    # done
    # remove untagged docker images
    docker image prune -f
    # for i in $(docker images -q -f dangling=true); do
    #     docker rmi "${i}"
    # done
    set --
    ;;
  gc)
    # remove untagged docker images
    docker image prune -f
    # for i in $(docker images -q -f dangling=true); do
    #     docker rmi "${i}"
    # done
    set --
    ;;
  *)
    set -- docker "${@}"
    ;;
  esac
  "${@}"
}

v() {
  case "${1}" in
  i)
    set -- vagrant box list
    ;;
  p)
    set -- vagrant status
    ;;
  e)
    shift
    set -- vagrant ssh -c "${@}"
    ;;
  s)
    set -- vagrant ssh
    ;;
  gc)
    set -- vagrant destroy -f
    ;;
  *)
    set -- vagrant "${@}"
    ;;
  esac
  "${@}"
}
