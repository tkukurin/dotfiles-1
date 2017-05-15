#!/bin/bash

# Take home dir as parameter for use in puppet script
if [[ -z $1 ]]
then
	home=~
else
	home=$1
fi

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

e_header "Installing powerline shell..."
if [ ! -d $home/powerline-shell ]
then
	cd $home/${PWD##*/}
	git submodule update --init powerline-shell
	cd $home/${PWD##*/}/powerline-shell && ./install.py
	cd ..

	if [ -e $home/powerline-shell.py ] || [ -L $home/powerline-shell.py ]; then
	    mv $home/powerline-shell.py $home/powerline-shell.py.original
    fi
    ln -s $home/${PWD##*/}/powerline-shell/powerline-shell.py $home/powerline-shell.py
fi

e_header "Installing zim..."
if [ ! -d $home/.zim ]
then
	git clone --recursive https://github.com/Eriner/zim.git ${ZDOTDIR:-${HOME}}/.zim
fi

e_header "Creating symlinks..."
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/^(.git|config|README*|setup.sh|update-modules.sh)(D); do
    ln -s -f "$rcfile" "${ZDOTDIR:-$HOME}/${rcfile:t}"
done
mkdir -p $home/.config

chmod u+x $home/tmux-launch.sh

e_header "Initializing submodules..."
git submodule update --init --recursive

e_header "Compiling command-t for current ruby version..."
cd $home/${PWD##*/}/.vim/plugged/command-t/ruby/command-t
if command -v ruby > /dev/null 2>&1; then
	ruby extconf.rb
	if command -v make > /dev/null 2>&1; then
		make
	fi
fi

e_success "All done"