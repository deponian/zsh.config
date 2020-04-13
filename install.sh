#!/bin/zsh

echo "::: Checking existing zprezto files"
if [[ -d "${ZDOTDIR:-$HOME}/.zprezto" ]] then
	echo "::: Removing old files. Preserving .zhistory"
	cd "${ZDOTDIR:-$HOME}"
	mv .zhistory zhistory
	rm -rf .z*
	mv zhistory .zhistory
else
	echo "::::: There are none of them."
fi

echo "::: Cloning repository"
git clone --recursive https://github.com/deponian/zsh.config.git "${ZDOTDIR:-$HOME}/.zprezto"

echo "::: Creating symlinks in home directory"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
	ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo "::: Changing default shell to zsh"
until chsh -s /usr/bin/zsh; do
	echo "Wrong password."
done

