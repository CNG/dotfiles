# Idea 7: Make Sway media shortcuts dependable

This note expands idea 7 from [ideas.md](./ideas.md). It proposes making
hardware keys, custom Hyper bindings, and player selection consistent.

## What the repository does today

The Sway config maps hardware media keys to `playerctl`, but the previous
binding is misspelled as `previos`. Separate Hyper-key bindings reference
`$Prev`, `$Play`, `$Next`, `$LowerVolume`, `$RaiseVolume`, and `$Mute`, with no
definitions visible in the reviewed config. This can leave those shortcuts
unusable even though the bindings look present.

The Waybar media module uses MPRIS through a custom Playerctl Python script;
this is an existing pattern to reuse rather than introduce another player
control library.

## Recommendation

Define one explicit set of media and audio commands and use it for both
hardware and custom keys. Use Playerctl's MPRIS controls for play/pause,
previous, and next; leave volume keys as PipeWire/PulseAudio controls where
that is the established system behavior. Decide whether player selection is
automatic or pinned to a named player.

## Proposed changes

1. Fix the previous-track command and resolve every undefined variable
   referenced by the Hyper bindings.
2. Consolidate duplicate commands into Sway variables or a clearly scoped
   helper, preserving the existing locked-key behavior where needed.
3. Decide and document how commands behave when multiple MPRIS players are
   present; optionally show failure feedback if no player is available.
4. Validate the Sway configuration and test with Spotify, a second MPRIS
   player, no active player, and muted/unavailable audio devices.

## Current references

- [Playerctl](https://github.com/altdesktop/playerctl) documents MPRIS player
  commands and player selection.
- [Sway(5)](https://man.archlinux.org/man/sway.5.en) documents key bindings,
  variables, and command execution.
- [Waybar custom module](https://github.com/Alexays/Waybar/wiki/Module:-Custom)
  is relevant if a helper script is used to report command status.
