#!/bin/bash

# See ~/bin/sunrise-sunset.sh
# */5 * * * * ~/bin/kittyMode.sh

location=NLXX5790

IFS=':'
read -r sunrise < $HOME/tmp/$location.sunrise
sunrise=${sunrise/':'/}
read -r sunset < $HOME/tmp/$location.sunset
sunset=${sunset/':'/}

now=`date +%H%M`

mode=dark
if [ $now -ge $sunrise ] && [ $now -lt $sunset ]; then
	mode=light
fi

if [ $mode == "light" ]; then
	kitty @ --to unix:@kitty-`pidof kitty` set-colors background=\#fdf6e3 foreground=\#586e75
	kitty @ --to unix:@kitty-`pidof kitty` set-background-image ~/Pictures/Backgrounds/termBg.day.png
else
	kitty @ --to unix:@kitty-`pidof kitty` set-colors background=\#000000 foreground=\#c0c0c0
	kitty @ --to unix:@kitty-`pidof kitty` set-background-image ~/Pictures/Backgrounds/termBg.png
fi
