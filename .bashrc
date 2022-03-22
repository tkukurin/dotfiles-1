export EDITOR='vim'
[ -x "$(command -v bat)" ] && export PAGER='bat'
[ -x "$(command -v bat)" ] && export MANPAGER='bat'

if [ `uname` = Darwin ] && [ `which brew` ]; then
    export BYOBU_PREFIX=`brew --prefix`
fi

#[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#function _update_ps1() {
#   export PS1="$(~/powerline-shell.py $?)"
#}

#alias tmux="TERM=screen-256color-bce tmux"

if [[ -r ~/.credentials ]]; then
    source ~/.credentials
fi

# export PROMPT_COMMAND="_update_ps1"

# Start bash, then switch to zsh embedded in bash
[[ $(which zsh) ]] && exec -l zsh "$@"
