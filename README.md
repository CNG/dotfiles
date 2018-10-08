# @CNG/dotfiles (Arch Linux)

This Bash and Ansible project installs Arch Linux from scratch and configures it for use on my desktop and laptop.

The contents of [`ansible`](ansible) is based on [@pigmonkey/spark](https://github.com/pigmonkey/spark) with roles and components added or removed; consider reviewing that project for useful bits or updates. Much of my previously script based configuration for Mac is now simplified for Linux in [`files`](files).

# Installation

1. Create [Arch Linux USB installation media](https://wiki.archlinux.org/index.php/USB_flash_installation_media).
1. Copy this repository to the media.
1. Boot from the media and run `lsblk`.
1. Open [`base`](base) in a text editor.
1. Set `setuppartition` to the `/dev/` address of the installation media.
1. Set `rootdevice` to the `/dev/` path of the system drive. This might be the output of `lsblk -d -p -n -l -o NAME -e 7,11 | head -1`, such as `/dev/nvme0n1`.
1. Execute [`base`](base); remove USB media when it reboots at the end.
1. Execute [`provision`](provision).

# About the system

## TODO: X

[`ansible/roles/x/tasks/main.yml`](ansible/roles/x/tasks/main.yml)

Xorg config, autorandr, mouse setup, graphics drivers

## TODO: Login: LightDM

[`ansible/roles/lightdm/tasks/main.yml`](ansible/roles/lightdm/tasks/main.yml): lightdm-webkit2-greeter + lightdm-webkit2-theme-material2

[`/etc/lightdm/lightdm.conf.d/50-lightdm.conf`](https://github.com/CNG/dotfiles/blob/master/ansible/roles/lightdm/files/50-lightdm.conf): attempts to set key repeat and delay with `xserver-command=X -ardelay 150 -arinterval 50`. This does not always stick, so I also added it to my [i3 config](files/config/i3/config#L248) (`exec_always --no-startup-id xset r rate 250 50 # for X`).

## TODO: i3 Window Manager

* i3-gaps
* i3blocks
* rofi
* playerctl
* compton-tryone-git
* [`~/.config/i3/config`](files/config/i3/config)
* [`~/.config/i3blocks/config`](files/config/i3blocks/config)
* [`~/.config/i3scripts`](files/config/i3scripts)

## Terminal: Alacritty, Zsh and Tmux

### Alacritty

I use [Alacritty](https://github.com/jwilm/alacritty), a simple, performant terminal emulator that uses GPU rendering. It provides little beyond the basics, but can be configured by file (unlike [st](https://st.suckless.org/), which requires recompiling to make changes). I initially used a version of Alacritty (now a part of core) that provided a scrollback feature, which I had gotten used to in iTerm2 on Mac. I switched back to the normal Alacritty once I figured out a suitable way to do this [from within Tmux](https://github.com/jwilm/alacritty/issues/923#issuecomment-408224216).

**[`~/.config/alacritty/alacritty.yml`](./files/config/alacritty/alacritty.yml) highlights**

I'm using the font [Input](http://input.fontbureau.com/) Mono and tried to make the colors roughly like [Molokai](https://github.com/zhou13/molokai-terminal), though I need some work on my colors in terminal and Tmux. I set `background_opacity: 0.6` because I like the look, but it admittedly makes it harder to read text. I usually keep the terminal over less distracting areas of my desktop background. :)

I liked having a consistent command for copy and paste on Mac, and initally I tried to avoid the default terminal behavior of needing to hold Shift. Additionally, since I use Dvorak, the standard C, V and X keys are not near each other. I thought it might make sense to use the Y and P keys for copy and paste like in Vim, but realized later this conflicted with ^P for print in many apps. I'm still deciding what to do. For now I have this in my Alacritty config, but I think I am handling it in other higher level configs, so I need to reevaluate:

    key_bindings:
      # copy and paste kind of like Vim
      - { key: P,        mods: Control, action: Paste                        }
      - { key: Y,        mods: Control, action: Copy                         } 

### Zsh

I use [Z shell](http://zsh.sourceforge.net/Intro/intro_1.html#SEC1), or "zsh". I'm still working on my configuration, which has been evolving since I carried most of it over from my [Mac dotfiles](https://github.com/CNG/dotfiles_mac). I am using the [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) plugin manager by [@robbyrussell](https://github.com/robbyrussell).

The "top level" configuration [`~/.zshenv`](./files/zshenv) is always loaded, even when Zsh is launched from a scheduled task, which I do to use some of my custom Zsh functions. Then everything I need only when using a terminal interactively is defined in [`~/.zshrc`](./files/zshrc).

My favorite plugin is [history-search-multi-word](https://github.com/zdharma/history-search-multi-word), which I have [installed with Ansible](https://github.com/CNG/dotfiles/blob/84a41f5b2515916c5d6796fa4fec43d33b829ef1/ansible/roles/base/tasks/shell.yml#L36) and [loaded via oh-my-zsh](https://github.com/CNG/dotfiles/blob/84a41f5b2515916c5d6796fa4fec43d33b829ef1/files/zsh/oh-my-zsh.zsh#L36).

### Tmux

Tmux [automatically starts with systemd](https://wiki.archlinux.org/index.php/tmux#Autostart_with_systemd). The user service file [`tmux.service`](files/config/systemd/user/tmux.service) is enabled via Ansible in [`roles/base/tasks/shell.yml`](https://github.com/CNG/dotfiles/commit/029480f10e8f5079afbe998c0d97cdea9c4c0455#diff-12436e6f240dedee578f3c83b113c3a9). 

Then Zsh connects to Tmux automatically when I open a shell. The tmux oh-my-zsh plugin loads from [`~/.zsh/config/tmux/plugins.zsh`](./files/zsh/config/tmux/plugins.zsh) and gets configuration from [`~/.zsh/config/tmux/tmux.zsh`](./files/zsh/config/tmux/tmux.zsh), which specifies [`ZSH_TMUX_AUTOSTART=true`](https://github.com/robbyrussell/oh-my-zsh/blob/ff6b4c835be54a9529a88849b83284aee61a7126/plugins/tmux/tmux.plugin.zsh#L16) and [`ZSH_TMUX_FIXTERM=false`](https://github.com/robbyrussell/oh-my-zsh/blob/ff6b4c835be54a9529a88849b83284aee61a7126/plugins/tmux/tmux.plugin.zsh#L25).

My Tmux config file [`~/tmux.conf`](./files/tmux.conf) sets up my main keyboard shortcuts and these plugins:

* [nhdaly/tmux-better-mouse-mode](https://github.com/nhdaly/tmux-better-mouse-mode)
* [tmux-plugins/tmux-logging](https://github.com/tmux-plugins/tmux-logging)
* [tmux-plugins/tmux-yank](https://github.com/tmux-plugins/tmux-yank)
* [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

#### Tmux cheatsheet

Navigating between panes can be done by `^b`+arrow keys, or thanks to [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator), by `^h`, `^j`, `^k` and `^l`, and `^\` for previous split.

All of these require `^b` first, then:

* **sessions**: `:new`
* **windows**: `c` create, `l` list, `n` next, `p` previous, `&` kill, `f` find, `,` name
* **panes**: `/` split horizontally, `-` split vertically, `o` swap, `q` show numbers, `x` kill, `+` break to window, `-` restore from window, ` ` toggle layouts
* **other**: `t` big clock, `d` detach, `?` list shortcuts, `L` toggle logging, `I` install plugins, `P` save complete history (also happens on `^d`) 

### Vim

My Vim configuration [`~/.vimrc`](files/vimrc) loads the [Pathogen package manager](https://github.com/tpope/vim-pathogen), which loads the plugins installed via Ansible in [`ansible/roles/editors/tasks/main.yml`](ansible/roles/editors/tasks/main.yml). I am still getting the hang of Vim, which I have used for a long time but only at a "basic" level till around 2017, which I started making an effort.
