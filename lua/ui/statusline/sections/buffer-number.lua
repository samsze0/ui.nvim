local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")

local component_config = {
  hl_groups = {},
}

return Statusline.Component.new(
  function(render_mode)
    return "Buffer: " .. tostring(vim.api.nvim_get_current_buf())
  end
)
