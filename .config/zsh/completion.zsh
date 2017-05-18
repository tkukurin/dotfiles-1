# Completion
[ -d /usr/local/share/zsh-completions ] && fpath=(/usr/local/share/zsh-completions $fpath)
zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ${ZDOTDIR:-${HOME}}/.config/zsh/cache              # cache path

# Zstyle show completion menu if 2 or more items to select
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Format autocompletion style
zstyle ':completion:*:descriptions' format "%{$fg[green]%}%d%{$reset_color%}"
zstyle ':completion:*:corrections' format "%{$fg[orange]%}%d%{$reset_color%}"
zstyle ':completion:*:messages' format "%{$fg[red]%}%d%{$reset_color%}"
zstyle ':completion:*:warnings' format "%{$fg[red]%}%d%{$reset_color%}"
zstyle ':completion:*' format "--[ %B%F{074}%d%f%b ]--"

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

zstyle ':auto-fu:highlight' input white
zstyle ':auto-fu:highlight' completion fg=black,bold
zstyle ':auto-fu:highlight' completion/one fg=black,bold
zstyle ':auto-fu:var' postdisplay $' -azfu-'
zstyle ':auto-fu:var' track-keymap-skip opp
#zstyle ':auto-fu:var' disable magic-space

# Zstyle kill menu
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# Zstyle ssh known hosts
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/hosts,etc/ssh_,${HOME}/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Zstyle autocompletion
zstyle ':auto-fu:highlight' input bold
zstyle ':auto-fu:highlight' completion fg=black,bold
zstyle ':auto-fu:highlight' completion/one fg=white,bold,underline
zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
zstyle ':auto-fu:var' track-keymap-skip opp

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
