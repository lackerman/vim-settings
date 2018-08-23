#!/bin/bash

dotfiles=$HOME/.dotfiles
mkdir -p $dotfiles/bin

if [[ -f $HOME/.profile ]]; then
	rm $HOME/.profile
fi

ln -s $dotfiles/.vim $HOME/.vim
ln -s $dotfiles/.vimrc $HOME/.vimrc
ln -s $dotfiles/.tmux.conf $HOME/.tmux.conf

# Setup the profile file according to the system
if [[ "$OSTYPE" == "linux"* ]]; then
	ln -s $dotfiles/.profile $HOME/.bashrc
elif [[ "$OSTYPE" == "darwin"* ]]; then
	ln -s $dotfiles/.profile $HOME/.profile
	brew install bash-completion
	brew install kubectx
	brew install kubernetes-cli
fi