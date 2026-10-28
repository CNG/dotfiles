# Idea 12: Configure server mounts and Dolphin shortcuts

This note expands idea 12 from [ideas.md](./ideas.md). It separates mount
availability from desktop bookmarks so either can be changed independently.

## What the repository does today

The README says server folders are missing from Dolphin. The dotfiles role
already has optional UUID-based local-volume mounts under a `volumes` variable,
but the shared variables shown do not define `volumes`. That task is not a
solution for network shares unless it is extended to model them correctly.
Dolphin places are stored in `files/local/share/user-places.xbel`.

Network shares introduce login, network availability, credential, and
shutdown behavior that local UUID mounts do not have.

## Recommendation

Model network mounts separately from local UUID volumes. Use systemd automount
or another on-demand mechanism when the server may be offline, and configure
Dolphin bookmarks as user-level navigation shortcuts. Keep credentials out
of public variables and ensure a missing server does not block boot or login.

## Proposed changes

1. Identify protocol, server/share path, mount path, and whether access is
   read-only or writable for each share.
2. Choose systemd automount/network-online dependencies and safe timeout/
   failure behavior appropriate to the protocol.
3. Store credentials in a private, permission-restricted file or a supported
   credential manager; do not put passwords in tracked Ansible variables.
4. Add Dolphin Places entries using the existing XBEL file or a managed
   user-level task, with stable labels and URLs.
5. Test unavailable server, reconnect, logout/shutdown, permissions, and
   access from Dolphin and command line.

## Current references

- [systemd.mount(5)](https://www.freedesktop.org/software/systemd/man/latest/systemd.mount.html)
  documents mount units and network dependencies.
- [systemd.automount(5)](https://www.freedesktop.org/software/systemd/man/latest/systemd.automount.html)
  documents on-demand mount activation.
- [Dolphin Places documentation](https://docs.kde.org/stable5/en/dolphin/dolphin/places-panel.html)
  describes user-visible Places/bookmarks.
