Some commands I keep needing to look up that don't fit in the other pages:

[Rfkill caveat](https://wiki.archlinux.org/index.php/Wireless_network_configuration#Rfkill_caveat)

* `rfkill list`: current status
* `rfkill unblock wifi`: remove soft block (hard block means physical button)

* `echo "×" | od -t x1`: show hex codes for characters
* `echo "×" | od -xc --endian=big`: show hex codes for characters
* `echo "×" | hexdump -C`: show hex codes for characters big endian
* `xxd -b FILE | head | cut -b10-62`: show binary of file

* `xprop` and `xev`

* `xinput set-prop "Expert Wireless TB Mouse" "Coordinate Transformation Matrix" 2 0 0 0 2 0 0 0 1`
* `xinput set-prop "Expert Wireless TB Mouse" "libinput Natural Scrolling Enabled" 0`

* `vim $(ack -l 'string')`

* `ffmpeg -safe 0 -f concat -i <(find . -maxdepth 1 -type f -name '*.MP4'
  -printf "file '$PWD/%p'\n" | sort) -map_metadata 0 -c copy "concat_$(basename
  $(find . -maxdepth 1 -type f -name '*.MP4' -printf "%p" | sort | head -n1))"`

## Journal

    journalctl --list-boots
    journalctl --since "2 days ago"
    journalctl --since "2015-06-26 23:15:00" --until "2015-06-26 23:20:00"
    journalctl -u nginx.service -u mysql.service
    journalctl --output short-monotonic  # more time precision
    journalctl -b -1  -p "emerg".."crit"
    journalctl _UID=$(id --user cgorichanaz)
    # Show fields with
    journalctl --output verbose
    # or
    man systemd.journal-fields
    # Show existing entries for field name
    journalctl -F _GID
    journalctl /usr/bin/bash
    journalctl -k  # or --dmesg, limit results to kernel only
    journalctl --no-pager


## Open files

    $ sudo lsof | wc -l
    lsof: WARNING: can't stat() fuse.gvfsd-fuse file system /run/user/1000/gvfs
          Output information may be incomplete.
    220699
    
    $ sudo sysctl fs.file-nr
    fs.file-nr = 7936       0       9223372036854775807
    
    $ sudo sysctl fs.file-max
    fs.file-max = 9223372036854775807

## Formatting

    # Identify /dev address with lsblk or fdisk -l
    sudo fdisk /dev/sdg
    # d: delete partitions (repeat till none)
    # maybe only need if >2TB? g: new GPT disk label
    # n: create partition, use defaults
    # w: write and exit
    # restart or unmount, use mount to find where mounted
    sudo mkfs.ext4 /dev/sdg1


## Benchmarking

Check disk performance: `sudo hdparm -Tt /dev/sda`

`hdparm` should not be used to benchmark a RAID, because it provides very inconsistent results.

* `sysbench --test=cpu run`
* `sysbench --test=memory run`
* `sysbench --test=fileio --file-test-mode=seqwr run`

Or Geekbench

    wget -qO- http://cdn.geekbench.com/Geekbench-5.1.0-Linux.tar.gz | sudo tar --transform 's/^Geekbench-5.1.0-Linux/geekbench/' -xvz -C /opt
    /opt/geekbench/geekbench5
    # https://browser.geekbench.com/v5/cpu/1186956



## LVM

* There is no "official" GUI tool for managing LVM volumes, but
[`system-config-lvm`](https://aur.archlinux.org/packages/system-config-lvm/)
covers most of the common operations.
* `sudo pvdisplay -v -m` to see physical segments
* `sudo vgdisplay` to see your free PE

## RAID

    sudo mdadm --detail /dev/md127

If the device is being reused or re-purposed from an existing array, erase any
old RAID configuration information:

    sudo mdadm --misc --zero-superblock /dev/<drive>

Note: It is possible to create a RAID directly on the raw disks (without
partitions), but not recommended because it can cause problems when swapping
a failed disk.

If using RAID0, I guess there's no extra risk in creating RAID on raw disks?

    sudo mdadm --create --verbose --level=0 --chunk=8K --raid-devices=3 /dev/md/docs /dev/sdc /dev/sdd /dev/sde

Smaller chunk size (512 to 8K) good for larger average I/O requests, as you're
reading from multiple disks at once. Larger chunk size above 64K good for
smaller average I/O, as you're likelier to write an entire request to one disk.

View progress:

    cat /proc/mdstat

stride (2) = chunk size (8K) / block size (4K)
stripe width = number of data disks (3) * stride (2)

    sudo mkfs.ext4 -v -L docs -m 0 -b 4096 -E stride=2,stripe-width=6 /dev/md126


## Packages

* Search to package name only with ERE `$ pacman -Ss '^vim-'`
* Search already installed `-Qs`
* Display extensive info `-Qi`/`-Si` or include backup files `-ii`
* List files installed by package `-Ql` or remote package `-Fl`
* Verify files are present `-Qk` or more thoroughly `-Qkk`
* Find package for file: `$ pacman -Qo /path/to/file_name`
* List orphans `-Qdt` or "explicitly installed orphans `-Qet`
    *  `-t, --unrequired`: Restrict or filter output to print only packages
       neither required nor optionally required by any currently installed
       package. Specify this option twice to include packages which are
       optionally, but not directly, required by another package.


* `pacman -Qi qt4`: show packages that depend on, among other info.

Download a package without installing it:

    # pacman -Sw package_name

Install a 'remote' or 'local' package that is not from a remote repository (e.g.
the package is from the AUR):

    # pacman -U http://www.example.com/repo/example.pkg.tar.xz
    # pacman -U /path/to/package/package_name-version.pkg.tar.xz
    # Or to keep a copy of the local package in pacman's cache, use:
    # pacman -U file:///path/to/package/package_name-version.pkg.tar.xz

If explicitly installing an optional dependency, use `--asdeps` so it won't be
orphaned later. You can change this after the fact with `pacman -D --asdeps
package_name` or `--asexplicit`. TODO: Build this into the Ansible configs such
that orphaned packages can be automatically removed easily.

Search for a package that contains a specific file

    # Sync the files database:
    # pacman -Fy
    # Search for a package containing a file, e.g.:
    $ pacman -F pacman

TODO: set a cron job or a systemd timer to sync the files database regularly

Pacman stores its downloaded packages in /var/cache/pacman/pkg/ and does not
remove the old or uninstalled versions automatically. The paccache script,
provided within the pacman-contrib package, deletes all cached versions of
installed and uninstalled packages, except for the most recent 3, by default.
Use `-kN` to limit (`paccache -rk5`), or `-u` to limit to uninstalled packages
(`paccache -ruk0`).

Refresh keys with `pacman-key --refresh-keys`. Manually upgrade
archlinux-keyring package first `pacman -Sy archlinux-keyring && pacman -Su`.
