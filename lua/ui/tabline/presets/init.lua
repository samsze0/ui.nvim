local Tabline = require("ui.tabline.core")
local tabs = require("ui.tabline.sections.tabs")
local autocommand_utils = require("utils.autocommand")

local tabline = Tabline.new({
  components = {
    tabs,
  },
})

-- TODO: subscriptions logic should be moved to the Tabline module

autocommand_utils.create({
  events = {
    "TabNew",
    "TabClosed",
    "TabLeave",
    "TabEnter",
    "BufLeave",
    "BufEnter",
    "BufModifiedSet",
    "FileType",
    "WinClosed",
    "WinNew",
    "BufUnload",
    "BufDelete",
    "BufHidden",
  },
  lua_callback = function() vim.o.tabline = tabline:render() end,
})

return tabline
