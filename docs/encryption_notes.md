## Mounting this encrypted system drive in another system

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


