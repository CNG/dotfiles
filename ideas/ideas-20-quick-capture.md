# Idea 20: Add a quick-capture path for notes and tasks

This note expands idea 20 from [ideas.md](./ideas.md). It proposes a small,
reliable inbox capture rather than tightly coupling a hotkey to a particular
note application's internal database.

## What the repository does today

Anki and Obsidian are in the package configuration, and Sway has application
shortcuts, but no global quick-capture binding or inbox convention is present.
The current idea is intentionally open about whether captures become tasks,
study notes, or ideas.

## Recommendation

Start with a plain-text append-only inbox under a user-owned XDG data or
Obsidian vault path. Use a graphical prompt suitable for the Wayland desktop,
escape or quote input safely, and write one timestamped line per capture.
Provide a notification with the destination and preserve an easy path to
review and move items later.

## Proposed changes

1. Choose the canonical inbox path and format (for example, Markdown with a
   timestamp and plain text body); keep it outside the repository unless
   intentionally versioned.
2. Choose an installed prompt frontend that works under Wayland and define
   behavior for cancel, empty input, multiline text, and special characters.
3. Add a script that creates the parent directory, appends safely, checks
   write failures, and prints or notifies the exact destination.
4. Bind the script in Sway and document the shortcut and review habit.
5. Test Unicode, quotes, multiline input, cancellation, unavailable
   notification daemon, and a full/unwritable destination.

## Current references

- [Sway(5)](https://man.archlinux.org/man/sway.5.en) documents keyboard
  bindings and command execution.
- [bemenu](https://github.com/Cloudef/bemenu) documents a Wayland-compatible
  menu frontend already used by the desktop's launcher setup.
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)
  provides conventions for user data locations.
- [Obsidian URI](https://help.obsidian.md/Extending+Obsidian/Obsidian+URI)
  may be useful if a later version should create or open a note in the vault.
