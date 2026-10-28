# Idea 1: Make a fresh install reliably recoverable

This note expands idea 1 from [ideas.md](./ideas.md). The goal is to preserve
the system's intentional package choices so a reinstall is repeatable without
mistaking every incidental dependency for a package that must be installed.

## What the repository does today

- Arch package lists live in `ansible/group_vars/all.yml`, split by roles and
  by official/AUR packages.
- `provision` installs Ansible and the playbook, but there is no apparent
  exported record of packages installed manually after provisioning.
- The README says the 2026 rebuild after an SSD failure lacked packages
  because a package list had not been exported.

The manifest in Ansible should remain the source of truth for intended
packages. A live package export supplements it: it helps identify drift and
manual additions, but should not automatically turn every machine-specific
package into a required dependency.

## Recommendation

Add a report/export command that records explicitly installed official
packages and foreign/AUR packages, tagged with machine and date. Compare it
with the Ansible-declared package set and review differences before promoting
packages into configuration. Keep secrets and private package repositories
out of the report.

Arch changes package versions continuously, so treat this as a list of package
names to rebuild, not a binary lockfile promising identical versions or
availability. Capture the official and AUR sets separately.

## Proposed changes

1. Add an export script using `pacman -Qqe` / `pacman -Qqm` (or equivalent
   explicit-package and foreign-package queries) with deterministic sorting.
2. Write to a user-selected backup location, not only to the same disk being
   rebuilt. Include hostname, timestamp, and the command/version used.
3. Add a comparison/report mode against the Ansible package variables; do not
   silently alter those variables from the live system.
4. Document how to restore official packages and how to review/rebuild AUR
   packages after reviewing their current PKGBUILDs.
5. Test export/import in a disposable Arch environment or VM, including
   missing and renamed packages.

## Current references

- [ArchWiki: Pacman/Tips and tricks](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks)
  documents explicit, foreign, and native package queries.
- [ArchWiki: System maintenance](https://wiki.archlinux.org/title/System_maintenance)
  explains that Arch maintenance and upgrades require active operator review.
- [ArchWiki: Arch User Repository](https://wiki.archlinux.org/title/Arch_User_Repository)
  describes the manual review/build nature of AUR packages.
