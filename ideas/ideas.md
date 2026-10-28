# Ideas for improving this system

These are potential improvements based on the current install scripts,
Ansible roles, and desktop configuration. Each includes a possible first
implementation rather than assuming a particular tool or workflow.

1. **[Make a fresh install reliably recoverable](./ideas-01-package-recovery.md)**
   - **What:** Keep a current inventory of installed packages, including
     explicitly installed AUR packages, and make it easy to restore after a
     disk failure.
   - **Why:** The README notes that a reinstall after an SSD crash was missing
     packages because no package list had been exported. A rebuild manifest
     would reduce setup time and the chance of missing important tools.
   - **Changes:** Add a script or Ansible task to export package inventories
     into a documented, versioned location; add a restore path and verify it
     against a clean installation.

2. **[Turn Btrfs snapshots into a tested backup plan](./ideas-02-btrfs-snapshots-backup.md)**
   - **What:** Automatically create and prune snapshots, and back up important
     personal data to a separate device or encrypted remote destination.
   - **Why:** The installer creates a snapshots subvolume, but a snapshot on
     the same disk cannot recover from disk failure and no snapshot schedule
     is apparent. A tested restore is more useful than a backup that has never
     been checked.
   - **Changes:** Add a snapshot schedule and retention policy, choose what
     should be backed up off-device, document restore steps, and periodically
     test restoring representative files.

3. **[Add stronger guardrails to disk setup](./ideas-03-disk-guardrails.md)**
   - **What:** Make the destructive install script verify the selected disk
     and require an unmistakable confirmation before repartitioning.
   - **Why:** `base` repartitions and formats the target device. A mistaken
     device path can destroy data on another disk.
   - **Changes:** Print the target device and its model/size/partitions before
     proceeding; require the user to type the device path to confirm; keep a
     clearly documented non-destructive path for users who are only reviewing
     the setup.

4. **[Bring the boot instructions and installer back into agreement](./ideas-04-encrypted-boot.md)**
   - **What:** Update encrypted-root boot setup to use one verified,
     current `mkinitcpio` and systemd-boot configuration.
   - **Why:** The README's TODO describes switching to `sd-encrypt` and
     UUID-based boot options, while `base_include` still edits the older
     `encrypt` hook and writes a label-based `cryptdevice` option. Divergence
     makes recovery and a fresh install harder to trust.
   - **Changes:** Generate the LUKS UUID during installation, use the matching
     hook and kernel parameters, remove stale instructions, and test both a
     fresh boot and the documented live-USB recovery procedure.

5. **[Make provisioning dependencies reproducible](./ideas-05-pin-ansible-aur-module.md)**
   - **What:** Pin the Ansible AUR module used by `provision` instead of
     downloading whatever is currently on its upstream `master` branch.
   - **Why:** A future upstream change or network outage could make a rebuild
     behave differently or fail, even when this repository has not changed.
   - **Changes:** Pin a reviewed release or commit, store the dependency in a
     tracked and maintainable way, and document how to update it.

6. **[Lock the session automatically before suspend](./ideas-06-sway-lock-suspend.md)**
   - **What:** Enable an inactivity lock and ensure suspend paths lock the
     screen before the machine sleeps.
   - **Why:** The Sway config has `swayidle` commented out, and its suspend and
     hibernate shortcuts invoke systemd directly. The current workflow can
     leave an unlocked session unattended.
   - **Changes:** Configure `swayidle` with an appropriate idle timeout and
     lock-before-suspend behavior; test manual suspend, lid close, and wake
     from both laptop and desktop sessions.

7. **[Make Sway media shortcuts dependable](./ideas-07-sway-media-controls.md)**
   - **What:** Audit the custom media-key bindings and use explicit,
     documented player-control commands.
   - **Why:** The Sway config references `$Prev`, `$Play`, and `$Next`, and one
     hardware-key binding spells the `playerctl` previous command as
     `previos`. These make media controls harder to rely on.
   - **Changes:** Define the referenced commands or replace them with direct
     `playerctl` invocations, correct the typo, and test the keys with Spotify
     and another MPRIS-compatible player.

