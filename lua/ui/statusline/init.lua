local Statusline = require("ui.statusline.core")
local autocmd_utils = require("utils.autocommand")

local M = {}

---@param opts { active_statusline: Statusline, inactive_statusline: Statusline }
M.register = function(opts)
  local augroup = vim.api.nvim_create_augroup("Statusline", {})

  autocmd_utils.create({
    events = { autocmd_utils.Event.WinEnter, autocmd_utils.Event.BufEnter },
    group = augroup,
    pattern = "*",
    desc = "Set active statusline",
    lua_callback = function(ctx)
      vim.wo.statusline =
        opts.active_statusline:render(Statusline.RenderMode.active)
    end,
  })

  autocmd_utils.create({
    events = { autocmd_utils.Event.WinLeave, autocmd_utils.Event.BufLeave },
    group = augroup,
    pattern = "*",
    desc = "Set inactive statusline",
    lua_callback = function(ctx)
      vim.wo.statusline =
        opts.inactive_statusline:render(Statusline.RenderMode.inactive)
    end,
  })
end

return M
