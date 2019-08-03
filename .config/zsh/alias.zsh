if [ `uname` = Darwin ]; then
	alias ls='/usr/local/bin/gls --color=auto'
else
	alias ls='/bin/ls --color=auto'
fi

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# Shortcuts
alias db="cd ~/Dropbox"
alias dl="cd ~/Downloads"
alias c="cd ~/Projects/Clients"
alias d="cd ~/Desktop"
alias p="cd ~/Projects"
alias g="git"
alias ga="git add"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gd="git diff"
alias gp="git push"
alias s="git status"
alias sa="ssh-add ~/.ssh/id_rsa"
alias h="history"
alias j="jobs"
alias open="xdg-open"
alias o="xdg-open"

## ddev
#alias up="ddev start"
#alias down="ddev stop"

# Vim shortcuts
alias vi=vim
alias :e="\$EDITOR"
alias :q="exit"

# Docker
alias dev=docker-compose
alias red='f(){ dev rm -fsv $@ && dev build && dev up -d $@ && dev logs -f $@; unset -f f; }; f'
alias off='f(){ dev rm -fsv $@; unset -f f; }; f'
alias on='f(){ dev up -d $@ && dev logs -f $@; unset -f f; }; f'
alias up=on
alias down=off
alias onoff=red
alias re=red
alias cf='dev exec php bash -c "/code/bin/typo3cms cache:flush"'
alias docker-wraith="docker run --rm -P -v \$PWD:/wraithy -w='/wraithy' bbcnews/wraith"

alias l="ls -A -F"
alias ll="ls -h -l "
alias la="ls -a"
# List only directories and symbolic links that point to directories
alias lsd='ls -ld *(-/DN)'
# List only file beginning with "."
alias lsa='ls -ld .*'
if [[ -f /etc/arch-release ]] || [[ -f /etc/debian_version ]]; then
	alias grep="grep --color=auto"
fi
alias know="vim ${HOME}/.ssh/known_hosts"
alias mc="mc --nosubshell"
alias reload!=". ${HOME}/.zshrc"
alias takeover="tmux detach -a"
alias vd="vagrant destroy"
alias vu="vagrant up"
alias vh="vagrant halt"
alias vp="vagrant provision"
alias vr="vagrant reload"
alias vs="vagrant ssh"
alias vbu="vagrant box update"
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "$method"="lwp-request -m '$method'"
done

# Tmux
alias tmux="export HOSTNAME=\$(hostname); sshAuthSave; tmux"
alias t="tmux new-session -A -s work"
alias tp="tmux new-session -A -s play"
alias tl="tmux list-sessions"

# Composer
alias composer5="docker run --rm -v \$(pwd):/app --volume ~/.ssh/known_hosts:/etc/ssh/ssh_known_hosts composer/composer:php5"
alias composer7="docker run --rm -v \$(pwd):/app -v \$(dirname $SSH_AUTH_SOCK):\$(dirname $SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=\$SSH_AUTH_SOCK --volume ~/.ssh/known_hosts:/etc/ssh/ssh_known_hosts composer/composer:php7"
alias ch70="COMPOSER_HOME=~/Projects/composer-config/php-7.0/"
