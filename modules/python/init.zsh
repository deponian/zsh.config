#
# Enables local Python package installation.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Sebastian Wiesner <lunaryorn@googlemail.com>
#   Patrick Bos <egpbos@gmail.com>
#

# Load manually installed pyenv into the path
if [[ -s "${PYENV_ROOT:=$HOME/.pyenv}/bin/pyenv" ]]; then
  path=("${PYENV_ROOT}/bin" $path)
  eval "$(pyenv init - --no-rehash zsh)"
# Load pyenv into the current python session
elif (( $+commands[pyenv] )); then
  eval "$(pyenv init - --no-rehash zsh)"
else
  return 1
fi
