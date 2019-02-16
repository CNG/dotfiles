# [Kernel modules](https://wiki.archlinux.org/index.php/Kernel_module)

* Modules stored in `/usr/lib/modules/$(uname -r)`
* Explicit loading configs in `/etc/modules-load.d/`
* `_` and `-` interchangeable in `/etc/modprobe.d/` and using `modprobe`
* `lsmod`: currently loaded
* `modinfo NAME`
* `modprobe -c`: detailed configuration of all modules
* `modinfo -p i915`: list of all options along with short descriptions and default values
* `systool -m i915 -av`: check which options are currently enabled

