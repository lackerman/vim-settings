source $HOME/.dotfiles/.env

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias ls='ls --color=auto'

elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'

    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

export PATH=$PATH:$GOPATH/bin:$HOME/.dotfiles/scripts

source $HOME/.dotfiles/alias
source $HOME/.dotfiles/autocomplete
source $HOME/.dotfiles/ps1
