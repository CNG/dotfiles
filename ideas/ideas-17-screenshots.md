# Idea 17: Make screenshots more resilient and consistent

This note expands idea 17 from [ideas.md](./ideas.md). The proposed workflow
keeps the existing grim/slurp approach but adds reliable path, cancellation,
and feedback behavior.

## What the repository does today

Sway's region and focused-output bindings call `grim` and write to
`~/Sorting/$(date ...)`. The commands do not ensure that directory exists,
and the region command calls `date` again in the notification, so its
message can differ from the saved filename if the clock ticks between calls.
The selection command also needs explicit cancellation handling.

## Recommendation

Use a small script as the one screenshot entry point. Generate the filename
once, ensure the destination exists, quote all paths, check command exit
statuses, and report success only after the image is written. Treat user
cancellation as a normal non-error outcome; report actual capture failures.

## Proposed changes

1. Decide whether `~/Sorting` is the permanent destination or make it a
   configurable XDG Pictures/Screenshots path.
2. Implement region and focused-output capture modes in one helper with
   strict quoting and a single timestamp value.
3. Create the directory with private-appropriate permissions and handle
   missing `grim`, `slurp`, or output selection explicitly.
4. Show the exact saved path after success; do not notify on failed capture.
5. Update both Sway bindings to call the helper.
6. Test path spaces, absent destination, selection cancel, multiple displays,
   and failure to write.

## Current references

- [grim](https://github.com/emersion/grim) documents Wayland screenshot
  capture and output/geometry options.
- [slurp](https://github.com/emersion/slurp) documents interactive region
  selection.
- [Sway(5)](https://man.archlinux.org/man/sway.5.en) documents binding shell
  commands.
