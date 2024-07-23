local Statusline = require("ui.statusline.core")
local filename = require("ui.statusline.sections.filename")
local fileinfo = require("ui.statusline.sections.fileinfo")
local gitsigns = require("ui.statusline.sections.gitsigns")
local copilot = require("ui.statusline.sections.copilot")
local diagnostics = require("ui.statusline.sections.diagnostics")
local autocommand_utils = require("utils.autocommand")

local active_statusline = Statusline.new({
  sections = {
    left = {
      filename,
      diagnostics,
    },
    right = {
      copilot,
      gitsigns,
      fileinfo,
    },
  },
})

local inactive_statusline = Statusline.new({
  sections = {
    left = {
      filename,
    },
    right = {
      fileinfo,
    },
  },
})

-- TODO: avoid re-rendering the same statusline

vim.diagnostic.handlers["ui.nvim"] = {
  show = function(namespace, bufnr, diagnostics, opts)
    vim.wo.statusline = active_statusline:render(Statusline.RenderMode.active)
  end,
}

autocommand_utils.create({
  events = { "User" },
  pattern = "GitSignsUpdate",
  lua_callback = function(ctx)
    vim.info(ctx)
    if ctx.buf == vim.api.nvim_get_current_buf() then
      vim.wo.statusline = active_statusline:render(Statusline.RenderMode.active)
    end
  end,
})

return {
  active_statusline = active_statusline,
  inactive_statusline = inactive_statusline,
}
