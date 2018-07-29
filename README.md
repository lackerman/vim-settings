# .dotfiles terminal settings

Clone the repository to `.dotfiles` in your `$HOME` directory and execute the init script to setup the necessary dotfiles for tmux, vim, Mac profiles and [powerline-go](https://github.com/justjanne/powerline-go).

```
git clone --recursive https://github.com/lackerman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash init.sh
```

## Setup Go development for Vim

Once you've opened vim, `vim .`, then type `:GoInstallBinaries` to install all necessary Go binaries required for Go development in Vim.

Go forth and conquer...
