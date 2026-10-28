# Idea 8: Make display setup adapt to connected monitors

This note expands idea 8 from [ideas.md](./ideas.md), focusing on preserving
known-good per-monitor preferences while handling unfamiliar outputs safely.

## What the repository does today

The Sway config contains fixed rules for `eDP-1`, while `way-displays/cfg.yaml`
names `PHL 328E1`, fixes its mode and scale, and orders `DP-1` before the
laptop panel. Sway also launches way-displays. These are useful preferences
for known hardware, but names and docking arrangements vary.

Current way-displays documentation says it can respond to connect/disconnect
events and work without configuration, with device-specific configuration
available when needed. The project warns that source `master` is unstable;
the installed package/release should be checked before relying on newer
configuration fields.

## Recommendation

Use way-displays as the single owner of output layout and scaling. Keep
explicit preferences for recognized monitors and a predictable default for
unknown displays. Avoid simultaneously setting output modes in Sway and
way-displays, since two controllers can override each other.

## Proposed changes

1. Inventory the actual display names, modes, and desired scale at home and
   when docked.
2. Remove overlapping output directives from Sway, leaving way-displays to
   arrange outputs.
3. Keep named profiles for the known internal and Philips displays and define
   behavior for an unrecognized external monitor.
4. Document how to inspect output names/logs and change a profile; keep
   version-specific YAML aligned with the installed way-displays release.
5. Test hotplug, unplug, lid close/open, different port order, unsupported
   modes, and configuration reload.

## Current references

- [way-displays](https://github.com/alex-courtis/way-displays) documents
  dynamic output management, logging, and configuration.
- [way-displays configuration manual](https://github.com/alex-courtis/way-displays/blob/master/doc/way-displays.5.md)
  documents its YAML schema; verify against the deployed version.
- [Sway output configuration](https://man.archlinux.org/man/sway-output.5.en)
  documents native output commands and helps identify overlapping ownership.
