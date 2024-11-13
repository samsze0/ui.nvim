local Statusline = require("ui.statusline.core")
local filename = require("ui.statusline.sections.filename")
local fileinfo = require("ui.statusline.sections.fileinfo")
local gitsigns = require("ui.statusline.sections.gitsigns")
local copilot = require("ui.statusline.sections.copilot")
local diagnostics = require("ui.statusline.sections.diagnostics")
local file_progress = require("ui.statusline.sections.file-progress")

local active_statusline = Statusline.new({
  sections = {
    left = {
      filename,
      diagnostics,
      file_progress
    },
    right = {
      copilot,
      gitsigns,
      fileinfo,
    },
  },
})

local inactive_statusline = Statusline.new({
  sections = {
    left = {
      filename,
    },
    right = {
      fileinfo,
    },
  },
})

return {
  active_statusline = active_statusline,
  inactive_statusline = inactive_statusline,
}
