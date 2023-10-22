#
# Aliases
#

# general
alias l='ls -1A'
alias ll='ls -lh'
alias la='ls -lAh'
alias type='type -a'
alias sudo='sudo '
alias ip='ip -color=auto'
alias rg='rg --smart-case --hidden --no-ignore --no-config --heading --follow \
	--context-separator="-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --"'
alias fd='fd --hidden --no-ignore'
alias rsync='rsync --progress'
alias rc="sed 's/\x1b\[[0-9;]*m//g'" # [r]emove [c]olor
alias clear='clear -x'
alias bat='bat --paging=never --theme="OneHalfDark" --style=header'
alias cat='bat --paging=never --theme="OneHalfDark" --plain'
alias red='rg --passthru --color=always --colors "match:fg:red"'
alias green='rg --passthru --color=always --colors "match:fg:green"'
alias blue='rg --passthru --color=always --colors "match:fg:blue"'
alias vimdiff='nvim -d'
alias cmdforeach='xargs -i zsh -c'
alias .='nvim'
alias open='xdg-open'
alias restartgraphics='nohup kwin_x11 --replace &'

# work
alias K='kubectl'
alias kuc='kubectl config use-context'
alias kcc='kubectl config current-context'
alias gho='gh browse'

if command -v nvim &> /dev/null; then
	alias vim=nvim # Use `\vim` or `command vim` to get the real vim.
fi

if command -v curlie &> /dev/null; then
	alias curl=curlie
fi

#
# Bindings
#

bindkey -M emacs '\C-]' vi-match-bracket

bindkey -M emacs '\C-H' backward-char
bindkey -M emacs '\C-L' forward-char

#
# Miscellaneous
#

# Serves a directory via HTTP.
if (( $+commands[python3] )); then
  alias serve='python3 -m http.server'
else
  alias serve='python -m SimpleHTTPServer'
fi
