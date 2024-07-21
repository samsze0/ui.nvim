local Tabline = require("ui.tabline.core")

local M = {}

---@param tabline Tabline
M.register = function(tabline) vim.o.tabline = tabline:render() end

return M
