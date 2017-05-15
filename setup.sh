#!/usr/bin/env zsh

# Take home dir as parameter for use in puppet script
if [[ -z $1 ]]
then
	home=${ZDOTDIR:-${HOME}}
else
	home=$1
fi

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

e_header "Installing zim..."
if [ ! -d $home/.zim ]
then
	git clone --recursive https://github.com/Eriner/zim.git $home/.zim
fi

e_header "Creating symlinks..."
setopt EXTENDED_GLOB
for rcfile in "${home}"/dotfiles/^(.git|config|README*|setup.sh|update-modules.sh)(D); do
	ln -s -f "$rcfile" "${home}/${rcfile:t}"
done
mkdir -p $home/.config

chmod u+x $home/tmux-launch.sh

e_header "Initializing submodules..."
git submodule update --init --recursive

e_header "Installing vim plugins..."
vim -S <(echo -e "PlugInst \n q \n q")

e_header "Compiling command-t for current ruby version..."
cd $home/${PWD##*/}/.vim/plugged/command-t/ruby/command-t
if command -v ruby > /dev/null 2>&1; then
	ruby extconf.rb
	if command -v make > /dev/null 2>&1; then
		make
	fi
fi

e_success "All done"