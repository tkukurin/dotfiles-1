-- Autorun programs
local awful = require("awful")
autorun = true
autorunApps = {
   "systemctl --user start awesome.target",
   "xrandr --output HDMI-1 --primary --mode 1920x1200 --pos 1920x0 --rotate normal --output DP-1 --off --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-2 --off",
   -- "compton -b",
   "pactray",
   "/usr/lib/gsd-xsettings",
   "dex -a -e awesome",
   "udiskie",

    -- Switch Wacom pen buttons; click button is secondary
    "xinput set-prop 'Wacom Intuos PT M Pen stylus' 293 1572865",
    "xinput set-prop 'Wacom Intuos PT M Pen stylus' 294 1572867",

    "xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Tapping Enabled' 1",
    "xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1",
    "xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Disable While Typing Enabled' 1",

    -- Lock screen and suspend
    "xss-lock -- betterlockscreen -s dim",
}
if autorun then
   for app = 1, #autorunApps do
       awful.spawn.with_shell(autorunApps[app])
   end
end
