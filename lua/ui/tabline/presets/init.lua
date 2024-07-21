local Tabline = require("ui.tabline.core")
local tabs = require("ui.tabline.sections.tabs")

return Tabline.new({
  components = {
    tabs,
  },
})
