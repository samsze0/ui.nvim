local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")
local safe_require = require("utils.lang").safe_require

local component_config = {
  hl_groups = {
    icon_inactive = "StatusLineCopilotInactive",
    icon_active = "StatusLineCopilotActive",
  },
}

return Statusline.Component.new(function()
  if (vim.bo.filetype == "") or not utils.is_normal_buftype() then return "" end

  ---@module 'copilot.client'
  local copilot_client = safe_require("copilot.client")
  if not copilot_client then return "" end

  if
    next(copilot_client) == nil
    or copilot_client.is_disabled()
    or not copilot_client.buf_is_attached(0)
  then
    return utils.highlight_text(
      " ",
      component_config.hl_groups.icon_inactive
    )
  else
    return utils.highlight_text(" ", component_config.hl_groups.icon_active)
  end

  -- return utils.highlight_text(" ", component_config.hl_groups.icon_inactive)
end)
