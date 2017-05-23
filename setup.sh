#!/usr/bin/env zsh

# Logging stuff.
function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_success() { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()   { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()   { echo -e " \033[1;34m➜\033[0m  $@"; }

function main () {
	# Take home dir as parameter for use in puppet script
	local home
	if [[ -z $1 ]]
	then
		home=${ZDOTDIR:-${HOME}}
	else
		home=$1
	fi

	# Get the directory in which the script resides
	local dotfileDir=${0:a:h}

	e_header "Creating symlinks..."
	mkdir -p $dotfileDir/backup

	setopt EXTENDED_GLOB
	local ohMyGlob='^(.idea|.git*|.config|bin|backup|README*|Screenshots|setup.sh)(D)'
	for dir ('/' '/bin/' '/.config/'); do
		mkdir -p ${home}${dir}
		mkdir -p $dotfileDir/backup${dir}
		for rcfile in ${dotfileDir}${dir}${~ohMyGlob}; do
		    local target="${home}${dir}${rcfile:t}"
			[[ -a "${target}" ]] && mv "${target}" "$dotfileDir/backup/${dir}" 2>/dev/null
			if [ $(uname) = Darwin ]; then
			    command ln -h -s -F "$rcfile" "${target}"
            else
			    command ln -s "$rcfile" "${target}"
            fi
		done
	done

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

	e_success "All done!"
}

main "$1"
