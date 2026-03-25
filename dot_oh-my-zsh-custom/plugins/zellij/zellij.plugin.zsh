if (( ! $+commands[zellij] )); then
    return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `zellij`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_zellij" ]]; then
  typeset -g -A _comps
  autoload -Uz _zellij
  _comps[zellij]=_zellij
fi

# Generate and load zellij completion
zellij setup --generate-completion zsh >| "$ZSH_CACHE_DIR/completions/_zellij" &|
