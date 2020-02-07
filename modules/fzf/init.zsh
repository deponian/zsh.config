#
# Fuzzy file finder module for prezto
#
# Authors:
#   Greg Anders <greg.p.anders@gmail.com>
#

if (( ! $+commands[fzf] )); then
  return 1
fi

if zstyle -t ':prezto:module:fzf' key-bindings; then
  source "${0:h}/external/key-bindings.zsh"
fi

if zstyle -t ':prezto:module:fzf' completion; then
  [[ $- == *i* ]] && source "${0:h}/external/completion.zsh" 2>/dev/null
fi

export FZF_DEFAULT_OPTS=""

# Set height of fzf results
zstyle -s ':prezto:module:fzf' height FZF_HEIGHT

# Set width of fzf preview window
zstyle -s ':prezto:module:fzf' width FZF_WIDTH

# Open fzf in a tmux pane if using tmux
if zstyle -t ':prezto:module:fzf' tmux && [ -n "$TMUX_PANE" ]; then
  export FZF_TMUX=1
  export FZF_TMUX_HEIGHT=${FZF_HEIGHT:-40%}
  alias fzf="fzf-tmux -d${FZF_TMUX_HEIGHT}"
else
  export FZF_TMUX=0
  if [ ! -z "$FZF_HEIGHT" ]; then
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --height ${FZF_HEIGHT} --reverse"
  fi
fi

# Use fd or ripgrep if available
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --color=always --exclude .git"
  _fzf_compgen_path() {
    fd --type file --follow --hidden --exclude .git "$1"
  }
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND="rg --files"
  _fzf_compgen_path() {
    rg --files "$1"
  }
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Uncomment to use --inline-info option
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --inline-info --ansi --tabstop=4"

# Set colors defined by user
source "${0:h}/external/colors.zsh"
zstyle -s ':prezto:module:fzf' colorscheme FZF_COLOR
if [[ ! -z "$FZF_COLOR" && ${fzf_colors["$FZF_COLOR"]} ]]; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color ${fzf_colors["$FZF_COLOR"]}"
fi

# Use preview window with Ctrl-T
export FZF_CTRL_T_OPTS="--preview-window=${FZF_WIDTH} --preview '(bat --tabs 2 --color=always --style=header,grid --line-range :300 {} || cat {} | head -300) 2> /dev/null'"

# If tree command is installed, show directory contents in preview pane when
# using ALT-C
if (( $+commands[exa] )); then
  export FZF_ALT_C_OPTS="--preview 'exa --color=always -L 1 -T {} | head -300'"
else
  if (( $+commands[tree] )); then
    export FZF_ALT_C_OPTS="--preview 'tree -L 1 -C {} | head -300'"
  fi
fi

