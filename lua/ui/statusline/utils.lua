local config = require("ui.config").value.statusline
---@cast config -nil

local M = {}

-- Highlight text with hl_group
--
---@param text string
---@param hl_group string?
---@param render_mode Statusline.render_mode
function M.highlight_text(text, hl_group, render_mode)
  if not hl_group then return text end

  -- Wrap text inside highlight group
  -- Format: %#<hl-group>#<text>#<normal-hl>#
  return ("%%#%s#%s%%#%s#"):format(
    hl_group,
    text,
    render_mode == "active" and config.highlight_groups.active
      or config.highlight_groups.inactive
  ) -- Escaping % with %
end

-- Check if the current buffer is a normal buffer
--
---@return boolean
function M.is_normal_buftype() return vim.bo.buftype == "" end

return M
