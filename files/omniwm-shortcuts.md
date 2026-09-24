# Omarchy-style shortcuts (OmniWM on macOS)

Config: `~/.config/omniwm/settings.toml` (backed up in `~/repos/workstation-setup/files/omniwm/`).

Key translation from Omarchy/Hyprland:

| Omarchy | macOS |
|---|---|
| Super | Option |
| Alt | Control |
| Ctrl | Command |

## Focus and move windows

| Shortcut | Action | Omarchy |
|---|---|---|
| Option + ←↑→↓ | Move focus | Super + arrows |
| Option + Command + ←↑→↓ | Swap window in that direction | Super + Shift + arrows |
| Option + J | Toggle split direction | Super + J |
| Option + T | Toggle floating | Super + T |
| Option + F | Fullscreen (inside the layout) | Super + F |
| Control + Option + F | macOS native fullscreen | Super + Alt + F |
| Option + W | Close window | Super + W |
| Option + drag | Move window with the mouse | Super + left drag |

## Resize

| Shortcut | Action | Omarchy |
|---|---|---|
| Option + `=` | Wider | Super + `=` |
| Option + `-` | Narrower | Super + `-` |
| Option + Command + `=` | Taller | Super + Shift + `=` |
| Option + Command + `-` | Shorter | Super + Shift + `-` |

## Workspaces

| Shortcut | Action | Omarchy |
|---|---|---|
| Option + 1–9 | Go to workspace | Super + 1–9 |
| Option + Shift + 1–5 | Send window to workspace | Super + Shift + 1–5 |
| Option + Command + 6–9 | Send window to workspace | Super + Shift + 6–9 |
| Option + Tab | Next workspace | Super + Tab |
| Option + Command + ` | Previous workspace | Super + Shift + Tab |
| Option + Command + Tab | Last workspace you were on | Super + Ctrl + Tab |
| Option + S | Show/hide scratchpad | Super + S |
| Control + Option + S | Send window to scratchpad | Super + Alt + S |

## Monitors

| Shortcut | Action | Omarchy |
|---|---|---|
| Control + Option + Shift + ←↑→↓ | Move workspace to monitor | Super + Shift + Alt + arrows |
| Control + Command + Tab | Focus next monitor | – |
| Control + Command + `` ` `` | Focus last monitor | – |

## Menus, bar, terminal

| Shortcut | Action | Omarchy |
|---|---|---|
| Option + Space | Command palette | Super + Space |
| Control + Option + Space | App menu anywhere | Super + Alt + Space |
| Option + Command + Space | Show/hide workspace bar | Super + Shift + Space |
| Option + Return | Dropdown (quake) terminal | Super + Return |

## OmniWM extras (no Omarchy equivalent)

| Shortcut | Action |
|---|---|
| Option + Command + L | Toggle workspace layout (dwindle ↔ niri) |
| Option + Command + O | Overview |
| Option + Command + B | Balance sizes |
| Option + Command + R | Raise all floating windows |

## Known issues

Not working (tested 2026-09-18):

- Option + Command + Space — Show/hide workspace bar (Super + Shift + Space)
- Option + `=` — Wider (Super + `=`)
- Option + `-` — Narrower (Super + `-`)
- Option + Command + `=` — Taller (Super + Shift + `=`)
- Option + Command + `-` — Shorter (Super + Shift + `-`)
- Option + J — Toggle split direction (Super + J)

Confirmed working (tested 2026-09-18): Option + Command + B, Option + Command + L, Option + Command + O, Option + Command + R, Option + 1–9, Option + Command + 1–9, Option + Tab, Option + arrows, Option + Command + arrows, Option + T, Option + F, Option + W.

## Tiling behaviour

- Niri layout (column-based, new windows split to the right) on all workspaces; up to 3 columns visible at once (`visibleContainerCount = 3`)
- 10px gaps between windows and at screen edges, 2px border
- Focus follows the mouse; keyboard focus moves the pointer to the window
- Focus and window moves cross to the next monitor at the screen edge
- Send-to-workspace uses Option+Shift for workspaces 1–5, but Option+Command for 6–9, so Option+Shift+8/9 stay free to type `{`/`}` on the Swedish layout
- Other operations (swap, resize-taller/shorter, overview, etc.) still use Option+Command
