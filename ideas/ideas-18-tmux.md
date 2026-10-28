# Idea 18: Tmux session lifecycle: research and recommendation

This note expands idea 18 from [ideas.md](./ideas.md). It documents how this
repository currently installs and starts Tmux, what the history tells us about
those choices, and a proposed set of changes to make the lifecycle consistent.
No Tmux configuration changes are made by this document.

## What the repository does today

| Surface | Current behavior | Assessment |
|---|---|---|
| Package installation | `tmux` is in the shared base package list in [`ansible/group_vars/all.yml`](../ansible/group_vars/all.yml). | This is the one consistent, active part of the Tmux setup. |
| Zsh startup | [`tmux.zsh`](../files/zsh/config/tmux/tmux.zsh) is sourced by the Zsh configuration. For an interactive shell outside Tmux, it uses `pgrep` to decide between `tmux new`, `tmux attach`, and `tmux`. | It attempts to avoid nesting, but infers Tmux state from process-name matches rather than asking Tmux to create or attach to a specific session. |
| User service | [`tmux.service`](../files/config/systemd/user/tmux.service) defines a detached `%u` session, waits five seconds before starting, uses `Type=forking`, kills the named session on stop, and has `Restart=always`. | The service is deployed as a dotfile, but it is not currently enabled by Ansible. Its startup delay and lifecycle policy are unexplained in the unit itself. |
| Ansible service task | The enable/start task is commented out in [`shell.yml`](../ansible/roles/base/tasks/shell.yml). The comment records a fresh-provision failure connecting to the user systemd bus during daemon reload. | This is a provisioning/user-manager availability problem, not a reason that all systemd user services are inherently unsuitable. |
| Oh My Zsh integration | The Tmux plugin is not enabled in [`plugins.zsh`](../files/zsh/config/tmux/plugins.zsh). | The shell config says enabling Oh My Zsh autostart while a systemd session was already running caused nested Tmux. Enabling another autostart mechanism would reintroduce competing ownership. |
| Sway terminal shortcut | [`config`](../files/config/sway/config) launches `alacritty -e tmux` for the regular terminal shortcut. | This starts Tmux directly and bypasses any Zsh-owned session policy; it may create a different default session than the shell route. |
| User documentation | The Tmux section in [`README.md`](../README.md) describes the shell auto-start and mentions the inactive service and disabled plugin. | It explains the split setup but does not state which mechanism is authoritative or how sessions should behave across terminals. |

## What the history suggests

