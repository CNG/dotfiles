I've mapped space bar to the mod key i3 uses, and use xcape to create a space
when spacebar is released without pressing another key first. I first ran across
this on the Reddit post [Using Space Bar as `$mod` is Life Changing][source].

1. Add `xcape` to packages for installation.
2. Add to `~/.Xmodmap`:

        clear mod3
        clear mod4
        add mod3 = Hyper_L
        add mod4 = Super_L Super_R

3. Tried adding this to i3 config, but that did not seem to work. Nor did simply
   adding to `~/.profile` event though this is apparently executed by
   `/etc/lightdm/Xsession`. Finally added this to `~/.xprofile` and ran that
   with i3 using `exec_always --no-startup-id bash ~/.xprofile`:

        # Use Spacebar as a Modifier
        xmodmap -e "keycode 65 = Hyper_L"
        xmodmap -e "keycode any = space"
        xcape -e "Hyper_L=space"

4. Change i3 `$mod` to `Mod3`.
5. Change i3 floating window and focus shortcuts from `$mod+Shift+space` and
   `$mod+space` to `$mod+Shift+p` and `$mod+p` ("pop up").


[source]: https://www.reddit.com/r/i3wm/comments/5zpz69/using_space_bar_as_mod_is_life_changing/

