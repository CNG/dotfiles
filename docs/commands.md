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

## Packages

* Search to package name only with ERE `$ pacman -Ss '^vim-'`
* Search already installed `-Qs`
* Display extensive info `-i` or include backup files `-ii`
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
