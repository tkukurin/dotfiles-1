HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000
# Share history between tmux windows
setopt SHARE_HISTORY

export KUBECONFIG=${HOME}/.config/kube/config

export TERMINAL=kitty

export PAGER=most

export GREP_COLOR='38;5;202'

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;67m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;33;65m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;172m' # begin underline
export LESS=-r

eval "$(dircolors .dircolors -b)"
#export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';

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

# load autojump
. /usr/share/autojump/autojump.zsh

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
