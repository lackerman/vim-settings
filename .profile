source $HOME/.dotfiles/.alias

function _update_ps1() {
    PS1="$($HOME/.dotfiles/bin/powerline-go -newline -error $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

