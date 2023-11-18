source "${0:h}/setup.zsh"

if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --no-ignore --exclude .git'
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore --glob "!.git/*"'
elif (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND='ag -l --hidden -g "" --ignore .git'
fi

# Set default fzf opts
export FZF_DEFAULT_OPTS='--info=inline:":: " --no-separator --prompt="■ " --pointer="●" --marker="›"'

# Set height of fzf results
export FZF_HEIGHT='70%'

# Set width of fzf preview window
export FZF_WIDTH='right:60%'

# Use preview window with Ctrl-T
export FZF_CTRL_T_OPTS="--preview-window=${FZF_WIDTH:-right:50%} --preview '(bat --tabs 2 --color=always --theme=base16 --style=header,grid --line-range :300 {} || cat {} | head -300) 2> /dev/null'"
# If tree command is installed, show directory contents in preview pane when use Alt-C
if (( $+commands[tree] )); then
  export FZF_ALT_C_OPTS="--preview 'tree -L 1 -C {} | head -200'"
fi

export FZF_TMUX=0
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --height ${FZF_HEIGHT}"

# Set colors defined by user
source "${0:h}/colors.zsh"
export FZF_COLOR='One Dark Deep'
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color ${fzf_colors["$FZF_COLOR"]}"
