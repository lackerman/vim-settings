#!/bin/sh

# Default dotfiles location
DOTFILES_LOCATION="$HOME/.dotfiles"
if [ -z "$1" ]; then
    echo "provide specify your preferred shell: 'zsh' or 'bash'"
    exit 1
fi
if [ -z "$2" ]; then
    echo "using '${DOTFILES_LOCATION}' as your dotfiles location"
else
    DOTFILES_LOCATION="$2"
fi

setup_bash() {
    tee -a "$HOME/.bashrc" <<EOF
export DOTFILES_LOCATION="${DOTFILES_LOCATION}"
source \${DOTFILES_LOCATION}/shell/profile
source \${DOTFILES_LOCATION}/shell/bash/autocomplete
source \${DOTFILES_LOCATION}/shell/bash/history
source \${DOTFILES_LOCATION}/shell/bash/ps1
EOF
}

setup_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/jocelynmallon/zshmarks.git "${ZSH_CUSTOM}/plugins/zshmarks"
    tee -a "$HOME/.zshrc" <<EOF
export DOTFILES_LOCATION="${DOTFILES_LOCATION}"
source \${DOTFILES_LOCATION}/shell/profile
source \${DOTFILES_LOCATION}/shell/zsh/history
source \${DOTFILES_LOCATION}/shell/zsh/aliases
EOF
}

# Remove any previous config
[ -f "$HOME/.profile" ]     && rm "$HOME/.profile"
[ -f "$HOME/.bashrc" ]      && rm "$HOME/.bashrc"
[ -f "$HOME/.zshrc" ]       && rm "$HOME/.zshrc"
[ -f "$HOME/.vimrc" ]       && rm "$HOME/.vimrc"
[ -f "$HOME/.tmux".conf ]   && rm "$HOME/.tmux.conf"
[ -f "$HOME/.vim" ]         && rm -r "$HOME/.vim"

case $1 in
"bash")
    setup_bash;;
"zsh")
    setup_zsh;;
*)
esac

# link vim & tmux config
ln -s "${DOTFILES_LOCATION}/.vim" "$HOME/.vim"
ln -s "${DOTFILES_LOCATION}/.vimrc" "$HOME/.vimrc"
ln -s "${DOTFILES_LOCATION}/.tmux.conf" "$HOME/.tmux.conf"

# install the preferred macOS utilities and devtools
if [ "$(uname)" = 'Darwin' ]; then
    brew install ansible node sbt scala vim git \
        shellcheck kubernetes-cli maven go ruby rbenv \
        jq openssl watch bash-completion kubectx p7zip \
        htop rename fzf tree the_silver_searcher tmux nmap

    brew tap beeftornado/rmtree
fi

# add the specific gitconfig config if does not exist
grep "\[filter" "$HOME/.gitconfig" || tee -a "$HOME/.gitconfig" <<EOF
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
