# Idea 3: Add stronger guardrails to disk setup

This note expands idea 3 from [ideas.md](./ideas.md). The installer is
intentionally powerful; the improvement is to make the destructive target
obvious and require a deliberate confirmation before it is touched.

## What the repository does today

The top-level `base` script accepts a root-device argument, derives partition
names, and later asks whether to create new partitions. On confirmation it
uses `parted`, `sgdisk`, `mkfs.vfat`, and LUKS formatting. The README warns
that identifiers must be checked, but the script does not first print a
hardware-readable target summary or require the exact device path as a
confirmation.

The second prompt is not a complete guard: a user can misunderstand which
device the supplied path refers to, and the script continues with mounts and
filesystem creation after that branch.

## Recommendation

Fail closed before any destructive command unless the target is a whole block
device and a confirmation matches the resolved target. Show model, capacity,
transport, and existing partitions using system tools; require an explicit
interactive confirmation and provide a non-destructive inspection mode.
Never infer the disk from “largest” or “first” device.

## Proposed changes

1. Validate the argument exists and resolves to a block device; reject a
   partition path, mounted target, and unsupported device node.
2. Display `lsblk` details and all partitions/mounts for the proposed disk.
3. Require the exact canonical device path to be typed before partitioning;
   abort safely on EOF, non-interactive input, or mismatch.
4. Place all destructive operations behind one explicit confirmation branch
   and make every later use refer to the validated device variable.
5. Add a dry-run/inspection option and document that it does not guarantee
   the live disk state remains unchanged before the real run.
6. Test with loop devices in a disposable VM, including wrong paths, mounted
   devices, NVMe naming, and cancellation; never test against a real data disk.

## Current references

- [lsblk(8)](https://man7.org/linux/man-pages/man8/lsblk.8.html) documents
  machine-readable block-device inventory.
- [sgdisk(8)](https://man.archlinux.org/man/sgdisk.8.en) and
  [parted(8)](https://man.archlinux.org/man/parted.8.en) document the
  destructive partitioning tools used by the installer.
- [ShellCheck](https://www.shellcheck.net/) can catch shell issues, but it
  cannot prove an installer selects the correct physical disk; destructive
  integration tests need disposable block devices.
