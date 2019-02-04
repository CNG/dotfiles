[.config/i3/config](../files/config/i3/config)

    setxkbmap dvorak
    xbindkeys

[.xbindkeysrc](../files/xbindkeysrc) only fixes Spotify forward and back
buttons.







# Gestures

Gestures are configured with [`libinput-gestures`](https://github.com/bulletmark/libinput-gestures) in [`~/.config/libinput-gestures.conf`](../files/config/libinput-gestures.conf).

# Keypress

Use `xev` to open window for examining mouse and key events.

Can also try `sudo showkey`.

# Find values of mod1, etc.


    $ xmodmap
    xmodmap:  up to 5 keys per modifier, (keycodes in parentheses):

    shift       Shift_L (0x32),  Shift_R (0x3e)
    lock
    control     Control_L (0x25),  Control_R (0x69)
    mod1        Alt_L (0x40),  Alt_R (0x6c),  Meta_L (0xcd)
    mod2        Num_Lock (0x4d)
    mod3
    mod4        Hyper_L (0x42),  Super_L (0x85),  Super_R (0x86),  Super_L (0xce),  Hyper_L (0xcf)
    mod5        ISO_Level3_Shift (0x5c),  Mode_switch (0xcb)

* [Mod, Meta, Super … keys?](https://unix.stackexchange.com/a/119219/39419)
* [Why do my xmodmap binds involving AltGr only work on some keys?](https://unix.stackexchange.com/a/313711/39419)
