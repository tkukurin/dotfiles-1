bindkey '^w' backward-kill-word
bindkey '^h' backward-delete-char
autoload -Uz history-search-end
zle -N history-incremental-search-backward-end history-search-end
zle -N history-incremental-search-forward-end history-search-end
bindkey '^r' history-incremental-search-backward-end
bindkey '^s' history-incremental-search-forward-end
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^k' kill-line
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "${terminfo[khome]}" beginning-of-line # Fn-Left, Home
bindkey "${terminfo[kend]}" end-of-line # Fn-Right, End
bindkey '^[^?' backward-kill-dir