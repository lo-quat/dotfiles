#!/bin/zsh

if [ ! -L ~/.config/tmux ]; then
    ln -s ~/dotfiles/.config/tmux ~/.config/tmux
fi

if [ ! -L ~/.config/nvim ]; then
    ln -s ~/dotfiles/.config/nvim ~/.config/nvim
fi

if [ ! -L ~/.gitconfig ]; then
    ln -s ~/dotfiles/.gitconfig ~/.gitconfig
fi
