#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Rufus Deponina <deponian@pm.me>
#

# Load dependencies.
pmodload 'helper' 'spectrum'

#
# Aliases
#

# General
alias type='type -a'
alias sudo='sudo '
alias ip='ip -color=auto'
alias sed='sed -E'
alias rg='rg --smart-case --hidden --no-ignore --no-config --heading --follow \
	--context-separator="-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --"'
alias bat='bat --paging=never --theme="OneHalfDark" --style=header'
alias fd='fd --hidden --no-ignore'
alias rsync='rsync --progress'
alias rc="sed 's/\x1b\[[0-9;]*m//g'" # [r]emove [c]olor
alias clear='clear -x'
alias cat='bat --paging=never --theme="OneHalfDark" --plain'
alias red='rg --passthru --color=always --colors "match:fg:red"'
alias green='rg --passthru --color=always --colors "match:fg:green"'
alias blue='rg --passthru --color=always --colors "match:fg:blue"'

if command -v nvim &> /dev/null; then
	alias vim=nvim # Use `\vim` or `command vim` to get the real vim.
fi

# ls
if is-callable 'dircolors'; then
  # GNU Core Utilities

  if zstyle -T ':prezto:module:utility:ls' dirs-first; then
    alias ls="${aliases[ls]:-ls} --group-directories-first"
  fi

  if zstyle -t ':prezto:module:utility:ls' color; then
    # Call dircolors to define colors if they're missing
    if [[ -z "$LS_COLORS" ]]; then
      if [[ -s "$HOME/.dir_colors" ]]; then
        eval "$(dircolors --sh "$HOME/.dir_colors")"
      else
        eval "$(dircolors --sh)"
      fi
    fi

    alias ls="${aliases[ls]:-ls} --color=auto"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
else
  # BSD Core Utilities
  if zstyle -t ':prezto:module:utility:ls' color; then
    # Define colors for BSD ls if they're not already defined
    if [[ -z "$LSCOLORS" ]]; then
      export LSCOLORS='exfxcxdxbxGxDxabagacad'
    fi

    # Define colors for the completion system if they're not already defined
    if [[ -z "$LS_COLORS" ]]; then
      export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
    fi

    alias ls="${aliases[ls]:-ls} -G"
  else
    alias ls="${aliases[ls]:-ls} -F"
  fi
fi

alias l='ls -1A'	# Lists in one column, hidden files.
alias ll='ls -lh'	# Lists human readable sizes.
alias la='ll -A'	# Lists human readable sizes, hidden files.
alias lx='ll -XB'	# Lists sorted by extension (GNU only).
alias sl='ls'		# I often screw this up.

# Grep
if zstyle -t ':prezto:module:utility:grep' color; then
  export GREP_COLOR='37;45'           # BSD.
  export GREP_COLORS="mt=$GREP_COLOR" # GNU.

  alias grep="${aliases[grep]:-grep} --color=auto"
fi

# File Download
if (( $+commands[curl] )); then
  alias get='wget --continue --progress=bar --timestamping'
elif (( $+commands[wget] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi

# Resource Usage
alias df='df -kh'
alias du='du -kh'

# Miscellaneous

# Serves a directory via HTTP.
if (( $+commands[python3] )); then
  alias serve='python3 -m http.server'
else
  alias serve='python -m SimpleHTTPServer'
fi

#
# Functions
#

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Displays user owned processes status.
function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

