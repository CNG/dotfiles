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

## Misc

Mounting this encrypted system drive in another system:

```
$ udisksctl unlock -b /dev/sdd2
Passphrase:
==== AUTHENTICATING FOR org.freedesktop.udisks2.encrypted-unlock-system ====
Authentication is required to unlock the encrypted device Crucial_CT960M500SSD1 (/dev/sdd2)
Authenticating as: cgorichanaz
Password:
==== AUTHENTICATION COMPLETE ====
Unlocked /dev/sdd2 as /dev/dm-3.

$ udisksctl mount -b /dev/mapper/luks-92bdda46-6b21-44f0-bb6d-52f31291dae4
Object /org/freedesktop/UDisks2/block_devices/dm_2d3 is not a mountable filesystem.

$ udisksctl lock -b /dev/sdd2
Locked /dev/sdd2.


sudo cryptsetup luksOpen /dev/sdd2 oldsystem

$ sudo cryptsetup luksOpen /dev/sdd2 oldsystem
Enter passphrase for /dev/sdd2:

$ sudo vgscan
  Reading volume groups from cache.
  Found volume group "vg0" using metadata type lvm2
  Found volume group "vg0" using metadata type lvm2

$ sudo vgdisplay
  --- Volume group ---
  VG Name               vg0
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <1.82 TiB
  PE Size               4.00 MiB
  Total PE              476802
  Alloc PE / Size       476802 / <1.82 TiB
  Free  PE / Size       0 / 0
  VG UUID               EOVpBU-W2PF-Z2vu-QZHB-DHfa-i2Ac-I8Hprm

  --- Volume group ---
  VG Name               vg0
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <893.75 GiB
  PE Size               4.00 MiB
  Total PE              228799
  Alloc PE / Size       228799 / <893.75 GiB
  Free  PE / Size       0 / 0
  VG UUID               mnxYaT-aQVU-R2Px-S0Cc-R5Vs-7X13-BfI4Wj

$ sudo vgrename mnxYaT-aQVU-R2Px-S0Cc-R5Vs-7X13-BfI4Wj old_vg0
  Processing VG vg0 because of matching UUID mnxYaT-aQVU-R2Px-S0Cc-R5Vs-7X13-BfI4Wj
  Volume group "mnxYaT-aQVU-R2Px-S0Cc-R5Vs-7X13-BfI4Wj" successfully renamed to "old_vg0"

$ sudo mount /dev/mapper/oldsystem  /mnt/old
mount: /mnt/old: unknown filesystem type 'LVM2_member'.

# https://www.svennd.be/mount-unknown-filesystem-type-lvm2_member/

$ sudo lvscan
  ACTIVE            '/dev/vg0/swap' [<128.88 GiB] inherit
  ACTIVE            '/dev/vg0/root' [1.69 TiB] inherit
  inactive          '/dev/old_vg0/swap' [32.10 GiB] inherit
  inactive          '/dev/old_vg0/root' [861.64 GiB] inherit

$ sudo vgchange -ay
  2 logical volume(s) in volume group "vg0" now active
  2 logical volume(s) in volume group "old_vg0" now active

$ sudo mount /dev/old_vg0/root /mnt/old
```

## Display problem

