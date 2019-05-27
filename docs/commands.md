Some commands I keep needing to look up that don't fit in the other pages:

[Rfkill caveat](https://wiki.archlinux.org/index.php/Wireless_network_configuration#Rfkill_caveat)

* `rfkill list`: current status
* `rfkill unblock wifi`: remove soft block (hard block means physical button)

* `echo "×" | od -t x1`: show hex codes for characters
* `echo "×" | od -xc --endian=big`: show hex codes for characters
* `echo "×" | hexdump -C`: show hex codes for characters big endian
* `xxd -b FILE | head | cut -b10-62`: show binary of file

* `xprop`

* `xinput set-prop "Expert Wireless TB Mouse" "Coordinate Transformation Matrix" 2 0 0 0 2 0 0 0 1`
* `xinput set-prop "Expert Wireless TB Mouse" "libinput Natural Scrolling Enabled" 0`

* `pacman -Qi qt4`: show packages that depend on, among other info.

* `vim $(ack -l 'string')`
