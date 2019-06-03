#!/bin/bash

DOTFILES=$HOME/.dotfiles
if [[ -f $HOME/.profile ]]; then
	rm $HOME/.profile
fi

ln -s ${DOTFILES}/.vim $HOME/.vim
ln -s ${DOTFILES}/.vimrc $HOME/.vimrc
ln -s ${DOTFILES}/.tmux.conf $HOME/.tmux.conf

# Setup the profile file according to the system
if [[ "$OSTYPE" == "linux"* ]]; then
	ln -s ${DOTFILES}/.profile $HOME/.bashrc
elif [[ "$OSTYPE" == "darwin"* ]]; then
	ln -s ${DOTFILES}/.profile $HOME/.profile
	brew install bash-completion
	brew install kubectx
	brew install kubernetes-cli
fi