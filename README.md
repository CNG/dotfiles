# @CNG/dotfiles (Arch Linux)

This Bash and Ansible project installs Arch Linux from scratch and configures it
for use on my desktop and laptop. There are a few bits in the setup that need
tweaking, thus it's not fully automated. I neglected to update this since 2024
till I used it again to setup from scratch at the end of 2026 due to an SSD
crash. I hadn't exported my packages before that crash, so will be likely making
changes here again as I discover what's missing. Also, I am no longer working in
tech but rather a student again, so I'll probably strip out some of the tools
and complication I won't be using for some time, I hope. :-)

The contents of [`ansible`](ansible) is based on [@pigmonkey/spark][spark] with
roles and components added or removed; consider reviewing that project for
useful bits or updates. Much of my previously script based configuration for Mac
is now simplified for Linux in [`files`](files).

[spark]: https://github.com/pigmonkey/spark

![Desktop look as of 2026-10](desktop.png)

# Installation

This assumes you are already in Linux in order to make the installation media.
If you're doing it from another Arch Linux Live USB, take care with the device
identifiers! USB keys are likely `/dev/sd*` and microSD cards may be `mmcblk0`.
If anything is not installed like `vim`, you can run `pacman -Sy vim` on the
live Linux just fine as long as the Internet is connected.

1. Choose an [Arch Linux Downloads][dl] mirror under "HTTP Direct Downloads"
   such as *Rackspace* and copy the `.iso` file link.
1. Insert USB stick and confirm path, such as `/dev/sda`.
   Run command: `sudo make_media /dev/sda URL`
1. Boot from the new USB drive.

    ```
    # Run `loadkeys dvorak` on Dvorak keyboard
    nraet.fo ekrpat
    auditctl -e0  # If logging is too intense
    mkdir -p /tmp/setup
    mount /dev/sda2 /tmp/setup | true
    # Verify the target disk with lsblk; this erases and repartitions it.
    # Pass ROOTDEVICE and hostname; add s2idle or deep if desired:
    /tmp/setup/dotfiles/base /dev/nvme0n1 ExampleHostname
    # For OMEN laptop:
    # /tmp/setup/dotfiles/base /dev/nvme0n1 ExampleHostname s2idle
    ```

1. Verify the target disk and execute [`base`](base) with its path and the
   desired hostname; remove USB media when it reboots at the end.
1. .  

  ```
  mkdir -p /home/cgorichanaz /mnt/usb
  mount /dev/sda2 /mnt/usb
  cp -a /mnt/usb/dotfiles /home/cgorichanaz
  cp -a /mnt/usb/.dotfiles /home/cgorichanaz
  cd /home/cgorichanaz/dotfiles
  ln -s ../.dotfiles private
  nmcli device wifi connect SSID password PASS
  ```

1. Execute [`provision`](provision).

[dl]: https://www.archlinux.org/download/
[dl-ex]: https://mirrors.kernel.org/archlinux/iso/2019.05.02
[media]: https://wiki.archlinux.org/index.php/USB_flash_installation_media


## Todo

Some issues I noticed after the last run through to be addressed:

- Home folder items and SSH folder end up owned by root. Need to fix that at the
  end or try to run `provision` as the user earlier in this process, right after
  the user account is created?
- Missing my mounts to load the server folders in Dolphin quickly.
- Somehow reinstalling got me into systemd decrypt land, so I needed to change
  the syntax of some things that are not reflected in the install script yet.
  The HOOKS line gets to look like this: `HOOKS=(base systemd keyboard autodetect microcode modconf kms sd-vconsole block sd-encrypt lvm2 resume filesystems fsck)`. That's with `sd-encrypt` instead of `encrypt`, removes an extra `keyboard` I had, and removes `keymap` and `consolefont` because apparently they are handled by `sd-vconsole` now.
- Then had to change arch.conf to match sd-encrypt syntax with:
`options rd.luks.name=YOUR-LUKS-UUID=luks root=/dev/mapper/luks
rootflags=subvol=root rw`.
- So I need to make an automatic call to `cryptsetup luksUUID /dev/nvme0n1p3`.


# Troubleshooting

Steps to boot from live USB key.

