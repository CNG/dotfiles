# Idea 19: Add a calm, actionable system-maintenance summary

This note expands idea 19 from [ideas.md](./ideas.md). The goal is an
on-demand health report, not unattended package upgrades or firmware flashing.

## What the repository does today

The base package tasks install `fwupd` and refresh its metadata, but the
update-check task is commented out. The package list includes `nvme-cli` and
`smartmontools`; there is no single user-facing report that connects those
tools with pending OS updates or failed services.

Arch package updates require the package database to be synchronized
consistently with a full system upgrade; a report should not encourage partial
upgrades or execute a broad upgrade automatically. SMART/NVMe results also
vary by device and should be presented as signals, not guarantees of disk
health.

## Recommendation

Provide a user-invoked script that runs read-only checks, labels unavailable
checks as unavailable, and prints concise next steps. Keep all update,
firmware, and repair actions explicit and interactive. Start with a CLI report;
add a low-frequency notification only if the CLI proves useful.

## Proposed changes

1. Define checks: failed system services, package update availability,
   firmware update availability, and supported disk health summaries.
2. Use non-mutating commands; ensure package checks follow Arch's full-upgrade
   model and never refresh/install packages silently.
3. Handle privileges per check and distinguish unsupported hardware from
   actual failures.
4. Add a plain-text summary with the command to investigate each warning.
5. If scheduling is later desired, use a low-noise systemd user timer and
   avoid running expensive hardware checks too frequently.
6. Test on a system with no pending updates, no supported firmware device,
   missing privileges, and a failed service.

## Current references

- [ArchWiki: System maintenance](https://wiki.archlinux.org/title/System_maintenance)
  discusses full system upgrades and maintenance.
- [fwupdmgr(1)](https://fwupd.github.io/fwupd/man/fwupdmgr.html) documents
  metadata refresh and read-only update checks.
- [smartctl(8)](https://man.archlinux.org/man/smartctl.8.en) and
  [nvme-cli](https://github.com/linux-nvme/nvme-cli) document device-specific
  health reporting.
- [systemctl(1)](https://www.freedesktop.org/software/systemd/man/latest/systemctl.html)
  documents listing failed units.
