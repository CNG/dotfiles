# HiDPI

Multiples of 96 might be good. See current settings:

    xdpyinfo | grep dots
    xrdb -query | grep dpi
    $ grep DPI /var/log/Xorg.0.log
    [ 16326.902] (--) NVIDIA(0): DPI set to (184, 182); computed from "UseEdidDpi" X config

## X Server

    $ xdpyinfo | grep -B 2 resolution
    screen #0:
      dimensions:    3840x2160 pixels (530x301 millimeters)
      resolution:    184x182 dots per inch

## X Resources

Set `Xft.dpi` in `~/.Xresources`:

    Xft.dpi: 192

> Make sure the settings are loaded properly when X starts, for instance in your `~/.xinitrc` with `xrdb -merge ~/.Xresources`.

> This will make the font render properly in most toolkits and applications, it will however not affect things such as icon size! Setting `Xft.dpi` at the same time as toolkit scale (e.g. `GDK_SCALE`) may cause interface elements to be much larger than intended in some programs like Firefox.

Also had been setting DPI with `xrandr` via i3 config:

    exec_always --no-startup-id xrandr --dpi 108

## Qt 5

I'm not doing anything special for Qt right now.

## GDK 3

To scale UI elements by a factor of two:

    export GDK_SCALE=2

To undo scaling of text:

    export GDK_DPI_SCALE=0.5

### Firefox

Can set the config [layout.css.devPixelsPerPx](about:config?filter=layout.css.devPixelsPerPx) to `2`, etc.

## SystemD boot

Earliest boot stage uses larger interface thanks to `console-mode 2` set in
`/boot/loader/loader.conf`. See [Systemd-boot: Loader configuration](https://wiki.archlinux.org/index.php/Systemd-boot#Loader_configuration).

The next stage before entering the encryption key uses a larger font,
terminus-font, and these settings in `/etc/vconsole.conf`:

    FONT=ter-p32n
    FONT_MAP=8859-2

I've also made sure the `mkinitcpio` hook `consolefont` appears before `encrypt`
in `/etc/mkinitcpio.conf`:

    HOOKS=(base udev keyboard autodetect modconf block keymap consolefont encrypt lvm2 resume filesystems fsck)

Another option for a quick fix on an existing system could be adding a kernel
parameter on boot: `video=1024-768`


[HiDPI]: https://wiki.archlinux.org/index.php/HiDPI#X_Resources
[Xorg#Display_size_and_DPI]: https://wiki.archlinux.org/index.php/Xorg#Display_size_and_DPI

