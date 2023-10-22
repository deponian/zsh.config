#!/bin/zsh

echo "::: Cloning repository"
git clone --recursive https://github.com/deponian/zsh.config.git "${ZDOTDIR:-$HOME}/.zim"

echo "::: Creating symlinks in home directory"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zim/runcoms/*; do
	ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo "::: Changing default shell to zsh"
until chsh -s /usr/bin/zsh; do
	echo "Wrong password."
done

