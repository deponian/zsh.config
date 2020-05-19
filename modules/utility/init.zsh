#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Load dependencies.
pmodload 'helper' 'spectrum'

#
# Aliases
#

# Define general aliases.
alias _='sudo'
alias b='${(z)BROWSER}'

alias diffu="diff --unified"
alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias p='${(z)PAGER}'
alias po='popd'
alias pu='pushd'
alias sa='alias | grep -i'
alias type='type -a'

if zstyle -T ':prezto:module:utility' safe-ops; then
  alias rm="${aliases[rm]:-rm} -i"
  alias mv="${aliases[mv]:-mv} -i"
  alias cp="${aliases[cp]:-cp} -i"
  alias ln="${aliases[ln]:-ln} -i"
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

# Lists human readable sizes, recursively, sort by modification time.
if (( $+commands[fd] )); then
  alias lr='fd -tf -x stat -c "%y %n" {} | sort'
else
  alias lr='find . -type f -exec stat -c "%y %n" '{}' \; | sort'
fi

# Grep
if zstyle -t ':prezto:module:utility:grep' color; then
  export GREP_COLOR='37;45'           # BSD.
  export GREP_COLORS="mt=$GREP_COLOR" # GNU.

  alias grep="${aliases[grep]:-grep} --color=auto"
fi

# macOS Everywhere
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
elif [[ "$OSTYPE" == cygwin* ]]; then
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
else
  alias o='xdg-open'

  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

# File Download
if (( $+commands[curl] )); then
  alias get='wget --continue --progress=bar --timestamping'
elif (( $+commands[wget] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi

# Resource Usage
alias df='df -kh'
alias du='du -kh'

if [[ "$OSTYPE" == (darwin*|*bsd*) ]]; then
  alias topc='top -o cpu'
  alias topm='top -o vsize'
else
  alias topc='top -o %CPU'
  alias topm='top -o %MEM'
fi

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

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pushes an entry onto the directory stack and lists its contents.
function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pops an entry off the directory stack and lists its contents.
function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Prints columns 1 2 3 ... n.
function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

# Finds files and executes a command on them.
function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Displays user owned processes status.
function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# Enables globbing selectively on path arguments.
# Globbing is enabled on local paths (starting in '/' and './') and disabled
# on remote paths (containing ':' but not starting in '/' and './'). This is
# useful for programs that have their own globbing for remote paths.
# Currently, this is used by default for 'rsync' and 'scp'.
# Example:
#   - Local: '*.txt', './foo:2017*.txt', '/var/*:log.txt'
#   - Remote: user@localhost:foo/
#
# NOTE: This function is buggy and is not used anywhere until we can make sure
# it's fixed. See https://github.com/sorin-ionescu/prezto/issues/1443 and
# https://github.com/sorin-ionescu/prezto/issues/1521 for more information.
function noremoteglob {
  local -a argo
  local cmd="$1"
  for arg in ${argv:2}; do case $arg in
    ( ./* ) argo+=( ${~arg} ) ;; # local relative, glob
    (  /* ) argo+=( ${~arg} ) ;; # local absolute, glob
    ( *:* ) argo+=( ${arg}  ) ;; # remote, noglob
    (  *  ) argo+=( ${~arg} ) ;; # default, glob
  esac; done
  command $cmd "${(@)argo}"
}
