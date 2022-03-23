HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000
# Share history between tmux windows
setopt SHARE_HISTORY

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
else
  export BROWSER='xdg-open'
fi

# Editors
export EDITOR='vim'
export GIT_EDITOR='vim'
export VISUAL='vim'
[[ $(which bat) ]] && export PAGER='bat' || export PAGER='less'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

export KUBECONFIG=${HOME}/.config/kube/config

# export TERMINAL=kitty
# export PAGER=most

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

# nnn file manager
export NNN_FIFO="/tmp/nnn.fifo nnn"
export NNN_PLUG="p:preview-tui;w:wall;j:autojump;i:imgview;d:diffs"
export NNN_OPENER="xdg-open"
export NNN_OPENER_DETACH=1
export NNN_COLORS="4321"
export NNN_FCOLORS="c1e2431c006025f7a2d6aba0"
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
export NNN_BMS='h:~;i:~/Pictures;d:~/Downloads;p:~/Projects;c:~/Projects/Clients'
export ICONLOOKUP=1
export USE_PISTOL=0
export PISTOL_DEBUG=0

# Exa https://the.exa.website/docs/colour-themes
export EXA_COLORS="da=38;5;67:sn=38;5;28:uu=38;5;65:sb=38;33"

# See ~/bin/sunrise-sunset.sh
export LOCATION=NLXX5790

# load autojump
# NOTE(tk) not installed by default ?
# . /usr/share/autojump/autojump.zsh

# load Rust env
. "$HOME/.cargo/env"

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
    ${HOME}/.cargo/bin \
    ${HOME}/.gem/ruby/2.5.0/bin \
    ${HOME}/bin \
    ${HOME}/.composer/vendor/bin \
    ./vendor/bin \
    ${HOME}/.node/bin \
    ${HOME}/.npm-packages/bin \
    ${HOME}/.rvm/bin \
    ./bin \
    $path\
    /opt/atlassian/plugin-sdk/bin \
    )
export PATH
