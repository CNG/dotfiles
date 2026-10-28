# Idea 16: Replace X11-oriented gestures with Wayland-native actions

This note expands idea 16 from [ideas.md](./ideas.md). It recommends first
finding which gesture system is actually active before replacing or deleting
the existing configuration.

## What the repository does today

`files/config/libinput-gestures.conf` maps gestures to `xdotool` keystrokes
and includes comments describing i3 focus behavior. Sway's own config already
has native four-finger workspace swipes. The reviewed package lists do not
establish that `libinput-gestures` is installed or autostarted, so it may be
an unused legacy file rather than an active input path.

Wayland clients generally cannot use X11 automation tools to inject input
into native Wayland applications. Sway compositor bindings are a more
reliable place for compositor-wide actions when the gesture is supported.

## Recommendation

Inventory the active daemon/package and test current gestures. Keep
compositor-level gestures in Sway's native bindings. For unsupported
gestures, choose a maintained Wayland-compatible gesture tool only if it
supports the current Sway/libinput setup and provides safe, user-visible
configuration.

## Proposed changes

1. Determine whether `libinput-gestures` is installed, enabled, and consuming
   this file; inspect its logs and session startup.
2. Remove obsolete i3/X11 mappings if no longer used.
3. Retain or adjust native Sway swipe bindings and document gesture count,
   direction, and action.
4. If adding another daemon, install and start it explicitly, avoid duplicate
   gesture ownership, and explain its Wayland permission/runtime needs.
5. Test gestures on the actual touchpad and ensure applications retain
   expected browser navigation behavior.

## Current references

- [Sway(5)](https://man.archlinux.org/man/sway.5.en) documents native
  gesture bindings.
- [libinput-gestures](https://github.com/bulletmark/libinput-gestures)
  documents its daemon and X11-oriented action examples; verify current
  Wayland support before using it.
- [Wayland security model](https://wayland.freedesktop.org/docs/html/ch04.html)
  explains why global input injection differs from X11.
