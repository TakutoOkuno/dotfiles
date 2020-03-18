#!/bin/bash

set -e
set -u

mkdir -p ~/.zsh

ln -fsv ~/.dotfiles/src/.zsh/.zshrc	~/.zsh/.zshrc
ln -fsv ~/.dotfiles/src/.zshenv		~/.zshenv
ln -fsv ~/.dotfiles/src/.gitconfig	~/.gitconfig
ln -fsv ~/.dotfiles/src/.tmux.conf      ~/.tmux.conf
