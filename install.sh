#!/bin/bash

set -e
set -u

# git clone sitoite ne

mkdir -p ~/.zsh

ln -fsv ~/.dotfiles/src/.zsh/.zshrc	~/.zsh/.zshrc
ln -fsv ~/.dotfiles/src/.zshenv		~/.zshenv
