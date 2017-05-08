#!/bin/bash

# Take home dir as parameter for use in puppet script
if [[ -z $1 ]]
then
	home=~
else
	home=$1
fi

echo "Installing powerline shell..."
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

echo "Installing zim..."
if [ ! -d $home/.zim ]
then
	git clone --recursive https://github.com/Eriner/zim.git ${ZDOTDIR:-${HOME}}/.zim
fi

echo "Creating symlinks..."
itemsToLink=(
    .bashrc
    .config/powerline
    .dircolors
    tmux-launch.sh
    .tmux.conf
    .vim
    .vimrc
    .zimrc
    .zlogin
    .zlogout
    .zshenv
    .zshrc
    .zprofile
)

length=${#itemsToLink[*]}
i=0
while [ $i -lt $length ];
do
    item=${itemsToLink[$i]}
    if [ -e "$home/$item" ] || [ -L "$home/$item" ]; then
        if [ -L "$home/$item.original" ]; then
            rm "$home/$item.original"
        fi
    	mv "$home/$item" "$home/$item.original"
        ln -s $home/${PWD##*/}/$item $home/$item
    else
        ln -s $home/${PWD##*/}/$item $home/$item
    fi
    let i++
done

mkdir -p $home/.config

chmod u+x $home/tmux-launch.sh

echo "Initializing submodules..."
git submodule update --init --recursive

echo "Compiling command-t for current ruby version..."
cd $home/${PWD##*/}/.vim/plugged/command-t/ruby/command-t
if command -v ruby > /dev/null 2>&1; then
	ruby extconf.rb
	if command -v make > /dev/null 2>&1; then
		make
	fi
fi