```
 Device 0 [GeForce GTX 1080 Ti] PCIe GEN 2@ 4x RX: 27.00 MB/s TX: 7.000 MB/s
 GPU 1873MHz MEM 5005MHz TEMP  89°C FAN  95% POW 249 / 270 W
 GPU-Util[|||||||||||||||||||88%] MEM-Util[           0.2G/11.7G] Encoder[     0%] Decoder[     0%]

 Device 1 [GeForce GTX 1080 Ti] PCIe GEN 3@ 8x RX: 20.00 MB/s TX: 3.000 MB/s
 GPU 1911MHz MEM 5005MHz TEMP  75°C FAN  56% POW 164 / 270 W
 GPU-Util[||||||||||         44%] MEM-Util[           0.2G/11.7G] Encoder[     0%] Decoder[     0%]

 Device 2 [GeForce GTX 1080 Ti] PCIe GEN 3@ 8x RX: 160.0 MB/s TX: 130.0 MB/s
 GPU 1632MHz MEM 5005MHz TEMP  86°C FAN  89% POW 159 / 270 W
 GPU-Util[|||||||||||||||    66%] MEM-Util[           0.2G/11.7G] Encoder[     0%] Decoder[     0%]

 Device 3 [GeForce GTX 1080 Ti] PCIe GEN 3@16x RX: 26.00 MB/s TX: 6.000 MB/s
 GPU 1657MHz MEM 5005MHz TEMP  89°C FAN  99% POW 183 / 270 W
 GPU-Util[|||||||||||||||||||88%] MEM-Util[|          0.8G/11.7G] Encoder[     0%] Decoder[     0%]

  PID        USER GPU    TYPE            MEM Command
 3296 cgorichanaz   3 Graphic       7Mo 0.1% ./insync
 4887 cgorichanaz   3 Graphic      12Mo 0.1% alacritty
87281        root   1 Compute     177Mo 1.5% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
32858        root   2 Compute     185Mo 1.6% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
72200        root   3 Compute     193Mo 1.7% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
 1669        root   0 Compute     208Mo 1.8% /opt/fah/cores/cores.foldingathome.org/Linux/AMD64/NVI
 3176 cgorichanaz   3 Graphic     223Mo 1.9% compton
 2919        root   3 Graphic     323Mo 2.8% /usr/lib/Xorg




$  lspci | grep VGA
07:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)
09:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)
42:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)
43:00.0 VGA compatible controller: NVIDIA Corporation GP102 [GeForce GTX 1080 Ti] (rev a1)



$ grep GP102-A /var/log/Xorg.0.log
[    47.721] (II) NVIDIA(0): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:67:0:0
[    47.888] (II) NVIDIA(GPU-1): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:7:0:0 (GPU-1)
[    47.937] (II) NVIDIA(GPU-2): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:9:0:0 (GPU-2)
[    47.987] (II) NVIDIA(GPU-3): NVIDIA GPU GeForce GTX 1080 Ti (GP102-A) at PCI:66:0:0


    143 [    47.722] (--) NVIDIA(GPU-0): DELL P2415Q (DFP-4): connected
    144 [    47.722] (--) NVIDIA(GPU-0): DELL P2415Q (DFP-4): Internal DisplayPort
    145 [    47.722] (--) NVIDIA(GPU-0): DELL P2415Q (DFP-4): 1440.0 MHz maximum pixel clock


$ nvidia-smi
Sun Nov 11 10:23:51 2018
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 410.66       Driver Version: 410.66       CUDA Version: 10.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 108...  Off  | 00000000:07:00.0 Off |                  N/A |
| 86%   84C    P2   194W / 270W |    205MiB / 11178MiB |     82%      Default |
+-------------------------------+----------------------+----------------------+
|   1  GeForce GTX 108...  Off  | 00000000:09:00.0 Off |                  N/A |
| 61%   76C    P2   205W / 270W |    197MiB / 11178MiB |     70%      Default |
+-------------------------------+----------------------+----------------------+
|   2  GeForce GTX 108...  Off  | 00000000:42:00.0 Off |                  N/A |
| 86%   83C    P2   163W / 270W |    189MiB / 11178MiB |     63%      Default |
+-------------------------------+----------------------+----------------------+
|   3  GeForce GTX 108...  Off  | 00000000:43:00.0  On |                  N/A |
| 88%   86C    P2   191W / 270W |    631MiB / 11175MiB |     65%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0      1937      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   193MiB |
|    1      1872      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   185MiB |
|    2      1860      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   177MiB |
|    3      2100      G   /usr/lib/Xorg                                280MiB |
|    3      2621      G   compton                                      150MiB |
|    3      2725      G   ./insync                                       7MiB |
|    3      8358      C   ...D64/NVIDIA/Fermi/Core_21.fah/FahCore_21   177MiB |
|    3      9322      G   alacritty                                     12MiB |
+-----------------------------------------------------------------------------+



$ nvidia-smi --query-gpu=pci.bus_id,pci.domain,pci.bus,pci.device,pci.device_id,pci.sub_device_id --format=csv
pci.bus_id, pci.domain, pci.bus, pci.device, pci.device_id, pci.sub_device_id
00000000:07:00.0, 0x0000, 0x07, 0x00, 0x1B0610DE, 0x247119DA
00000000:09:00.0, 0x0000, 0x09, 0x00, 0x1B0610DE, 0x247119DA
00000000:42:00.0, 0x0000, 0x42, 0x00, 0x1B0610DE, 0x247119DA
00000000:43:00.0, 0x0000, 0x43, 0x00, 0x1B0610DE, 0x247119DA


xorg.conf - Configuration File for Xorg 
https://www.x.org/archive/X11R6.8.0/doc/xorg.conf.5.html

    Integer     an integer number in decimal, hex or octal
    Real        a floating point number
    String      a string enclosed in double quote marks (")

Note: hex integer values must be prefixed with "0x", and octal values with "0". 
```
