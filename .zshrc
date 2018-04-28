# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Who doesn't want home and end to work?
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

export GOPATH=$HOME/Documents/golang
export PATH=$PATH:"$(go env GOPATH)/bin":$HOME/.jenv/bin

eval "$(jenv init -)"

function lackerman {
	cd $GOPATH/src/github.com/lackerman
}


# Docker shorthands
alias dang='docker rmi $(docker images --quiet --filter "dangling=true")'

alias dim='docker images'
alias dimr='docker rmi'
alias dimra='docker rmi $(docker images -q)'

alias dps='docker ps -a'
alias drm='docker rm'
alias drma='docker rm $(docker ps -a -q)'

alias dc='docker-compose'
