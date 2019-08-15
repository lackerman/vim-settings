#!/bin/sh

source $HOME/.dotfiles/.env

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias ls='ls --color=auto'

elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'

    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

export EDITOR=vi

#####################
# Helper scripts
#####################

export PATH=$PATH:${GOPATH}/bin:$HOME/.dotfiles/scripts

#####################
# 3rdparty Tools
#####################

source $HOME/.dotfiles/3rdparty/bashmarks/bashmarks.sh

# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

#####################
# Aliases
#####################

alias vi=vim
alias ll='ls -l'
alias python=/usr/local/bin/python3
alias pip=/usr/local/bin/pip3

# Network utilities
function whoislistening {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sudo lsof -i -n -P | grep LISTEN
    else
        sudo netstat -atun
    fi
}

function ipinfo {
    public_ip="$(curl -sL http://ipecho.net/plain)"
	raw_info="$(curl -s https://ipapi.co/${public_ip}/json | \
        jq -r '[.ip, .org, .city, .region, .country_name, .country] | @csv')"
    echo ${raw_info//\"}
}

# docker utilities
alias dang='docker rmi $(docker images --quiet --filter "dangling=true")'
alias dps='docker ps -a'
alias dk='docker kill'
alias drm='docker rm'
alias drma='docker rm $(docker ps -a -q)'
alias dim='docker images'
alias dimr='docker rmi'
function dimrn {
    docker images -a | grep "$1" | awk '{print $3}' | xargs docker rmi -f
}

# kubernetes utilities
alias ka='kubectl'
alias ka='kubectl get all'
alias kd='kubectl delete'
alias kl='kubectl logs'
alias kw='kubectl get pods -w'
alias kwa='watch kubectl get all'
alias kpodip='kubectl get pods -o wide'

function kpa {
    kubectl get pods -l name=$1 -o jsonpath='{.items[0].metadata.name}'
}
function kcssh {
    kubectl exec -it $@ -- /bin/sh
}
function kssh {
    kubectl exec -it $@ --container app -- /bin/sh
}
function kctx {
	kubectl config current-context
}
function kcontainer_status {
    kubectl get -o json $@ | \
    jq --compact-output '[.status.containerStatuses[], .status.initContainerStatuses[]] | .[] | { name: .name, state: .state | keys | .[], info: .state[].reason }'
}

# Git aliases
alias gs='git status'
alias gpr='git pull --rebase'
alias gsp='git add . && git stash && git pull --rebase && git stash pop'
alias git_ls_commit_files='git diff-tree --no-commit-id --name-only -r'
alias git_submodule_update='git submodule update --recursive'

# NFS setup with Mac
# https://serverfault.com/questions/716350/mount-nfs-volume-on-ubuntu-linux-server-from-macos-client
# nfs export edit and restart

alias nfs_reload="sudo vi /etc/exports && sudo exportfs -vra"
