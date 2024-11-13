local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")

local component_config = {
  hl_groups = {
    fg = "StatusLineFileProgress",
  },
}

local comp = Statusline.Component.new(function(render_mode)
  if not utils.is_normal_buftype() then
    return ""
  else
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.api.nvim_buf_line_count(0)
    return utils.highlight_text(
      ("%s/%s").format(current_line, total_lines),
      component_config.hl_groups.fg,
      render_mode
    )
  end
end)
