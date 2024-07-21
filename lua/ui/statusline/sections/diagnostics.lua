local Statusline = require("ui.statusline.core")
local utils = require("ui.statusline.utils")

local component_config = {
  levels = {
    [vim.diagnostic.severity.ERROR] = {
      sign = "E",
      hl_group = "StatusLineDiagnosticError",
    },
    [vim.diagnostic.severity.WARN] = {
      sign = "W",
      hl_group = "StatusLineDiagnosticWarn",
    },
    [vim.diagnostic.severity.INFO] = {
      sign = "I",
      hl_group = "StatusLineDiagnosticInfo",
    },
    [vim.diagnostic.severity.HINT] = {
      sign = "H",
      hl_group = "StatusLineDiagnosticHint",
    },
  },
  padding = " ",
}

---@type vim.lsp.get_clients.Filter

return Statusline.Component.new(function(render_mode)
  ---@type vim.lsp.get_clients.Filter
  local filter = { bufnr = 0 }
  local has_attached_client = next(vim.lsp.get_clients(filter)) ~= nil
  if not utils.is_normal_buftype() or not has_attached_client then return "" end

  local result = {}

  local levels = {
    vim.diagnostic.severity.HINT,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.ERROR,
  }

  for _, level in ipairs(levels) do
    local level_config = component_config.levels[level]

    local n = #vim.diagnostic.get(0, { severity = level })
    if n > 0 then
      table.insert(
        result,
        utils.highlight_text(
          ("%s%s"):format(level_config.sign, n),
          level_config.hl_group,
          render_mode
        )
      )
    end
  end

  return table.concat(result, component_config.padding)
end)
