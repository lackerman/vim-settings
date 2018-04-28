#!/bin/bash

ln -s $PWD/.vim $HOME/.vim
ln -s $PWD/.vimrc $HOME/.vimrc
ln -s $PWD/.zshrc $HOME/.zshrc
ln -s $PWD/.tmux.conf $HOME/.tmux.conf

zsh

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
	ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

chsh -s /bin/zsh
