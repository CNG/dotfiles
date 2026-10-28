# Idea 10: Surface laptop battery and thermal problems sooner

This note expands idea 10 from [ideas.md](./ideas.md), with an emphasis on
useful warnings rather than adding every sensor to the bar.

## What the repository does today

The laptop role installs `turbostat` and `powertop`, while a low-battery
script/service/timer exists in the role but is commented out. Waybar shows
battery state; CPU, memory, and temperature modules are configured but
commented out of the active module list. TLP setup is also commented out.

This suggests the system has diagnostic tools but no active, validated
low-battery workflow. Sensor availability depends on the laptop, kernel, and
driver, so exposing metrics should be selective.

## Recommendation

Use UPower or another stable system source for battery state and warning
thresholds, then add only the few health signals that lead to an action.
Keep thermal data optional where hardware exposes a reliable sensor. Avoid
polling every second for slow-changing values.

## Proposed changes

1. Choose one battery-warning owner (desktop power manager or a user service)
   to prevent duplicate alerts.
2. Configure low/critical thresholds and ensure suspend/shutdown behavior is
   consistent with the system's actual battery reporting.
3. Enable relevant Waybar modules with useful intervals and clear units; omit
   unavailable sensor modules rather than showing stale or misleading values.
4. Verify behavior on AC, battery discharge, charging, low charge, and a
   laptop with missing thermal sensors.
5. Document which signal warrants which action and how to disable alerts.

## Current references

- [UPower documentation](https://upower.freedesktop.org/docs/) documents
  battery properties and power-device monitoring.
- [Waybar modules](https://github.com/Alexays/Waybar/wiki/Module:-Battery)
  documents battery display and states; see also its CPU and temperature
  module pages.
- [ArchWiki: Power management](https://wiki.archlinux.org/title/Power_management)
  discusses coordinating power tools.
