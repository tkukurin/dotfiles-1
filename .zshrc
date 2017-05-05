# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
	source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

umask 002

HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000

if [ -x /usr/local/bin/gdircolors ] && [ -e ${HOME}/.dircolors ]; then
	eval "`/usr/local/bin/gdircolors -b ${HOME}/.dircolors`"
fi
if [ -x /usr/bin/dircolors ] && [ -e ${HOME}/.dircolors ]; then
	eval "`dircolors -b ~/.dircolors`"
fi

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='38;5;202'

export VAGRANT_DEFAULT_PROVIDER=vmware_fusion # https://docs.vagrantup.com/v2/providers/default.html

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;33;172m'   # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;172m' # begin underline
export LESS=-r

# Set GPG TTY
export GPG_TTY=$(tty)

# Aliases
if [ `uname` = Darwin ]; then
	alias ls='/usr/local/bin/gls --color=auto'
else
	alias ls='/bin/ls --color=auto'
fi
alias :e="\$EDITOR"
alias :q="exit"
alias l="ls -A -F"
alias ll="ls -h -l "
alias la="ls -a"
# List only directories and symbolic links that point to directories
alias lsd='ls -ld *(-/DN)'
# List only file beginning with "."
alias lsa='ls -ld .*'
alias grep="grep --color=auto"
alias know="vim ${HOME}/.ssh/known_hosts"
alias reload!=". ${HOME}/.zshrc"
alias takeover="tmux detach -a"
alias vu="vagrant up"
alias vh="vagrant halt"
alias vp="vagrant provision"
alias vr="vagrant reload"
alias vs="vagrant ssh"
alias vbu="vagrant box update"
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "$method"="lwp-request -m '$method'"
done

# Secrets
if [ -e ${HOME}/.secrets ]; then
	source ${HOME}/.secrets
fi

export EDITOR=vim
export GIT_EDITOR=vim
export VISUAL=vim
export PATH=\
${HOME}/Library/Python/2.7/bin:\
${HOME}/bin:\
${HOME}/.rvm/bin:\
${PATH}

# Set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Tmux
alias tmux="TERM=xterm-256color tmux"
alias mu="tmuxomatic ${HOME}/.tmuxomatic/work"
zstyle ':zim:tmux:autostart' loc 'yes'

zstyle ':zim:git-info' ignore-submodules 'none'

# Completion
fpath=(/usr/local/share/zsh-completions $fpath)

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

# Highlighting
if [ -e /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

	# STYLES
	# Aliases and functions
	ZSH_HIGHLIGHT_STYLES[alias]='fg=068'
	ZSH_HIGHLIGHT_STYLES[function]='fg=028'

	# Commands and builtins
	ZSH_HIGHLIGHT_STYLES[command]="fg=166"
	ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=blue"
	ZSH_HIGHLIGHT_STYLES[builtin]="fg=202"

	# Paths
	ZSH_HIGHLIGHT_STYLES[path]='fg=244'

	# Globbing
	ZSH_HIGHLIGHT_STYLES[globbing]='fg=130,bold'

	# Options and arguments
	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=124'
	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=124'

	ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=065"
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=065"
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=065"
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=065"
	ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=065"


	ZSH_HIGHLIGHT_STYLES[default]='none'
	ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
	ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=green'
	ZSH_HIGHLIGHT_STYLES[precommand]='none'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=214'
	ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue'

	ZSH_HIGHLIGHT_STYLES[assign]='none'

	# PATTERNS
	# rm -rf
	ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

	# Sudo
	ZSH_HIGHLIGHT_PATTERNS+=('sudo ' 'fg=white,bold,bg=red')
fi

ssh-add -A &> /dev/null

# Ooooh ;-)
fractal () {
	local lines columns colour a b p q i pnew
	((columns=COLUMNS-1, lines=LINES-1, colour=0))
	for ((b=-1.5; b<=1.5; b+=3.0/lines)) do
		for ((a=-2.0; a<=1; a+=3.0/columns)) do
			for ((p=0.0, q=0.0, i=0; p*p+q*q < 4 && i < 32; i++)) do
				((pnew=p*p-q*q+a, q=2*p*q+b, p=pnew))
			done
			((colour=(i/4)%8))
			echo -n "\\e[4${colour}m "
		done
		echo
	done
}

# Customize to your needs...
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xvjf $1 ;;
			*.tar.gz) tar xvzf $1 ;;
			*.tar.xz) tar xvJf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.rar) unrar x $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar xvf $1 ;;
			*.tbz2) tar xvjf $1 ;;
			*.tgz) tar xvzf $1 ;;
			*.zip) unzip $1 ;;
			*.Z) uncompress $1 ;;
			*.7z) 7z x $1 ;;
			*.xz) unxz $1 ;;
			*.exe) cabextract $1 ;;
			*) echo "\`$1': unrecognized file compression" ;;
	esac
	else
		echo "\`$1' is not a valid file"
	fi
}

# Gather external ip address
exip () {
	echo -n "Current External IP: "
	curl -s -m 5 http://ipv4.myip.dk/api/info/IPv4Address | sed -e 's/"//g'
}

# Determine local IP address
ips () {
	ifconfig | grep "inet " | awk '{ print $2 }'
}
