# Idea 2: Turn Btrfs snapshots into a tested backup plan

This note expands idea 2 from [ideas.md](./ideas.md), distinguishing quick
local rollback from independent backup and recovery.

## What the repository does today

`base` creates Btrfs subvolumes for root, home, caches, logs, swap, and
snapshots. The README describes a disk failure but does not document an
automated snapshot policy or a separate backup target. The snapshot
subvolume's existence alone does not create snapshots.

Btrfs snapshots are useful for short-term recovery from accidental changes,
but they are not backups: they share the filesystem's device and are not
recursive across nested subvolumes. A root snapshot will not automatically
include content in separately mounted home/cache subvolumes.

## Recommendation

Treat these as two separate services: a modest local snapshot schedule for
rollback, and an encrypted, independently stored backup for irreplaceable
data. First decide which subvolumes and user directories matter, then choose
tools and retention around those recovery requirements. Avoid snapshotting
high-churn caches or swap without a clear reason.

For Btrfs send/receive, use read-only snapshots and preserve the incremental
send chain; changing a received snapshot can invalidate assumptions used by
incremental replication. Do not claim a backup is working until a restore has
been tested.

## Proposed changes

1. Define covered paths and exclusions, explicitly accounting for the
   separately mounted `home`, cache, log, and snapshot subvolumes.
2. Select a maintained snapshot tool or small systemd timer/service; specify
   cadence, retention, naming, and free-space behavior.
3. Select an off-device destination and encryption model; keep credentials
   outside public dotfiles.
4. Add a restore guide for one file, one subvolume, and full-system recovery
   from installation media.
5. Run scheduled restore drills to a temporary directory and alert on missed
   backups or failed integrity checks.

## Current references

- [Btrfs documentation: Subvolumes](https://btrfs.readthedocs.io/en/latest/Subvolumes.html)
  explains snapshot semantics, non-recursive nested subvolumes, and why a
  snapshot is not a backup.
- [btrfs-send(8)](https://btrfs.readthedocs.io/en/latest/btrfs-send.html)
  documents replication streams and incremental send/receive.
- [ArchWiki: Btrfs](https://wiki.archlinux.org/title/Btrfs) discusses common
  snapshot and backup tooling.
