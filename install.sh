#!/bin/zsh

THEME="$1"

if [[ -z "$THEME" ]]
then
    echo "You have to specify theme name. Choose one of these: user, root, server"
    exit
fi

git clone --recursive https://github.com/deponian/zsh.config.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Change theme
NEW_THEME_LINE="zstyle ':prezto:module:prompt' theme '$THEME'"
LINENO=`awk "/zstyle ':prezto:module:prompt' theme/ {print FNR}" "${ZDOTDIR:-$HOME}/.zpreztorc"`
sed -i "${LINENO}s/.*/${NEW_THEME_LINE}/" "${ZDOTDIR:-$HOME}/.zpreztorc"

# Set default shell
chsh -s /usr/bin/zsh
