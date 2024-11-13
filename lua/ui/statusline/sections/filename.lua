local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")
local autocommand_utils = require("utils.autocommand")

local component_config = {
  hl_groups = {},
}

local comp = Statusline.Component.new(function(render_mode)
  if vim.bo.buftype == "terminal" then
    return " %t"
  else
    local modified = vim.bo.modified
    local readonly = vim.bo.readonly

    -- :h statusline
    return "%f" .. (modified and "  " or "") .. (readonly and "  " or "")
  end
end)

comp:on_init(function()
  local id = autocommand_utils.create({
    events = { "BufModifiedSet" },
    lua_callback = function(ctx)
      comp:invalidate(Statusline.RenderMode.active)
      comp:invalidate(Statusline.RenderMode.inactive)
    end,
  })
  comp:on_destroy(function()
    autocommand_utils.delete(id)
  end)
end)

return comp