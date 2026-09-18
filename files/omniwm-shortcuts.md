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
| Option + Shift + ←↑→↓ | Swap window in that direction | Super + Shift + arrows |
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
| Option + Shift + `=` | Taller | Super + Shift + `=` |
| Option + Shift + `-` | Shorter | Super + Shift + `-` |

## Workspaces

| Shortcut | Action | Omarchy |
|---|---|---|
| Option + 1–9 | Go to workspace | Super + 1–9 |
| Option + Shift + 1–9 | Send window to workspace | Super + Shift + 1–9 |
| Option + Tab | Next workspace | Super + Tab |
| Option + Shift + Tab | Previous workspace | Super + Shift + Tab |
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
| Option + Shift + Space | Show/hide workspace bar | Super + Shift + Space |
| Option + Return | Dropdown (quake) terminal | Super + Return |

## OmniWM extras (no Omarchy equivalent)

| Shortcut | Action |
|---|---|
| Option + Shift + L | Toggle workspace layout (dwindle ↔ niri) |
| Option + Shift + O | Overview |
| Option + Shift + B | Balance sizes |
| Option + Shift + R | Raise all floating windows |

## Tiling behaviour

- Dwindle layout (Hyprland-style splits) on all workspaces
- 10px gaps between windows and at screen edges, 2px border
- Focus follows the mouse; keyboard focus moves the pointer to the window
- Focus and window moves cross to the next monitor at the screen edge
