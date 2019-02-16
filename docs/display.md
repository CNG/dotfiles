Connected:

`xrandr | grep -oP '^\S+(?= connected)'`

Active: 

`xrandr | grep -oP '^\S+(?= connected (?:primary )?\d+)'`

Clones:

`xrandr --output X --auto --output Y --auto --same-as X`

Separate:

`xrandr --output X --auto --output Y --auto --left-of X`

Rotate:

`xrandr --output X --rotate left`

Info for `$OUTPUT`:

`xrandr | grep -zoP "\n${OUTPUT}.*\n(?:  .*\n)+"`

Brightness:

`xrandr --output DP-1 --brightness .75`

## Screen tearing

Firefox setting: [`layers.acceleration.force-enabled`](about:config?filter=layers.acceleration.force-enabled)

https://bugs.freedesktop.org/show_bug.cgi?id=96847#c1

https://bbs.archlinux.org/viewtopic.php?id=229111
