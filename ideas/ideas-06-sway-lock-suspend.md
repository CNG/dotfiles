# Idea 6: Lock the Sway session before suspend

This note expands idea 6 from [ideas.md](./ideas.md), combining idle locking
with the suspend paths already in the Sway configuration.

## What the repository does today

The Sway config defines a `swaylock` command, but the `swayidle` launch and
DPMS idle rules are commented out. The system mode invokes `systemctl suspend`
and `systemctl hibernate` directly; the `swayidle` `before-sleep` event is not
wired into that path.

`swayidle -w` can wait for its before-sleep command to finish, but the
inhibitor delay has a system limit. Correct behavior must be tested with the
actual locker, session, and power-management settings.

## Recommendation

Run one `swayidle` process in the logged-in Sway session with a modest
inactivity timeout, lock before sleep, and optional display power-down after
locking. Use the same lock command for manual suspend and idle sleep; avoid
multiple independent idle managers racing each other.

## Proposed changes

1. Add `swayidle` to the Sway package dependencies if it is not already
   installed, and start it once from the session.
2. Define a single lock command and use it for timeout and `before-sleep`.
3. Use `swayidle -w` and `swaylock -f` so the compositor reports a completed
   lock before proceeding; retain a reasonable inhibitor timeout.
4. Decide whether lid-close policy belongs to `logind` or the compositor, and
   avoid duplicate or conflicting suspend behavior.
5. Test idle timeout, user activity/resume, keyboard-initiated suspend,
   hibernate, lid close, external displays, and lock failure.

## Current references

- [swayidle(1)](https://man.archlinux.org/man/swayidle.1.en) documents
  `timeout`, `before-sleep`, and `-w`.
- [swaylock(1)](https://man.archlinux.org/man/swaylock.1.en) documents the
  foreground option used to coordinate locking.
- [systemd-logind settings](https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html)
  describe lid and sleep actions.
