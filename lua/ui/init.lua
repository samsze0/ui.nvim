local UIConfig = require("ui.config")

local M = {}

---@param config? UIConfig.config
M.setup = function(config) UIConfig:setup(config) end

return M
