local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")

local component_config = {
  hl_groups = {
    fg = "StatusLineFileInfo",
  },
  padding = "  ",
}

return Statusline.Component.new(function(render_mode)
  local filetype = vim.bo.filetype

  if (filetype == "") or not utils.is_normal_buftype() then return "" end

  local encoding = vim.bo.fileencoding or vim.bo.encoding
  local format = vim.bo.fileformat

  return utils.highlight_text(
    table.concat({
      filetype,
      encoding,
      format,
    }, component_config.padding),
    component_config.hl_groups.fg,
    render_mode
  )
end)
