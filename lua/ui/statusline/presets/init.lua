local Statusline = require("ui.statusline.core")
local filename = require("ui.statusline.sections.filename")
local fileinfo = require("ui.statusline.sections.fileinfo")
local gitsigns = require("ui.statusline.sections.gitsigns")
local copilot = require("ui.statusline.sections.copilot")
local diagnostics = require("ui.statusline.sections.diagnostics")

return {
  active_statusline = Statusline.new({
    sections = {
      left = {
        filename,
        diagnostics,
      },
      right = {
        copilot,
        gitsigns,
        fileinfo,
      },
    },
  }),
  inactive_statusline = Statusline.new({
    sections = {
      left = {
        filename,
      },
      right = {
        fileinfo,
      },
    },
  }),
}
