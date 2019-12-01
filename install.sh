#!/bin/zsh

THEME="$1"

if [[ -z "$THEME" ]]
then
    echo "You have to specify theme name. Choose one of these: user, root, server"
    exit
fi

echo "::: Cloning repository"
git clone --recursive https://github.com/deponian/zsh.config.git "${ZDOTDIR:-$HOME}/.zprezto"

echo "::: Creating symlinks in home directory"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo "::: Changing theme"
NEW_THEME_LINE="zstyle ':prezto:module:prompt' theme '$THEME'"
LINE=`awk "/zstyle ':prezto:module:prompt' theme/ {print FNR}" "${ZDOTDIR:-$HOME}/.zpreztorc"`
sed -i "${LINE}s/.*/${NEW_THEME_LINE}/" "${ZDOTDIR:-$HOME}/.zpreztorc"

echo "::: Removing .git directory"
rm -rf "${ZDOTDIR:-$HOME}/.zprezto/.git"

echo "::: Removing install.sh"
rm "${ZDOTDIR:-$HOME}/.zprezto/install.sh"

echo "::: Changing default shell to zsh"
chsh -s /usr/bin/zsh

