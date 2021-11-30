#!/usr/bin/env bash
# See ~/bin/sunrise-sunset.sh
# */5 * * * * ~/bin/kittyMode.sh

kittyThemeEnvironment="${ZDOTDIR:-${HOME}}/.config/kitty/env.conf"
zshThemeEnvironment="${ZDOTDIR:-${HOME}}/.config/zsh/themes/env.zsh"
nowTimestamp=$(date +%s)
fiveMinutesAgo=$(expr $nowTimestamp - 300)
lastZshChange=$(stat --format=%Y $zshThemeEnvironment)
lastKittyChange=$(stat --format=%Y $kittyThemeEnvironment)
zshFileAge=$(expr $nowTimestamp - $lastZshChange)
kittyFileAge=$(expr $nowTimestamp - $lastKittyChange)
recreate=false
if [[ ! -s "$kittyThemeEnvironment" || $lastKittyChange -le $fiveMinutesAgo ]]; then
  touch $kittyThemeEnvironment
  echo "# This file is generated automatically, do not edit by hand!" >$kittyThemeEnvironment
  echo "# Edit ~/bin/kittyMode.sh instead!" >>$kittyThemeEnvironment
  notify-send 'KittyMode' "kittyFileAge: ${kittyFileAge}, refreshing kitty theme file" -a 'KittyMode' -i "${ZDOTDIR:-${HOME}}/Applications/WhiteSur-icon-theme/src/apps/scalable/kitty.svg"
  recreate=true
fi

if [[ ! -s "$zshThemeEnvironment" || $lastZshChange -le $fiveMinutesAgo ]]; then
  touch $zshThemeEnvironment
  echo "# This file is generated automatically, do not edit by hand!" >$zshThemeEnvironment
  echo "# Edit ~/bin/kittyMode.sh instead!" >>$zshThemeEnvironment
  notify-send 'KittyMode' "zshFileAge: ${zshFileAge}, refreshing zsh theme file" -a 'KittyMode' -i "${ZDOTDIR:-${HOME}}/Applications/WhiteSur-icon-theme/src/apps/scalable/kitty.svg"
  recreate=true
fi

if ($recreate); then
  location=${LOCATION:-NLXX5790}

  IFS=':'
  read -r sunrise <$HOME/tmp/$location.sunrise
  sunrise=${sunrise/':'/}
  read -r sunset <$HOME/tmp/$location.sunset
  sunset=${sunset/':'/}

  nowHourMin=$(date +%H%M)

  mode=dark
  if [ $nowHourMin -ge $sunrise ] && [ $nowHourMin -lt $sunset ]; then
    mode=light
  fi

  if [ "$1" != "" ]; then
    mode=$1
  fi

  if [[ $mode == "light" ]]; then
    # Active terminals
    kitty @ --to unix:@kitty-$(pidof kitty) set-colors -a background=\#fdf6e3 foreground=\#586e75 &
    kitty @ --to unix:@kitty-$(pidof kitty) set-background-image ~/Pictures/Backgrounds/termBg.day.png &

    # Gnome theme
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita &

    # New terminals
    echo 'background_image ~/Pictures/Backgrounds/termBg.day.png' >>$kittyThemeEnvironment
    echo 'background #fdf6e3' >>$kittyThemeEnvironment
    echo 'foreground #586e75' >>$kittyThemeEnvironment

    # New zsh prompt and bat themes
    echo 'export BAT_THEME="OneHalfLight"' >>$zshThemeEnvironment
    echo 'export IL_C_DIRTXT=67' >>$zshThemeEnvironment
    echo 'export IL_C_FILETXT=238' >>$zshThemeEnvironment
  else
    # Active terminals
    kitty @ --to unix:@kitty-$(pidof kitty) set-colors -a background=\#000000 foreground=\#c0c0c0 &
    kitty @ --to unix:@kitty-$(pidof kitty) set-background-image ~/Pictures/Backgrounds/termBg.png &

    # Gnome theme
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark &

    # New terminals
    echo 'background_image ~/Pictures/Backgrounds/termBg.png' >>$kittyThemeEnvironment
    echo 'background #000000' >>$kittyThemeEnvironment
    echo 'foreground #c0c0c0' >>$kittyThemeEnvironment

    # New zsh prompt and bat themes
    echo 'export BAT_THEME="OneHalfDark"' >>$zshThemeEnvironment
    echo 'export IL_C_DIRTXT=67' >>$zshThemeEnvironment
    echo 'export IL_C_FILETXT=250' >>$zshThemeEnvironment
  fi
fi