8. **[Make display setup adapt to connected monitors](./ideas-08-display-profiles.md)**
   - **What:** Provide predictable monitor profiles for the laptop panel,
     current Philips display, and unfamiliar external displays.
   - **Why:** Sway bindings and the way-displays configuration name
     `eDP-1` and `PHL 328E1` directly. Those names and preferred scaling are
     hardware-specific, so docking or changing displays may require manual
     adjustment.
   - **Changes:** Keep device-specific preferences in way-displays profiles,
     define a sensible fallback for unknown outputs, and document how to
     switch or add a display profile.

9. **[Add a study-focused desktop mode](./ideas-09-study-mode.md)**
   - **What:** Create an optional shortcut or mode that opens a focused study
     workspace for Anki, reading, and notes while suppressing nonessential
     notifications.
   - **Why:** The configuration already launches Anki and has a
     do-not-disturb binding, but combining these into a repeatable workflow
     would make it easier to start and protect focused study time.
   - **Changes:** Add a Sway mode or small launch script that selects a
     workspace, launches the chosen study apps, and enables Mako's
     do-not-disturb mode; provide a simple way to exit and restore normal
     notifications.

10. **[Surface laptop battery and thermal problems sooner](./ideas-10-laptop-health.md)**
    - **What:** Add actionable low-battery warnings and make key health signals
      visible without opening diagnostic tools.
    - **Why:** The laptop role contains a low-battery warning service and
      timer, but their setup is commented out; CPU, memory, and temperature
      modules are also commented out in Waybar. Important problems can
      otherwise be easy to miss.
    - **Changes:** Re-enable or replace the low-battery notification with
      tested thresholds, selectively enable useful Waybar health modules,
      and verify their behavior on both battery and AC power.

11. **[Fix ownership as part of first-time provisioning](./ideas-11-home-file-ownership.md)**
     - **What:** Ensure files Ansible creates in the home directory are owned
       by the user, and only correct ownership on paths the setup manages.
     - **Why:** The README notes that home-folder items and SSH files can end up
       owned by root, and the dotfiles role has a commented-out ownership task.
       Incorrect ownership can break shell startup and make private files
       harder to maintain.
     - **Changes:** Review each task that creates home-directory files, use the
       intended user context or explicit owner/group settings, and add a
       targeted ownership correction for managed paths. Verify it with a
       fresh provision run.

12. **[Configure server mounts and file-manager shortcuts](./ideas-12-server-mounts-dolphin.md)**
     - **What:** Declare the server volumes to mount and make them easy to
       reach from Dolphin.
     - **Why:** The README calls out missing server mounts, while the dotfiles
       role already has optional UUID-based volume mounting. Wiring this up
       would remove repeated manual navigation and mounting.
     - **Changes:** Define each mount's UUID, path, and options in appropriate
       host-specific variables; decide how unavailable network storage should
       behave; and add or manage matching Dolphin bookmarks.

13. **[Separate machine profiles from shared configuration](./ideas-13-machine-profiles.md)**
     - **What:** Put hardware-specific and optional settings in explicit host
       or group variables instead of keeping all choices in one shared file.
     - **Why:** The playbook mixes common settings with hardware checks and
       feature flags, while the shared variables include a placeholder
       `dummyflag`. Clear profiles would make it easier to understand what
       differs between systems and avoid accidental application of a setting
       to the wrong machine.
     - **Changes:** Introduce an inventory with shared defaults and per-host
       overrides, move machine-specific values out of the common variables,
       remove unused placeholders, and document how to add a machine.