- Commit [`029480f`](https://github.com/CNG/dotfiles/commit/029480f10e8f5079afbe998c0d97cdea9c4c0455), from September 2018, introduced starting Tmux with a systemd user service. The goal was to have a session ready independently of opening a terminal.
- Commit [`93818f5`](https://github.com/CNG/dotfiles/commit/93818f59d71784a92081ede77e38a94f0c9e13eb), from February 2019, revised the Zsh startup after Oh My Zsh autostart nested Tmux inside the already-running service session. The commit message explicitly says it was to avoid unnecessary process nesting. The replacement uses process checks to choose whether to start, attach, or create another session.
- The task to enable/start the user service was later commented out. The current comment records that a fresh provision failed to connect to the user bus during daemon reload. This means the service was not reliably activated as part of the documented install flow.
- The current repository still contains both mechanisms, plus a direct Sway launch path. The README was updated much more recently than the Tmux service design, but it records the service as inactive rather than resolving the overlap.

The history supports a distinction between the **intent** (keep terminal work in Tmux and avoid nesting) and the **implementation** (pre-start a systemd session, then infer session state with `pgrep`). The intention remains useful; the multiple, partly inactive implementations are the maintenance cost.

## Current guidance and trade-offs

Tmux already runs a server that can keep sessions alive after a client
detaches, and supports named sessions plus commands that create a session or
attach to it if it already exists. For a desktop where Tmux is needed when a
terminal is opened, a small interactive-shell entry point can therefore
start/attach without a separately pre-started daemon.

A systemd user service remains appropriate when there is a specific need to
start sessions before any terminal opens, run managed workloads independently
of a shell, or keep the user manager alive beyond login. It adds user-manager
enablement, environment propagation, unit lifecycle, and potentially lingering
requirements. Current ArchWiki documentation also describes a socket-activated
user-service approach for stronger systemd integration; this is more elaborate
than this repository's apparent local-terminal use case.

Relevant current references:

- [Tmux manual (`tmux(1)`)](https://man7.org/linux/man-pages/man1/tmux.1.html) — sessions, clients, and command behavior.
- [ArchWiki: Tmux](https://wiki.archlinux.org/title/Tmux) — desktop autostart options, including systemd user services and socket activation.
- [ArchWiki: systemd/User](https://wiki.archlinux.org/title/Systemd/User) — user-manager lifetime and the fact that its services do not automatically inherit shell environment variables.
- [systemd.service(5)](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html) — service types; it notes that `Type=forking` is discouraged in favor of service types that can track a foreground process or receive readiness notification, and recommends a PID file when forking is used.

## Recommendation

Use **one Zsh-owned policy for interactive terminals**, and do not start a
background Tmux service automatically. When a local interactive Zsh starts
outside an existing Tmux client, it should create or attach to one documented,
stable session name (for example, `main`). Tmux's own session command should
make the create-versus-attach decision, rather than `pgrep` guessing whether a
server or an attach process exists.

This is the smallest coherent fit for the current setup because the intended
entry point is an interactive terminal, Tmux is already installed everywhere,
and the service is not currently enabled reliably. It also avoids adding a
second supervisor for a server that Tmux itself starts on demand.

One UX decision should be made explicitly: attaching multiple terminal windows
to the same named session means those clients share that session's current
window state. If that is not desirable, retain automatic Tmux startup but
create a distinct session for each terminal instead; do not restore `pgrep`
heuristics. The proposed default here is the simpler shared `main` session,
with a documented way to open a plain shell or opt out of auto-attachment.

This recommendation is for interactive desktop terminals. If the requirement
changes to starting jobs at boot without login, keep systemd as the sole
owner instead and implement a deliberate user-service/socket-activation
design, with its environment, login/linger behavior, and session cleanup
specified and tested. Do not combine that with shell autostart.

## Proposed changes

1. **Make Zsh the sole owner of automatic startup.** In
   [`tmux.zsh`](../files/zsh/config/tmux/tmux.zsh), replace the process-name
   checks and three-way startup branch with one documented Tmux
   create-or-attach command using a stable session name.
2. **Use reliable shell guards.** Run it only for interactive shells with a
   terminal, only when Tmux is installed, and only when the shell is not
   already inside Tmux. Add a clear opt-out environment variable for plain
   interactive shells. Keep non-interactive commands, scripts, and shells
   launched inside Tmux untouched.
3. **Remove competing desktop startup.** Change the regular Sway terminal
   binding to launch the normal user shell, so it follows the same Zsh policy,
   or have it explicitly invoke the exact same named-session command. Prefer
   the normal shell route to avoid maintaining two implementations. Preserve
   the existing separate Bash shortcut if it is useful as a plain-shell
   escape hatch.
4. **Retire the unused systemd path.** Remove
   [`tmux.service`](../files/config/systemd/user/tmux.service) from deployed
   dotfiles and remove the commented service enablement block in
   [`shell.yml`](../ansible/roles/base/tasks/shell.yml). If the unit is kept as
   an example instead, clearly mark it non-deployed and document the distinct
   use case; do not leave it looking like an alternate active path.
5. **Keep the Oh My Zsh Tmux plugin disabled.** Remove obsolete commented
   autostart/plugin toggles from
   [`plugins.zsh`](../files/zsh/config/tmux/plugins.zsh) or explicitly document
   that shell autostart is implemented by `tmux.zsh`. There should be only one
   autostart hook.
6. **Document the lifecycle and controls.** Update the Tmux section of
   [`README.md`](../README.md) to say when a session starts, the chosen session
   name, what happens when multiple terminals open, how to opt out, and how
   to detach, reattach, list, and intentionally end sessions.
7. **Validate session and environment behavior.** Test first launch with no
   server, subsequent terminal launches, an already-running session, a shell
   nested inside Tmux, the opt-out path, a non-interactive Zsh command, the
   Sway terminal shortcut, and shell startup after logout/login. Confirm that
   an active session survives terminal closure and can be reattached. Check
   environment-sensitive workflows such as clipboard access and SSH-agent
   forwarding rather than relying on a unit's inherited environment.

The unit-specific cleanup is important: simply uncommenting its Ansible task
would not make the overall behavior simpler. It would leave two startup
owners, preserve a user-bus dependency in provisioning, and continue the
historical risk of nested or competing sessions.
