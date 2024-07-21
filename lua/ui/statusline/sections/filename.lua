local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")

local component_config = {
  hl_groups = {},
}

return Statusline.Component.new(function(render_mode)
  if vim.bo.buftype == "terminal" then
    return " %t"
  else
    local modified = vim.bo.modified
    local readonly = vim.bo.readonly

    -- :h statusline
    return "%f" .. (modified and "  " or "") .. (readonly and "  " or "")
  end
end)