14. **[Add automated checks for configuration changes](./ideas-14-config-validation.md)**
     - **What:** Run lightweight checks on shell scripts, Ansible files, and
       the Sway configuration before changes are used on a machine.
     - **Why:** A typo or outdated directive can prevent a shell, playbook, or
       desktop session from starting correctly, and the repository currently
       has no obvious automated validation workflow.
     - **Changes:** Add focused checks such as shell syntax/linting,
       `ansible-playbook --syntax-check`, and Sway's configuration check;
       run them locally or in CI and document any checks that need a live
       session or installed system packages.

15. **[Make dotfiles bootstrapping use one consistent source setting](./ideas-15-dotfiles-bootstrap.md)**
     - **What:** Make the provisioning role clone the configured dotfiles
       repository automatically when it is missing, using the same variable
       that is defined in `group_vars`.
     - **Why:** The shared settings define `dotfiles.git_url`, but the clone
       task checks `dotfiles.url`; the README also describes manually copying
       the repository before provisioning. This makes first-time setup depend
       on extra undocumented-by-the-playbook steps.
     - **Changes:** Align the clone condition and source with the configured
       variable, ensure the destination and ownership are correct, and test
       provisioning both with and without an existing checkout.

16. **[Replace X11-oriented touchpad gestures with Wayland-native actions](./ideas-16-wayland-gestures.md)**
     - **What:** Audit the existing gesture configuration and make supported
       gestures work consistently in the Sway session.
     - **Why:** The gesture file sends `xdotool` key events, while Sway is a
       Wayland compositor and already has native swipe bindings. Keeping
       incompatible or unused mappings can make gestures confusing or
       ineffective.
     - **Changes:** Confirm whether the gesture daemon is installed and used;
       move supported actions to Sway's native bindings or a Wayland-compatible
       tool, remove obsolete mappings, and document the resulting gestures.

17. **[Make screenshots more resilient and consistent](./ideas-17-screenshots.md)**
     - **What:** Route screenshot keybindings through a small capture workflow
       that creates its destination and reports the exact saved filename.
     - **Why:** The current Sway bindings write directly to `~/Sorting`, which
       may not exist, and compute the timestamp again for the notification.
       A failed save or a notification with a different timestamp makes
       captures harder to find.
     - **Changes:** Check or create the destination directory, generate the
       timestamp once, quote output paths, and handle cancellation or save
       failures clearly for both region and display captures.

18. **[Choose and document one Tmux session lifecycle](./ideas-18-tmux.md)**
     - **What:** Decide whether Tmux sessions should be started by shell
       auto-attach or by the existing systemd user service, and make that path
       reliable.
     - **Why:** The repository defines a Tmux service but leaves its enablement
       commented out, while interactive shells also start or attach to Tmux.
       A single documented approach would reduce surprises across terminals
       and after disconnects.
     - **Changes:** Select one startup model, configure its user service or
       shell behavior accordingly, verify environment and socket handling, and
       update the Tmux documentation and cheatsheet.

19. **[Add a calm, actionable system-maintenance summary](./ideas-19-maintenance-summary.md)**
     - **What:** Provide a periodic or on-demand summary of pending system
       updates, failed services, available firmware updates, and disk health.
     - **Why:** The setup already installs firmware and disk diagnostic tools,
       but firmware metadata refresh is not paired with an obvious update
       check, and there is no single place to review basic maintenance status.
       A summary can make small issues easier to catch without automatically
       applying risky changes.
     - **Changes:** Add a user-invoked script or low-noise notification that
       reports selected checks, links each warning to a safe next step, and
       keeps update installation and firmware flashing under explicit user
       control.

20. **[Add a quick-capture path for notes and tasks](./ideas-20-quick-capture.md)**
     - **What:** Provide a keyboard shortcut to capture a short thought or task
       into a timestamped inbox without leaving the current application.
     - **Why:** Anki and Obsidian are already part of the installed workflow.
       A low-friction capture path can help preserve ideas while studying or
       working without opening a full editor.
     - **Changes:** Add a small prompt-and-append script and a Sway binding;
       choose a stable inbox location, handle empty or cancelled input, and
       send a notification confirming where the note was saved.