```
# Run loadkeys dvorak on Dvorak keyboard
nraet.fo ekrpat
cryptsetup open /dev/nvme0n1p4 luks
mount -o subvol=root /dev/mapper/luks /mnt
mount /dev/nvme0n1p1 /mnt/boot
iwctl station wlan0 connect SSID --passphrase PASS
arch-chroot /mnt/root
# mount all the Btrfs etc partitions we now have in /etc/fstab
mount -a
# If need to fix boot:
mkinitcpio -p linux
# Or maybe EFI options messed up, in which case might be able to
# select \EFI\BOOT\BOOTX64.EFI or \EFI\systemd\systemd-bootx64.efi
# by hitting F9 upon boot and manually selecting EFI
# May need to run bootctl outside chroot and use --esp-path=/mnt/root/boot
bootctl install
# May also need to remove/fix boot entries
efibootmgr -v
efibootmgr --delete-bootnum -b 0001
# or could try:
efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Linux Boot Manager" \
  --loader '\EFI\systemd\systemd-bootx64.efi'
```


# Migrating to larger SSD

A [very good case](https://askubuntu.com/a/1152183) is made to avoid `dd` due to lack of safegaurds, but I will live on the edge here since I have my important data backed up.

```
# Clone disk to new SSD
dd if=/dev/nvme0n1 of=/dev/sdb bs=1024M oflag=sync status=progress

# Fix partition table (backup GPT is in middle of disk not end!)
gdisk /dev/sdb
w
Y
Y

# Expand partition
yay -Sys cloud-guest-utils
growpart /dev/sdb 3
partprobe /dev/sdb

# Expand filesystem
cryptsetup luksOpen /dev/sdb3 encrypted_volume
cryptsetup resize encrypted_volume
mount /dev/mapper/encrypted_volume /mnt
btrfs filesystem resize max /mnt

# Skipped this for now: fstrim -v /mnt
```


# About the system

## Installation and configuration flow

[`base`](base) prepares the disk, creates the encrypted Btrfs layout, installs
Arch Linux, and reboots. After the manual post-install setup described above,
[`provision`](provision) runs Ansible locally against the new system.
[`ansible/playbook.yml`](ansible/playbook.yml) applies the common roles and
condition-specific roles, using settings and package lists from
[`ansible/group_vars/all.yml`](ansible/group_vars/all.yml). The dotfiles role
deploys configuration from [`files/`](files) into the user's home directory.

## Sway

Sway is the configured desktop environment and window manager. The
`desktop_environment: sway` setting in
[`ansible/group_vars/all.yml`](ansible/group_vars/all.yml) makes the playbook
run the [Sway role](ansible/roles/sway/tasks/main.yml) and the
[greeter role](ansible/roles/greeter/tasks/main.yml). The Sway role installs
Sway and sets up the user's application defaults. The user's Sway configuration
is [`files/config/sway/config`](files/config/sway/config).

## GreetD and ReGreet

GreetD is the login manager, and ReGreet provides its graphical login screen.
The greeter role installs `greetd-regreet`, writes GreetD's configuration to
`/etc/greetd/config.toml`, and enables the `greetd` service.

At startup, GreetD runs the default session as the `greeter` user. Its command
starts a temporary Sway instance using `/etc/greetd/sway-config`; that config
starts ReGreet. The greeter Sway config and ReGreet appearance settings come
from [`ansible/roles/greeter/files/sway-config`](ansible/roles/greeter/files/sway-config)
and [`ansible/roles/greeter/files/regreet-config.toml`](ansible/roles/greeter/files/regreet-config.toml).
When you select Sway in ReGreet, it launches the logged-in desktop using the
Sway Wayland session entry at `/usr/share/wayland-sessions/sway.desktop`. This
starts a separate Sway process from the temporary Sway instance that displays
the login screen.

## Terminal: Alacritty, Zsh and Tmux

### Alacritty

I use [Alacritty](https://github.com/jwilm/alacritty), a simple, performant terminal emulator that uses GPU rendering. It provides little beyond the basics, but can be configured by file.

**[`~/.config/alacritty/alacritty.toml`](./files/config/alacritty/alacritty.toml) highlights**

I'm using the font [Input](http://input.fontbureau.com/) Mono and tried to make the colors roughly like [Molokai](https://github.com/zhou13/molokai-terminal), though I need some work on my colors in terminal and Tmux. I set `background_opacity` because I like the look, but it admittedly makes it harder to read text. I usually keep the terminal over less distracting areas of my desktop background. :)

### Zsh

I use [Zsh](http://zsh.sourceforge.net/Intro/intro_1.html#SEC1) with
[Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh), the Powerlevel10k theme, and
the `history-search-multi-word` plugin.

The dotfiles link [`~/.zshenv`](./files/zshenv) and [`~/.zshrc`](./files/zshrc)
to the versions in this repository. `.zshenv` runs for every Zsh process and
sets up environment variables and function lookup paths. `.zshrc` loads the
interactive shell configuration, Oh My Zsh, and completions. Private,
machine-specific settings can go in `~/.zshenv.local` and `~/.zshrc.local`.
Ansible installs Zsh and checks out Oh My Zsh, Powerlevel10k, and the history
search plugin in [`ansible/roles/base/tasks/shell.yml`](ansible/roles/base/tasks/shell.yml).

### Tmux

Zsh starts or attaches to Tmux when I open an interactive shell outside Tmux,
using [`tmux.zsh`](./files/zsh/config/tmux/tmux.zsh). A systemd user service is
also defined in [`tmux.service`](files/config/systemd/user/tmux.service), but
its enablement task is currently commented out in
[`shell.yml`](ansible/roles/base/tasks/shell.yml). The Oh My Zsh Tmux plugin is
not enabled; its entry in [`plugins.zsh`](./files/zsh/config/tmux/plugins.zsh)
is commented out.

My Tmux config in [`files/tmux.conf`](./files/tmux.conf) sets up my main
keyboard shortcuts and these plugins:

* [nhdaly/tmux-better-mouse-mode](https://github.com/nhdaly/tmux-better-mouse-mode)
* [soyuka/tmux-current-pane-hostname](https://github.com/soyuka/tmux-current-pane-hostname)
* [tmux-plugins/tmux-logging](https://github.com/tmux-plugins/tmux-logging)
* [tmux-plugins/tmux-yank](https://github.com/tmux-plugins/tmux-yank)
* [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

#### Tmux cheatsheet

Navigate between panes with `^b` followed by an arrow key, or use
[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)'s
prefix-free `^h`, `^j`, `^k`, and `^l` shortcuts; `^\` moves to the previous
split.

For the following shortcuts, press `^b` first:

* **sessions**: `:new`
* **windows**: `c` create, `l` list, `n` next, `p` previous, `&` kill, `f` find, `,` name
* **panes**: `/` split horizontally, `-` split vertically, `o` swap, `q` show numbers, `x` kill, ` ` toggle layouts
* **other**: `t` big clock, `d` detach, `?` list shortcuts, `L` toggle logging, `I` install plugins, `P` save complete history (also happens on `^d`) 

### Vim

My Vim configuration [`~/.vimrc`](files/vimrc) uses
[vim-plug](https://github.com/junegunn/vim-plug) to manage plugins. Ansible
installs Vim via [`ansible/roles/editors/tasks/main.yml`](ansible/roles/editors/tasks/main.yml);
vim-plug is bootstrapped by the Vim configuration, and plugins can be installed
or updated with `:PlugInstall`.

## Misc

### Cron

Arch [does not have cron by default][Cron] but uses [systemd/Timers][timers]
instead. I tried implementing a few things this way, such as my Folding@home
[idle check setup][fahidlecheck], but it's way more painful than adding a line
to a crontab. I'm not really sure why I was trying so hard to give the systemd
timers a chance, so now I'm switching to using cronie, a crontab implementation.
I actually had it installed since the beginning without realizing it; so much
for the simplicity I tried to have by using only systemd!

Cronie's daemon is `cronie.service`. Jobs can be configured in per-user
crontabs with `crontab -e` or system-wide in `/etc/cron.d/` and periodic-job
directories such as `/etc/cron.daily/`.

[Cron]: https://wiki.archlinux.org/index.php/Cron
[timers]: https://wiki.archlinux.org/index.php/Systemd/Timers
[fahidlecheck]: https://github.com/CNG/dotfiles/tree/c57326de205415eb28501a9b50df628c51415956/ansible/roles/fah/files
