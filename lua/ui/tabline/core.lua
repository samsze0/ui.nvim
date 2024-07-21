local tbl_utils = require("utils.table")
local oop_utils = require("utils.oop")
local notifier = require("ui.config").value.notifier
---@cast notifier -nil
local config = require("ui.config").value.tabline
---@cast config -nil
local uuid_utils = require("utils.uuid")

local _info = notifier.info
---@cast _info -nil
local _warn = notifier.warn
---@cast _warn -nil
local _error = notifier.error
---@cast _error -nil

-- TODO: extract common logic to a shared module

---@alias Tabline.component.render_fn fun(): string

---@class Tabline.component
---@field _render_fn Tabline.component.render_fn
---@field _critical_error boolean
local TablineComponent = oop_utils.new_class()

---@param render_fn Tabline.component.render_fn
---@param opts? { }
---@return Tabline.component
function TablineComponent.new(render_fn, opts)
  local obj = {
    _critical_error = false,
  }
  setmetatable(obj, TablineComponent)
  ---@cast obj Tabline.component
  obj._render_fn = function()
    if obj._critical_error then
      return config.component_fail_to_render_symbol
    end

    local ok, output = xpcall(function() return render_fn() end, function(err)
      _error("An error occurred while rendering tabline component: " .. err)
      obj._critical_error = true
    end)
    if not ok then output = config.component_fail_to_render_symbol end
    ---@cast output -nil

    return output
  end

  return obj
end

---@return string
function TablineComponent:render() return self._render_fn() end

---@class Tabline.subscriber_id string

---@class Tabline
---@field _components Tabline.component[]
---@field _subscribers table<Tabline.subscriber_id, fun()>
---@field _critical_error boolean Whether there was a critical error rendering the tabline
local Tabline = oop_utils.new_class()

---@class CreateTablineOptions
---@field components Tabline.component[]?

---@param opts? CreateTablineOptions
---@return Tabline
function Tabline.new(opts)
  opts = opts or {}

  local obj = {
    _components = opts.components or {},
    _subscribers = {},
    _critical_error = false,
  }
  setmetatable(obj, Tabline)
  ---@cast obj Tabline

  return obj
end

---@param component Tabline.component
function Tabline:prepend(component) table.insert(self._components, 1, component) end

---@param component Tabline.component
function Tabline:append(component) table.insert(self._components, component) end

---@param component Tabline.component
---@param order number?
function Tabline:add(component, order) error("Not implemented") end

function Tabline:render()
  if self._critical_error then return end

  local ok, output = xpcall(function()
    local output = config.margin
      .. table.concat(
        tbl_utils.filter(
          tbl_utils.map(
            self._components,
            function(_, component) return component:render() end
          ),
          function(_, output) return output ~= nil and #output > 0 end
        ),
        config.padding
      )
      .. config.margin

    ---@type Tabline.subscriber_id[]
    local faulty_subscribers = {}
    for id, subscriber in pairs(self._subscribers) do
      xpcall(subscriber, function(err)
        _error("An error occurred while rendering tabline subscriber: " .. err)
        table.insert(faulty_subscribers, id)
      end)
    end

    -- Removing faulty subscribers
    for _, id in ipairs(faulty_subscribers) do
      self._subscribers[id] = nil
    end

    return output
  end, function(err)
    print("An critical error occurred while rendering tabline: ", err)
    self._critical_error = true
  end)

  if not ok then return end
  return output
end

function Tabline:clear() self._components = {} end

---@param callback fun()
function Tabline:on_render(callback)
  local id = uuid_utils.v4()
  self._subscribers[id] = callback
end

Tabline.Component = TablineComponent

return Tabline
