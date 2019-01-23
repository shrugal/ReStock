local Name, Addon = ...
local Data, Models, Store, Util = Addon:Import("Data", "Models", "Store", "Util")
local Self, Super = Util.TblClass(Models.Model, Models.Task)

Self.STORE = "TASK"
Self.REF = "task"

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

-- Create a new instance
function Self:Create(item, char, loc, amount, options)
    self.item = item
    self.char = char
    self.loc = loc
    self.amount = tonumber(amount) or 0
    self.options = options
end
