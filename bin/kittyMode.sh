#!/usr/bin/env bash

# See ~/bin/sunrise-sunset.sh
# */5 * * * * ~/bin/kittyMode.sh

themeEnvironment="${ZDOTDIR:-${HOME}}/.config/zsh/themes/env.zsh"
stamp=$(date +%s)
fiveMinutesAgo=`expr $stamp - 300`
lastChange=$(stat --format=%Y $themeEnvironment)
recreate=false
if [[ ! -s "$themeEnvironment" || $lastChange -le $fiveMinutesAgo ]]; then
  touch $themeEnvironment
  echo "# This file is generated automatically, do not edit by hand!" >$themeEnvironment
  echo "# Edit ~/bin/kittyMode.sh instead!" >>$themeEnvironment
  recreate=true
fi

if ( $recreate ); then
  location=${LOCATION:-NLXX5790}

  IFS=':'
  read -r sunrise <$HOME/tmp/$location.sunrise
  sunrise=${sunrise/':'/}
  read -r sunset <$HOME/tmp/$location.sunset
  sunset=${sunset/':'/}

  now=$(date +%H%M)

  mode=dark
  if [ $now -ge $sunrise ] && [ $now -lt $sunset ]; then
    mode=light
  fi

  if [ "$1" != "" ]; then
    mode=$1
  fi

  if [[ $mode == "light" ]]; then
    kitty @ --to unix:@kitty-$(pidof kitty) set-colors -a background=\#fdf6e3 foreground=\#586e75 &
    kitty @ --to unix:@kitty-$(pidof kitty) set-background-image ~/Pictures/Backgrounds/termBg.day.png &
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita &
    echo 'export BAT_THEME="OneHalfLight"' >>$themeEnvironment
    echo 'export IL_C_DIRTXT=67' >>$themeEnvironment
    echo 'export IL_C_FILETXT=238' >>$themeEnvironment
  else
    kitty @ --to unix:@kitty-$(pidof kitty) set-colors -a background=\#000000 foreground=\#c0c0c0 &
    kitty @ --to unix:@kitty-$(pidof kitty) set-background-image ~/Pictures/Backgrounds/termBg.png &
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark &
    echo 'export BAT_THEME="OneHalfDark"' >>$themeEnvironment
    echo 'export IL_C_DIRTXT=67' >>$themeEnvironment
    echo 'export IL_C_FILETXT=250' >>$themeEnvironment
  fi
fi
