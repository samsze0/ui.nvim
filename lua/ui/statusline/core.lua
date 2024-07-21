local tbl_utils = require("utils.table")
local oop_utils = require("utils.oop")
local notifier = require("ui.config").value.notifier
---@cast notifier -nil
local config = require("ui.config").value.statusline
---@cast config -nil
local uuid_utils = require("utils.uuid")

local _info = notifier.info
---@cast _info -nil
local _warn = notifier.warn
---@cast _warn -nil
local _error = notifier.error
---@cast _error -nil

---@enum Statusline.render_mode
local RenderMode = {
  active = "active",
  inactive = "inactive",
}

---@alias Statusline.component.render_fn fun(): string

---@class Statusline.component
---@field _render_fn Statusline.component.render_fn
---@field _critical_error boolean
local StatuslineComponent = oop_utils.new_class()

---@param render_fn Statusline.component.render_fn
---@param opts? { }
---@return Statusline.component
function StatuslineComponent.new(render_fn, opts)
  local obj = {
    _critical_error = false,
  }
  setmetatable(obj, StatuslineComponent)
  ---@cast obj Statusline.component
  obj._render_fn = function()
    if obj._critical_error then
      return config.component_fail_to_render_symbol
    end

    local ok, output = xpcall(function() return render_fn() end, function(err)
      _error("An error occurred while rendering statusline component: " .. err)
      obj._critical_error = true
    end)
    if not ok then output = config.component_fail_to_render_symbol end
    ---@cast output -nil

    return output
  end

  return obj
end

---@return string
function StatuslineComponent:render() return self._render_fn() end

---@enum Statusline.section
local Section = {
  left = "left",
  right = "right",
}

---@class Statusline.subscriber_id string

---@class Statusline.sections
---@field left Statusline.component[]
---@field right Statusline.component[]

---@class Statusline
---@field _sections Statusline.sections
---@field _subscribers table<Statusline.subscriber_id, fun()>
---@field _critical_error boolean Whether there was a critical error rendering the statusline
local Statusline = oop_utils.new_class()

---@class CreateStatuslineOptions
---@field sections? Statusline.sections

---@param opts? CreateStatuslineOptions
---@return Statusline
function Statusline.new(opts)
  opts = opts or {}

  local obj = {
    _sections = {
      left = {},
      right = {},
    },
    _subscribers = {},
    _critical_error = false,
  }
  setmetatable(obj, Statusline)
  ---@cast obj Statusline

  if opts.sections then obj._sections = opts.sections end

  return obj
end

---@param section Statusline.section
---@param component Statusline.component
function Statusline:prepend(section, component)
  table.insert(self._sections[section], 1, component)
end

---@param section Statusline.section
---@param component Statusline.component
function Statusline:append(section, component)
  table.insert(self._sections[section], component)
end

---@param section Statusline.section
---@param component Statusline.component
---@param order number?
function Statusline:add(section, component, order) error("Not implemented") end

function Statusline:render()
  if self._critical_error then return end

  local ok, output = xpcall(function()
    local left = config.margin
      .. table.concat(
        tbl_utils.filter(
          tbl_utils.map(
            self._sections.left,
            function(_, component) return component:render() end
          ),
          function(_, output) return output ~= nil and #output > 0 end
        ),
        config.padding
      )
      .. config.margin
    local right = config.margin
      .. table.concat(
        tbl_utils.filter(
          tbl_utils.map(
            self._sections.right,
            function(_, component) return component:render() end
          ),
          function(_, output) return output ~= nil and #output > 0 end
        ),
        config.padding
      )
      .. config.margin

    local output = left .. "%=" .. right

    ---@type Statusline.subscriber_id[]
    local faulty_subscribers = {}
    for id, subscriber in pairs(self._subscribers) do
      xpcall(subscriber, function(err)
        _error(
          "An error occurred while rendering statusline subscriber: " .. err
        )
        table.insert(faulty_subscribers, id)
      end)
    end

    -- Removing faulty subscribers
    for _, id in ipairs(faulty_subscribers) do
      self._subscribers[id] = nil
    end

    return output
  end, function(err)
    print("An critical error occurred while rendering statusline: ", err)
    self._critical_error = true
  end)

  if not ok then return end
  return output
end

function Statusline:clear()
  self._sections = {
    left = {},
    right = {},
  }
end

---@param callback fun()
function Statusline:on_render(callback)
  local id = uuid_utils.v4()
  self._subscribers[id] = callback
end

Statusline.Component = StatuslineComponent

return Statusline
