# Idea 9: Add a study-focused desktop mode

This note expands idea 9 from [ideas.md](./ideas.md). It describes a reversible
workflow for getting into a study workspace, not a requirement to automate
how Anki or notes must be arranged.

## What the repository does today

Sway binds Anki to `$mod+k` and binds `$mod+Shift+m` to add Mako's
do-not-disturb mode. Anki and Obsidian are in the package list. There is no
combined study launcher or matching shortcut that restores the prior
notification state.

## Recommendation

Implement a small, explicit Sway mode or script that switches to a designated
workspace, starts only the chosen applications if they are not already
running, and enables a named Mako mode. Provide an obvious exit action that
restores notifications. Prefer toggling a named notification mode over
blindly stacking modes.

## Proposed changes

1. Decide the study workspace number/name and which applications are
   actually part of the desired routine.
2. Define a named Mako do-not-disturb mode and use its documented enter/exit
   commands.
3. Add a Sway binding or mode for starting the workflow and a predictable
   binding to end it.
4. Handle already-running applications without opening duplicate windows or
   launching extra Anki instances.
5. Test repeated activation, exit after partial launch, notifications during
   focus mode, and normal notification restoration after Sway reload.

## Current references

- [Sway(5)](https://man.archlinux.org/man/sway.5.en) documents modes,
  workspace commands, and bindings.
- [Mako documentation](https://github.com/emersion/mako) documents named
  modes and `makoctl`.
- [Anki command-line options](https://docs.ankiweb.net/platform/linux.html)
  describes Linux startup behavior; verify the installed package's desktop
  entry before choosing an invocation.
