xset r rate 200 35 &
xrandr --output HDMI-2 --mode 1920x1080 --rate 60 &
xrandr --output HDMI-1 --mode 1920x1080 --rate 60 &
setxkbmap -option caps:escape
exec i3;

