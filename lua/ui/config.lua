local opts_utils = require("utils.opts")
local oop_utils = require("utils.oop")

---@class UINotifierConfig
---@field info fun(message: string)?
---@field warn fun(message: string)?
---@field error fun(message: string)?

---@class StatuslineHighlightGroupsConfig
---@field active string?
---@field inactive string?

---@class StatuslineConfig
---@field highlight_groups StatuslineHighlightGroupsConfig?
---@field padding string?
---@field margin string?
---@field component_fail_to_render_symbol string?

---@class TablineHighlightGroupsConfig

---@class TablineConfig
---@field highlight_groups TablineHighlightGroupsConfig?
---@field padding string?
---@field margin string?
---@field component_fail_to_render_symbol string?

---@class UIConfig.config
---@field statusline StatuslineConfig?
---@field tabline TablineConfig?
---@field notifier UINotifierConfig?

-- A singleton class to store the configuration
--
---@class UIConfig
---@field value UIConfig.config
local UIConfig = oop_utils.new_class()

---@param config? UIConfig.config
function UIConfig:setup(config)
  self.value = opts_utils.deep_extend(self.value, config)
end

---@type UIConfig.config
local default_config = {
  notifier = {
    info = function(message) vim.notify(message, vim.log.levels.INFO) end,
    warn = function(message) vim.notify(message, vim.log.levels.WARN) end,
    error = function(message) vim.notify(message, vim.log.levels.ERROR) end,
  },
  statusline = {
    margin = " ",
    padding = "  ",
    highlight_groups = {
      active = "StatusLine",
      inactive = "StatusLineNC",
    },
    component_fail_to_render_symbol = "X",
  },
}

---@return UIConfig
function UIConfig.new()
  return setmetatable({
    value = opts_utils.deep_extend({}, default_config),
  }, UIConfig)
end

return UIConfig.new()
