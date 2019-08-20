HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000
# Share history between tmux windows
setopt SHARE_HISTORY

export TERMINAL='urxvt'

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

# Makeflags
export MAKEFLAGS="-j$(nproc)"

# Midnight commander wants this:
export COLORTERM=truecolor

export GOPATH=${HOME}/Projects/Go
export GOBIN=${GOPATH}/bin

if [[ -e /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Disabled because of slowness
# # Ruby version manager
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
#
# # Node version manager
# export NVM_DIR="$HOME/.nvm"
# [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
#
# if (( $+commands[luarocks] )); then
#     eval `luarocks path --bin`
# fi

path=(\
    ${GOBIN} \
    ${HOME}/.gem/ruby/2.5.0/bin \
    ${HOME}/bin \
    ${HOME}/.composer/vendor/bin \
    ./vendor/bin \
    ${HOME}/.node/bin \
    ${HOME}/.npm-packages/bin \
    ${HOME}/.rvm/bin \
    ./bin \
    $path\
    )
export PATH
