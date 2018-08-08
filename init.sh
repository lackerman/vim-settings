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
	wget -O $dotfiles/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.11.0/powerline-go-linux-amd64
	ln -s $dotfiles/.profile $HOME/.bashrc
elif [[ "$OSTYPE" == "darwin"* ]]; then
	wget -O $dotfiles/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.11.0/powerline-go-darwin-amd64
	ln -s $dotfiles/.profile $HOME/.profile
fi
chmod +x $dotfiles/bin/powerline-go