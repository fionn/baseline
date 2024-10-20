# Baseline

A basic statusline for Neovim.

<div align="center">
    <img width="646" alt="Example baseline statusline in normal mode" src="https://github.com/user-attachments/assets/3f406bdc-40c5-41d4-acc3-b8055a22c1a1">
</div>

## Overview

Baseline is an extremely fast (negligible start-up time), small (~100 LoC), pure Lua, minimal statusline for Neovim.
It is close to stock, with additional mode display and opportunistic Git branch and buffer-specific clean or dirty state.
Modes are shown by default in a short form, somewhat Helix-style; this is configurable.

It displays mode, relative file path, modification flags, Git branch if available, buffer, filetype, line, column, total lines and percentage, in order.

Git integration is optional, via [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) (the only dependency). If missing the Git information is omitted.

## Configuration

### Setup

> [!NOTE]
> It is not required to call `setup`. This is only useful if you want to override the default options.

```lua
require("baseline").setup {}
```

`setup` optionally takes a table with a `modes` element, a map of mode strings to names, which can be used to override how the mode is displayed.
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

If we enter a mode that we do not know about, it will pass the raw mode string to the statusline and, if its prefix does not match existing mode strings (i.e. we cannot infer that it is a variant of a known mode), display it with the `StatusLineModeUnknown` highlight group.
This is for the edge case where Neovim may in future introduce new modes.

We make no attempt to style these highlight groups, only to expose them.
Use something like
```lua
local highlights = {
    StatusLineModeNormal   = {fg = "Black", bg = "NvimDarkBlue", bold = true},
    StatusLineModeInsert   = {fg = "Black", bg = "Green", bold = true},
    StatusLineModeVisual   = {fg = "Black", bg = "NvimDarkGrey4", bold = true},
    StatusLineModeReplace  = {fg = "Black", bg = "NvimDarkRed", bold = true},
    StatusLineModeCommand  = {fg = "NvimLightGrey4", bg = "Grey8", bold = true},
    StatusLineModeTerminal = {link = "StatusLineModeCommand"},
    StatusLineModeUnknown  = {fg = "Black", bg = "DarkOrange3", bold = true}
}

for group, options in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, options)
end
```
for colours relatively consistent with the default theme.
