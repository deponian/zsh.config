# FILE AUTOMATICALLY GENERATED FROM /home/rufus/.zimrc
# EDIT THE SOURCE FILE AND THEN RUN zimfw build. DO NOT DIRECTLY EDIT THIS FILE!

if [[ -e ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]] zimfw() { source "${HOME}/.zim/zimfw.zsh" "${@}" }
fpath=("${HOME}/.zim/deponian/git/functions" "${HOME}/.zim/modules/utility/functions" "${HOME}/.zim/deponian/utility/functions" "${HOME}/.zim/modules/zsh-completions/src" ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw aws-set-env ctc lr lu openurl sss superchroot w
source "${HOME}/.zim/modules/environment/init.zsh"
source "${HOME}/.zim/deponian/git/init.zsh"
source "${HOME}/.zim/modules/input/init.zsh"
source "${HOME}/.zim/modules/utility/init.zsh"
source "${HOME}/.zim/deponian/utility/init.zsh"
source "${HOME}/.zim/deponian/fzf/init.zsh"
source "${HOME}/.zim/modules/powerlevel10k/powerlevel10k.zsh-theme"
source "${HOME}/.zim/modules/completion/init.zsh"
source "${HOME}/.zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${HOME}/.zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "${HOME}/.zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh"
