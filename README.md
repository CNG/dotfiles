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


