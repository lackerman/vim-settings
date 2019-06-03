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
eval "$(rbenv init -)"

# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.bash"

#####################
# Aliases
#####################

alias vi=vim
alias ll='ls -l'

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

#####################
# Autocomplete
#####################

# Enable bash autocomplete
BREW_PREFIX=$(brew --prefix)
if [ -f ${BREW_PREFIX}/etc/bash_completion ]; then
  . ${BREW_PREFIX}/etc/bash_completion
fi

# serverless
[ -f $HOME/node_modules/tabtab/.completions/serverless.bash ] \
    && . $HOME/node_modules/tabtab/.completions/serverless.bash
# sls
[ -f $HOME/node_modules/tabtab/.completions/sls.bash ] \
    && . $HOME/node_modules/tabtab/.completions/sls.bash

# gcloud
[ -f ${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc ] \
	&& source ${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
[ -f ${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc ] \
	&& source ${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc

#####################
# PS1
#####################

# https://misc.flogisoft.com/bash/tip_colors_and_formatting

# Bold
bold='\[\e[1m\]'

# 256 Colours
# > Foreground Colours
dgfg='\[\e[38;5;239m\]'         # Dark Grey
lbfg='\[\e[38;5;32m\]'          # Light blue
ofg='\[\e[38;5;173m\]'          # Orange
# > Background Colours
dgbg='\[\e[48;5;239m\]'         # Dark Grey

# Normal colours
# > Foreground Colours
wfg='\[\e[97m\]'                # white
gfg='\[\e[92m\]'                # green
rfg='\[\e[91m\]'                # red
# > Background Colours
rbg='\[\e[41m\]'                # red

# Normal colours: With fg+bg combined
bfg_wbg='\[\e[1;34;107m\]'  # fg: blue       bg: white
dg_w='\[\e[90;107m\]'       # fg: dark grey  bg: white
r_w='\[\e[31;107m\]'        # fg: red        bg: white
lg_dg='\[\e[37;100m\]'      # fg: light grey bg: dark grey
r_dg='\[\e[31;100m\]'       # fg: red        bg: dark grey

# Stop formatting
end='\[\e[0m\]'

function context {
    [[ $(kubectl config current-context 2> /dev/null) != "" ]] && echo " ➡ $(kubectl config current-context) ⎈" || echo ""
}
function uncommitted_changes {
	[[ "$(git status 2> /dev/null)" =~ working\ tree\ clean ]] && echo "✔" || echo "✘"
}
function git_branch_nicename {
    echo $(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
}
function cbranch {
	[[ -d .git ]] && echo " ($(git_branch_nicename) $(uncommitted_changes))" || echo ""
}
function chost {
    $([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]) && echo "${rfg}☣ \h ☣${end}" || echo "${dgf} \h ${end}"
}
function ctelepresence {
    [ -n "$TELEPRESENCE_ROOT" ] && echo "${rfg}☣ TELEPRESENCE ☣${end}" || echo ""
}

export PS1="${ofg}\u@\h${end}${lbfg}${bold}\$(context)${end} [\A] ${bold}${gfg}\W${end}\$(cbranch)${gfg} $ ${end}"
