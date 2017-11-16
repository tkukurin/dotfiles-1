HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000
# Share history between tmux windows
setopt SHARE_HISTORY

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='38;5;202'

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;67m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;33;65m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;172m' # begin underline
export LESS=-r

[[ -z $TMUX ]] && export TERM="xterm-256color"

# Midnight commander wants this:
export COLORTERM=truecolor

export GOPATH=${HOME}/Projects/Go

if [[ -e /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Set GPG TTY
export GPG_TTY=$(tty)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

path=(${HOME}/.rvm/gems/ruby-2.4.1/bin ${HOME}/bin ${GOPATH}/bin ${HOME}/.node/bin ${HOME}/.rvm/bin ${HOME}/.composer/vendor/bin $path)
export PATH
