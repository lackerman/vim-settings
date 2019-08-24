#!/bin/sh

function setup_bash {
    tee -a $HOME/.bashrc <EOF
source \$HOME/.dotfiles/shell/profile
source \$HOME/.dotfiles/shell/bash/autocomplete
source \$HOME/.dotfiles/shell/bash/ps1
EOF
}

function setup_zsh {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/jocelynmallon/zshmarks.git ${ZSH_CUSTOM}/plugins/zshmarks
    tee -a $HOME/.zshrc <EOF
source \$HOME/.dotfiles/shell/profile
source \$HOME/.dotfiles/shell/zsh/aliases
EOF
}

[[ -z "$1" ]] && echo "provide specify your preferred shell: 'zsh' or 'bash'" && exit 1

# Remove any previous config
[[ -f $HOME/.profile ]]     && rm $HOME/.profile
[[ -f $HOME/.bashrc ]]      && rm $HOME/.bashrc
[[ -f $HOME/.zshrc ]]       && rm $HOME/.zshrc
[[ -f $HOME/.vimrc ]]       && rm $HOME/.vimrc
[[ -f $HOME/.tmux.conf ]]   && rm $HOME/.tmux.conf
[[ -f $HOME/.vim ]]         && rm -r $HOME/.vim

case $1 in
"bash")
    setup_bash;;
"zsh")
    setup_zsh;;
*)
esac

# link vim & tmux config
ln -s $HOME/.dotfiles/.vim $HOME/.vim
ln -s $HOME/.dotfiles/.vimrc $HOME/.vimrc
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf

# download tmux theme
git clone https://github.com/jimeh/tmux-themepack.git $HOME/.dotfiles/3rdparty/tmux-themepack

# install the preferred macOS utilities and devtools
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install ansible node sbt scala vim git \
        shellcheck kubernetes-cli maven go ruby rbenv \
        jq openssl watch bash-completion kubectx p7zip \
        htop rename fzf tree the_silver_searcher tmux nmap

    brew tap beeftornado/rmtree
fi

# add the specific gitconfig config if does not exist
cat $HOME/.gitconfig | grep "[filter" || tee -a $HOME/.gitconfig <<EOF
[filter "lfs"]
	clean = git lfs clean %f
	smudge = git lfs smudge %f
	required = true
[core]
	autocrlf = input
	editor = vim
[alias]
	hist = log --graph --color=always --pretty='[%C(cyan)%h%Creset]%C(bold cyan)%d%Creset %s' --all
	co = checkout
	branches = for-each-ref --sort=-committerdate refs/heads/
[color]
	ui = auto
[push]
	default = upstream
EOF
