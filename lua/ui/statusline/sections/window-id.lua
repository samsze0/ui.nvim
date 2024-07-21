local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")

local component_config = {
  hl_groups = {},
}

return Statusline.Component.new(
  function() return "Window: " .. tostring(vim.api.nvim_get_current_win()) end
)
