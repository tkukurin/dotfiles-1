umask g-w,o-rwx

# Colourfull messages
e_header()  { echo -e "\n\033[1m$@\033[0m"; }
e_success() { echo -e " \033[1;32m✔\033[0m  $@"; }
e_error()   { echo -e " \033[1;31m✖\033[0m  $@"; }
e_arrow()   { echo -e " \033[1;34m➜\033[0m  $@"; }

# Croptesting
#source ${ZDOTDIR:-${HOME}}/.config/zsh/frameworks.zsh

# Load zgen only if a user types a zgen command
zgen () {
	if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
		git clone --recursive https://github.com/tarjoilija/zgen.git ${ZDOTDIR:-${HOME}}/.zgen
	fi
	source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
	zgen "$@"
}

# Source zgen init script, generate it if needed
if [[ -s ${ZDOTDIR:-${HOME}}/.zgen/init.zsh ]]; then
	source ${ZDOTDIR:-${HOME}}/.zgen/init.zsh
else
	e_header "Creating a zgen save"
	zgen load zsh-users/zsh-autosuggestions
	zgen load bric3/nice-exit-code
	zgen load zdharma/fast-syntax-highlighting
	zgen load zsh-users/zsh-history-substring-search
	zgen oh-my-zsh plugins/shrink-path
	#zgen oh-my-zsh plugins/tmux
	zgen save
	zcompile ${ZDOTDIR:-${HOME}}/.zgen/init.zsh
fi
fpath=(/${ZDOTDIR:-${HOME}}/.config/zsh/functions $fpath)

# Load customized prompt
autoload -Uz promptinit && promptinit
prompt tuurlijk

# Set keybindings
bindkey '^w' backward-kill-word
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^k' kill-line
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "${terminfo[khome]}" beginning-of-line # Fn-Left, Home
bindkey "${terminfo[kend]}" end-of-line # Fn-Right, End

# Remove whitespace after the RPROMPT
#ZLE_RPROMPT_INDENT=0

if [ -x /usr/local/bin/gdircolors ] && [ -e ${ZDOTDIR:-${HOME}}/.dircolors ]; then
	eval "`/usr/local/bin/gdircolors -b ${ZDOTDIR:-${HOME}}/.dircolors`"
fi
if [ -x /usr/bin/dircolors ] && [ -e ${ZDOTDIR:-${HOME}}/.dircolors ]; then
	eval "`dircolors -b ~/.dircolors`"
fi

# Load secrets
if [ -e ${ZDOTDIR:-${HOME}}/.secrets.zsh ]; then
	source ${ZDOTDIR:-${HOME}}/.secrets.zsh
fi

# If command is a path, cd into it
setopt auto_cd

# Add ssh key
ssh-add -A &> /dev/null

# Load settings
if [[ ! -s ${ZDOTDIR:-${HOME}}/.config/zsh/cache/settings.zsh ]]; then
	source ${ZDOTDIR:-${HOME}}/.config/zsh/functions.zsh
	recreateCachedSettingsFile
fi
source ${ZDOTDIR:-${HOME}}/.config/zsh/cache/settings.zsh
