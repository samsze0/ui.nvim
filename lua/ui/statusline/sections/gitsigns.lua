local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")

local component_config = {
  hl_groups = {
    added = "StatusLineGitSignsAdded",
    changed = "StatusLineGitSignsChanged",
    removed = "StatusLineGitSignsRemoved",
    head = "StatusLineGitSignsHead",
  },
  icons = {
    added = "+",
    changed = "~",
    removed = "-",
    head = " ",
  },
  padding = " ",
}

return Statusline.Component.new(function(render_mode)
  if not vim.b.gitsigns_status_dict then return "" end
  local status = vim.b.gitsigns_status_dict

  if not utils.is_normal_buftype() then return "" end

  local result = ""

  local head_ref = component_config.icons.head
    .. utils.highlight_text(
      vim.b.gitsigns_head or "-",
      component_config.hl_groups.head,
      render_mode
    )
  result = result .. head_ref

  if (status.added or 0) > 0 then
    result = result
      .. utils.highlight_text(
        ("%s%s%s"):format(
          component_config.padding,
          component_config.icons.added,
          status.added
        ),
        component_config.hl_groups.added,
        render_mode
      )
  end
  if (status.changed or 0) > 0 then
    result = result
      .. utils.highlight_text(
        ("%s%s%s"):format(
          component_config.padding,
          component_config.icons.changed,
          status.changed
        ),
        component_config.hl_groups.changed,
        render_mode
      )
  end
  if (status.removed or 0) > 0 then
    result = result
      .. utils.highlight_text(
        ("%s%s%s"):format(
          component_config.padding,
          component_config.icons.removed,
          status.removed
        ),
        component_config.hl_groups.removed,
        render_mode
      )
  end

  return result
end)
