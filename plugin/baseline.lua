if vim.g.loaded_baseline then
    return
end

vim.g.loaded_baseline = true

local baseline = require("baseline")

baseline.setup()

vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("baseline", {clear = true}),
    desc = "Redraw status on mode change",
    callback = function()
        vim.cmd.redrawstatus()
    end
})

local highlights = {
    StatusLine = {fg = "Black", bg = "NvimLightGrey4"},
    StatusLineModeNormal = {fg = "Black", bg = "NvimDarkBlue", bold = true},
    StatusLineModeInsert = {fg = "Black", bg = "Green", bold = true},
    StatusLineModeVisual = {fg = "Black", bg = "NvimDarkGrey4", bold = true},
    StatusLineModeReplace = {fg = "Black", bg = "NvimDarkRed", bold = true},
    StatusLineModeCommand = {fg = "NvimLightGrey4", bg = "Grey8", bold = true},
    StatusLineModeTerminal = {link = "StatusLineModeCommand"},
    StatusLineModeUnknown = {fg = "Black", bg = "DarkOrange3", bold = true},
}

for group, options in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, options)
end
