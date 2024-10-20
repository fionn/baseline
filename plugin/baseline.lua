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
