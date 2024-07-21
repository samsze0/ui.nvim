local config = require("ui.config").value.statusline
---@cast config -nil

local M = {}

-- Highlight text with hl_group
--
---@param text string
---@param hl_group string?
function M.highlight_text(text, hl_group)
  if not hl_group then return text end

  -- Wrap text inside highlight group
  -- Format: %#<hl-group>#<text>#<normal-hl>#
  return ("%%#%s#%s%%#%s#"):format(hl_group, text, config.highlight_groups.fg) -- Escaping % with %
end

-- Check if the current buffer is a normal buffer
--
---@return boolean
function M.is_normal_buftype() return vim.bo.buftype == "" end

return M
