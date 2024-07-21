local Statusline = require("ui.statusline.core")
local buffer_number = require("ui.statusline.sections.buffer-number")
local window_id = require("ui.statusline.sections.window-id")

return {
  active_statusline = Statusline.new({
    sections = {
      left = {
        buffer_number,
        window_id,
      },
      right = {},
    },
  }),
  inactive_statusline = Statusline.new({
    sections = {
      left = {
        buffer_number,
        window_id,
      },
      right = {},
    },
  }),
}
