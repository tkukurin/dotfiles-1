# Colourfull messages
e_header()  { echo -e "\n\033[1m$@\033[0m"; }
e_success() { echo -e " \033[1;32m✔\033[0m  $@"; }
e_error()   { echo -e " \033[1;31m✖\033[0m  $@"; }
e_arrow()   { echo -e " \033[1;34m➜\033[0m  $@"; }

# Profiling method 1
#zmodload zsh/zprof

# Profiling method 2
#zmodload zsh/datetime
#setopt promptsubst
#PS4='+$EPOCHREALTIME %N:%i> '
#exec 3>&2 2>/tmp/zshstart.$$.log
#setopt xtrace prompt_subst

FRAMEWORK="zplugin"   # 0.14
FRAMEWORK="oh-my-zsh" # 0.37
FRAMEWORK="zpm"       # 0.30
FRAMEWORK="zeesh"     # 0.08
FRAMEWORK="zulu"      # 0.39
FRAMEWORK="antigen"   # seconds!
FRAMEWORK="zprezto"   # 0.04
FRAMEWORK="zim"       # 0.03
FRAMEWORK="zplug"     # 0.09
FRAMEWORK="zgen"      # 0.03

# Initialise plugin manager
if [[ "$FRAMEWORK" = "antigen" ]] && [[ -s ${ZDOTDIR:-${HOME}}/.antigen/antigen.zsh ]]; then
	source ${ZDOTDIR:-${HOME}}/.antigen/antigen.zsh
	antigen bundle git
	antigen bundle zsh-users/zsh-autosuggestions
	antigen bundle zdharma/fast-syntax-highlighting
	antigen bundle zsh-users/zsh-history-substring-search
	antigen apply
fi

if [[ "$FRAMEWORK" = "zulu" ]] && [[ -s ${ZDOTDIR:-${HOME}}/.zulu/core/zulu ]]; then
	source "${ZULU_DIR:-"${ZDOTDIR:-$HOME}/.zulu"}/core/zulu"
	zulu init
fi

if [[ "$FRAMEWORK" = "oh-my-zsh" ]] && [[ -s ${ZDOTDIR:-${HOME}}/.oh-my-zsh/oh-my-zsh.sh ]]; then
	plugins=(
	git
	fasd
	osx
	zsh-autosuggestions
	)

	export ZSH=$HOME/.oh-my-zsh
	source $ZSH/oh-my-zsh.sh
fi

if [[ "$FRAMEWORK" = "zim" ]] && [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
	source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

if [[ "$FRAMEWORK" = "zeesh" ]] && [[ -s ${ZDOTDIR:-${HOME}}/.zsh/zeesh.zsh ]]; then
	zeesh_plugins=(
	autocomplete
	git
	vcs-info
	syntax-highlighting
	history-substring-search
	)

	source ${ZDOTDIR:-${HOME}}/.zsh/zeesh.zsh
fi

if [[ "$FRAMEWORK" = "zgen" ]]; then
	if [[ -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
		source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
	else
		git clone --recursive https://github.com/tarjoilija/zgen.git ${ZDOTDIR:-${HOME}}/.zgen
		source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
	fi
	# if the init scipt doesn't exist
	if ! zgen saved; then
		e_header "Creating a zgen save"

		# plugins
		zgen load zsh-users/zsh-autosuggestions
		zgen load bric3/nice-exit-code
		zgen load zdharma/fast-syntax-highlighting
		zgen load zsh-users/zsh-history-substring-search
		zgen oh-my-zsh plugins/shrink-path
		#zgen oh-my-zsh plugins/tmux
		# save all to init script
		zgen save
	fi
	fpath=(/${ZDOTDIR:-${HOME}}/.config/zsh/functions $fpath)
fi

if [[ "$FRAMEWORK" = "zplug" ]]; then
	if [[ -s ${ZDOTDIR:-${HOME}}/.zplug/init.zsh ]]; then
		source ${ZDOTDIR:-${HOME}}/.zplug/init.zsh
	else
		git clone --recursive https://github.com/zplug/zplug.git ${ZDOTDIR:-${HOME}}/.zplug
		source ${ZDOTDIR:-${HOME}}/.zplug/init.zsh
	fi
	# if the init scipt doesn't exist
	zplug zsh-users/zsh-autosuggestions
	zplug bric3/nice-exit-code
	zplug zdharma/fast-syntax-highlighting
	zplug zsh-users/zsh-history-substring-search
	zplug plugins/shrink-path, from:oh-my-zsh
	fpath=(/${ZDOTDIR:-${HOME}}/.config/zsh/functions $fpath)
fi

if [[ "$FRAMEWORK" = "zplugin" ]] && [[ -s ${ZDOTDIR:-${HOME}}/.zplugin/zplugin.zsh ]]; then
	source "$HOME/.zplugin/zplugin.zsh"
	zplugin load zsh-users/zsh-autosuggestions
	zplugin load zdharma/fast-syntax-highlighting
	zplugin snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/git/git.plugin.zsh'
	zplugin load mafredri/zsh-async
	zplugin cdclear -q # <- forget completions provided up to this moment
	autoload -Uz compinit
	compinit -u

	zplugin cdreplay -q # -q is for quiet
fi

if [[ "$FRAMEWORK" = "zprezto" ]] && [[ -s ${ZDOTDIR:-${HOME}}/.zprezto/init.zsh ]]; then
	# Edit ~/.zpreztorc
	source "$HOME/.zprezto/init.zsh"
fi

if [[ "$FRAMEWORK" = "zpm" ]] then
	if [[ -f ~/.zpm/zpm.zsh ]]; then
		source ~/.zpm/zpm.zsh
	else
		git clone --recursive https://github.com/horosgrisa/zpm ~/.zpm
		source ~/.zpm/zpm.zsh
	fi
fi

# Load customized prompt
autoload -Uz promptinit && promptinit
prompt tuurlijk

# Use emacs keybindings so we can use <C-a> to go to the beginning of a line
#bindkey -e
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

umask g-w,o-rwx

# Remove whitespace after the RPROMPT
#ZLE_RPROMPT_INDENT=0

if [ -x /usr/local/bin/gdircolors ] && [ -e ${ZDOTDIR:-${HOME}}/.dircolors ]; then
	eval "`/usr/local/bin/gdircolors -b ${ZDOTDIR:-${HOME}}/.dircolors`"
fi
if [ -x /usr/bin/dircolors ] && [ -e ${ZDOTDIR:-${HOME}}/.dircolors ]; then
	eval "`dircolors -b ~/.dircolors`"
fi

# Secrets
if [ -e ${ZDOTDIR:-${HOME}}/.secrets.zsh ]; then
	source ${ZDOTDIR:-${HOME}}/.secrets.zsh
fi

# Load settings
setopt EXTENDED_GLOB
local ohMyGlob='(alias|completion|env|functions|style).zsh(D)'
for rcfile in ${ZDOTDIR:-${HOME}}/.config/zsh/${~ohMyGlob}; do
	source ${ZDOTDIR:-${HOME}}/.config/zsh/${rcfile:t}
done
unset ohMyGlob

# if command is a path, cd into it
setopt auto_cd

ssh-add -A &> /dev/null

# Profiling method 1
#zprof | pbcopy

# Profiling method 2
#unsetopt xtrace
#exec 2>&3 3>&-
