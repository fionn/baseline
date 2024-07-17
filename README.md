# Baseline

A basic statusline for Neovim.

## Overview

We show mode, relative file path, Git branch if available, buffer, filetype, line, column, total lines and percentage, in order.

Git integration is via [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim), the only dependency, and it will fail gracefully if missing. We also show (buffer-based) clean / dirty state via an asterisk after the branch name.

Modes are displayed by default in a short form, somewhat Helix-style. These can be overridden. Each mode is displayed in its own highlight group which should be configured in a colorscheme.

## Configuration

### Setup

```lua
require("baseline").setup {}
```

`setup` optionally takes a map of mode strings to names to override how the mode is displayed.
See [`:h mode()`](https://neovim.io/doc/user/builtin.html#mode()) for what mode strings exist.

For example, invoke with
```lua
require("baseline").setup {
    modes = {n = "Normal"}
}
```
to display `Normal` when in normal mode.

### Highlight Groups

Modes are displayed in highlight groups of the form `StatusLineModeX` where `X` is `Normal`, `Insert`, `Visual`, `Replace`, `Command`, `Terminal` or `Unknown`.

If we enter a mode that this plugin does not know about, it will pass the raw mode string to the statusline and, if its prefix does not match existing mode strings (i.e. we cannot infer that it is a variant of a known mode), display it in the `StatusLineModeUnknown` highlight group.
This is for the edge case where Neovim may in future introduces new modes.

Use
```lua
local highlights = {
    -- StatusLine and WildMenu can be omitted, but it's recommended to set them
    -- to make everything match.
    StatusLine = {fg = "Black", bg = "NvimLightGrey4"},
    WildMenu = {fg = "NvimLightGrey3", bg = "None"},

    StatusLineModeNormal = {fg = "Black", bg = "NvimDarkBlue", bold = true},
    StatusLineModeInsert = {fg = "Black", bg = "Green", bold = true},
    StatusLineModeVisual = {fg = "Black", bg = "NvimDarkGrey4", bold = true},
    StatusLineModeReplace = {fg = "Black", bg = "NvimDarkRed", bold = true},
    StatusLineModeCommand = {fg = "NvimLightGrey4", bg = "Grey8", bold = true},
    StatusLineModeTerminal = {link = "StatusLineModeCommand"},
    StatusLineModeUnknown = {fg = "Black", bg = "DarkOrange3", bold = true}
}

for group, options in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, options)
end
```
for colours relatively consistent with the default theme.
