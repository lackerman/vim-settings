#!/bin/bash

wget https://github.com/justjanne/powerline-go/releases/download/v1.11.0/powerline-go-darwin-amd64 -O $HOME/.dotfiles/bin/powerline-go
chmod +x $HOME/.dotfiles/bin/powerline-go

if [[ -f $HOME/.profile ]]; then
	rm $HOME/.profile
fi

ln -s $PWD/.profile $HOME/.profile
ln -s $PWD/.vim $HOME/.vim
ln -s $PWD/.vimrc $HOME/.vimrc
ln -s $PWD/.tmux.conf $HOME/.tmux.conf