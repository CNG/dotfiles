# Android notes

These aren't totally relevant to my dotfiles, but are somewhat connected.

I use an Essential PH-1 Android device that's rooted. I tended to avoid system
updates due to forgetting how rooting worked and not wanting to research it
again. This was OK for a while since I could install security updates. Sometime
around fall 2019, my phone managed to automatically update itself from Android
9 to 10, wiping out my root setup. I finally got around to fixing this 2020-01.
Here are some notes.

## Rooting

I basically followed the directions at [How to Install TWRP Recovery & Root Essential PH-1][xda], but I ran into the "touch screen does not work in TWRP" issue. I employed the workaround mentioned in the second post (first comment) twice, both for installing the TWRP ZIP and the Magisk ZIP. I got the A/B screwed up a bit, so I might have installed Magisk on both and only needed one, I'm not sure. My command history looked like:

    sudo fastboot getvar current-slot
    sudo fastboot --set-active=a
    sudo fastboot flash boot_a twrp-3.2.3-0-mata.img
    adb devices
    adb push twrp-installer-mata-3.2.3-0.zip /sdcard/
    sudo adb shell twrp install /sdcard/twrp-installer-mata-3.2.3-0.zip
    adb reboot bootloader
    adb push Magisk-v20.3.zip /sdcard/
    sudo adb shell twrp install /sdcard/Magisk-v20.3.zip
    adb reboot bootloader
    sudo fastboot --set-active=b
    sudo adb shell twrp install /sdcard/Magisk-v20.3.zip


[xda]: https://forum.xda-developers.com/essential-phone/how-to/guide-how-to-install-twrp-root-t3841922


## Customizations

I use the "Home launcher" [Lawnchair 2][]. This lets me change the number of
rows and columns on the home screen and the "app tray", as well as icon sizes
and text display.


[Lawnchair 2]: https://play.google.com/store/apps/details?id=ch.deletescape.lawnchair.plah

## Backup

I have an [Android Backup](https://github.com/CNG/android_backup) script I used
to have set up to run by cron to completely backup the filesystem of my device
using a root rsync setup. This has changed a bit after switching from using
[SuperSU][] and [SSHelper][] to using [Magisk][] and a the [MagiskSSH][] module.

I copied my computer's SSH public key to a file named `authorized_keys` in
a directories `/data/ssh/root/.ssh` (and `/data/ssh/shell/.ssh` if using the non
root shell) on the phone. I may have edited `/data/ssh/sshd_config` to use `Port
4000` (can't remember if that was the "default" in this file).

Now I can do the full backup using an `rsync` command like:

    rsync -aizH -P --delete --delete-excluded --force --numeric-ids \
      --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/storage","/config"} \
      --backup --backup-dir="$DST/../current_deletions" \
      -e ssh $SRC:/ $DST

Where `$SRC` is `android`, corresponding to a host name I have in my
`~/.ssh/config`, and $DST is a filesystem location like
`$MAINSTORAGE/Backups/Phones/current`.

For moving photos and such off the phone frequently, my shell alias `phonefetch`
runs [android-transfer-media][]/ssh-transfer


[android-transfer-media]: https://github.com/CNG/android-transfer-media
[SuperSU]: http://www.supersu.com/download
[SSHelper]: http://arachnoid.com/android/SSHelper
[Magisk]: https://github.com/topjohnwu/Magisk
[MagiskSSH]: https://gitlab.com/d4rcm4rc/MagiskSSH/blob/master/module_data/README.md
[MagiskSSH_releases]: https://gitlab.com/d4rcm4rc/MagiskSSH_releases


