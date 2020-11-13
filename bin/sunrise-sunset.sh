#!/bin/bash

# First obtain a location code from: https://weather.codes/search/

# 0 12 * * * ~/bin/sunrise-sunset.sh

# Insert your location. For example LOXX0001 is a location code for Bratislava, Slovakia
location="NLXX5790"
tmpfile=$HOME/tmp/$location.out
sunriseCache=$HOME/tmp/$location.sunrise
sunsetCache=$HOME/tmp/$location.sunset

# Obtain sunrise and sunset raw data from weather.com
wget -q "https://weather.com/weather/today/l/$location" -O "$tmpfile"

SUNR=$(grep SunriseSunset "$tmpfile" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | head -1)
SUNS=$(grep SunriseSunset "$tmpfile" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | tail -1)

sunrise=$(date --date="$SUNR" +%R)
sunset=$(date --date="$SUNS" +%R)

# Use $sunrise and $sunset variables to fit your needs. Example:
echo "$sunrise" > $sunriseCache
echo "$sunset" > $sunsetCache
