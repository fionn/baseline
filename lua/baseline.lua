local M = {}

M.mode_highlights = {
    ["n"]   = "%#StatusLineModeNormal#",
    ["i"]   = "%#StatusLineModeInsert#",
    ["v"]   = "%#StatusLineModeVisual#",
    ["V"]   = "%#StatusLineModeVisual#",
    ["\22"] = "%#StatusLineModeVisual#",
    ["s"]   = "%#StatusLineModeVisual#",
    ["S"]   = "%#StatusLineModeVisual#",
    ["\19"] = "%#StatusLineModeVisual#",
    ["R"]   = "%#StatusLineModeReplace#",
    ["r"]   = "%#StatusLineModeCommand#",
    ["c"]   = "%#StatusLineModeCommand#",
    ["t"]   = "%#StatusLineModeTerminal#",
    ["!"]   = "%#StatusLineModeTerminal#",
    unknown = "%#StatusLineModeUnknown#"
}

M.modes = {
    ["n"]     = "NOR",
    ["no"]    = "NOR",
    ["nov"]   = "NOR",
    ["noV"]   = "NOR",
    ["no\22"] = "NOR",
    ["niI"]   = "NOR INS",
    ["niR"]   = "NOR REP",
    ["niV"]   = "NOR VIS",
    ["nt"]    = "NOR T",
    ["ntT"]   = "NOR T",
    ["v"]     = "VIS",
    ["vs"]    = "VIS C",
    ["V"]     = "VIS L",
    ["Vs"]    = "VIS L S",
    ["\22"]   = "VIS B",
    ["\22s"]  = "VIS B S",
    ["s"]     = "SEL",
    ["S"]     = "SEL L",
    ["\19"]   = "SEL B",
    ["i"]     = "INS",
    ["ic"]    = "INS CMP",
    ["ix"]    = "INX",
    ["R"]     = "REP",
    ["Rc"]    = "REP C",
    ["Rx"]    = "REP X",
    ["Rv"]    = "V-REP",
    ["Rvc"]   = "V-REP",
    ["Rvx"]   = "V-REP",
    ["c"]     = "CMD",
    ["cr"]    = "CMD R",
    ["cv"]    = "EX",
    ["cvr"]   = "EX R",
    ["r"]     = "ENTER",
    ["rm"]    = "MORE",
    ["r?"]    = "CONFIRM",
    ["!"]     = "SHELL",
    ["t"]     = "TERM"
}

function M.git_status_string()
    local git = vim.b.gitsigns_status_dict or {head = "", added = 0,
                                               changed = 0, removed = 0}
    if git.head == "" then
        return ""
    end

    local dirty_symbol = ""
    -- We guard here because on startup the dictionary is not populated. We
    -- assume if changed exists, so do the rest.
    if git.changed ~= nil then
        dirty_symbol = (git.changed ~= 0 or git.added ~= 0
                        or git.removed ~= 0) and "*" or ""
    end
    return string.format("(%s%s)", git.head, dirty_symbol)
end

function M.statusline(self)
    local current_mode = vim.api.nvim_get_mode().mode
    -- If we can't identify the mode, send the raw mode string.
    local mode_string = M.modes[current_mode] or current_mode
    local mode_highlight = M.mode_highlights[current_mode:sub(0, 1)]
                           or M.mode_highlights.unknown

    -- See :h 'statusline' for details of this format string.
    return table.concat {
        "%-6(", mode_highlight, " ", mode_string, " %*%)",
        "%< %f %(%m%w%r%q %)%(", self:git_status_string(), " %)%=",
        "%n %y %15(%l:%c%V / %L%) %P"
    }
end

-- This is globally callable because it gets invoked via a v:lua-call outside
-- the module.
Baseline = setmetatable(M, {
    __call = function(statusline)
        return statusline:statusline()
    end
})

---@param parameters? table
function M.setup(parameters)
    parameters = parameters or {}
    if parameters.modes then
        for k, v in pairs(parameters.modes) do
            M.modes[k] = v
        end
    end

    vim.opt.statusline = "%!v:lua.Baseline()"
    vim.opt.showmode = false
end

return M
