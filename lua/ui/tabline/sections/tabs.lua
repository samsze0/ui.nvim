local Statusline = require("ui.statusline.core")
local Tabline = require("ui.tabline.core")
local safe_require = require("utils.lang").safe_require
local tbl_utils = require("utils.table")
local tab_utils = require("utils.tab")
local dbg = require("utils").debug
local git_utils = require("utils.git")

local component_config = {
  hl_groups = {
    fill = "TabLineFill",
    selected = "TabLineSel",
    not_selected = "TabLine",
  },
  padding = {
    inter_tab = " ",
    within_tab = " ",
  },
  indicators = {
    modified = "",
    readonly = "",
    terminal = "",
    unknown = "",
  },
  margin = {
    tab = " ",
  },
  show_tab_index = false,
  show_window_count = true,
  show_fileicon = true,
}

local devicons = safe_require("nvim-web-devicons")

-- FIX: intertab padding issues

return Tabline.Component.new(function()
  local tabs = tab_utils.get_tabs_info()
  local current_tab = vim.fn.tabpagenr()

  local tabs_titles = tbl_utils.map(tabs, function(i, tab)
    local is_current_tab = i == current_tab
    local current_window_in_tab = vim.fn.tabpagewinnr(tab.tabnr)
    -- win_nr is scoped to the current tab and starts from 1
    -- win_id is scoped to the whole vim instance and starts from 1000
    local current_window = vim.fn.win_getid(current_window_in_tab, tab.tabnr)
    local win_info = vim.fn.getwininfo(current_window)[1]
    local current_buffer_in_tab = win_info.bufnr

    local filepath = vim.fn.bufname(current_buffer_in_tab)
    if vim.fn.filereadable(filepath) == 0 then
      return component_config.indicators.unknown
    end

    local relative_filepath = vim.fn.fnamemodify(filepath, ":~:.")

    local modified = vim.bo[current_buffer_in_tab].modified
    local filetype = vim.bo[current_buffer_in_tab].filetype
    local buftype = vim.bo[current_buffer_in_tab].buftype
    local buflisted = vim.bo[current_buffer_in_tab].buflisted
    local readonly = vim.bo[current_buffer_in_tab].readonly
    local file_extension = vim.fn.fnamemodify(filepath, ":e")

    if buftype == "terminal" then
      return component_config.indicators.terminal
    end

    if buftype ~= "" then return component_config.indicators.unknown end

    local result = {}

    if component_config.show_tab_index then
      table.insert(result, tostring(i))
    end

    local fileicon = (component_config.show_fileicon and devicons ~= nil)
        and devicons.get_icon(filepath, file_extension, { default = true })
      or nil
    if fileicon then table.insert(result, fileicon) end

    table.insert(result, relative_filepath)

    if modified then
      table.insert(result, component_config.indicators.modified)
    end
    if readonly then
      table.insert(result, component_config.indicators.readonly)
    end

    if component_config.show_window_count then
      local wins = tbl_utils.filter(tab.windows, function(_, win)
        local buf = vim.api.nvim_win_get_buf(win)
        return vim.bo[buf].buflisted and vim.bo[buf].buftype == ""
      end)
      table.insert(result, ("/%d"):format(#wins))
    end

    return table.concat(
      tbl_utils.non_empty(result),
      component_config.padding.within_tab
    )
  end)

  tabs_titles = tbl_utils.map(
    tabs_titles,
    function(i, tab_title)
      return component_config.margin.tab
        .. tab_title
        .. component_config.margin.tab
    end
  )

  local apply_hl = function(i, tab_text)
    local is_current_tab = i == current_tab
    return ("%%#%s#"):format(
      is_current_tab and component_config.hl_groups.selected
        or component_config.hl_groups.not_selected
    ) .. tab_text
  end

  local max_width = vim.o.columns

  local required_width = tbl_utils.sum(
    tabs_titles,
    function(_, o) return #o end
  ) + (#tabs_titles - 1) * #component_config.padding.inter_tab

  if required_width <= max_width then
  end

  return table.concat(
    tbl_utils.map(tabs_titles, apply_hl),
    component_config.padding.inter_tab
  ) .. ("%%#%s#"):format(component_config.hl_groups.fill)
end)
