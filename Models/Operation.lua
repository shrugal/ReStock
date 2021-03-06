local Name, Addon = ...
local Data, Models, Store, Util = Addon:Import("Data", "Models", "Store", "Util")
local Self, Super = Util.TblClass(Models.Model, Models.Task)

Self.STORE = "OPERATION"
Self.REF = "op"

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

-- Create a new instance
function Self:Create(item, char, loc, amount)
    self.item = item
    self.char = char
    self.loc = loc
    self.amount = tonumber(amount) or 0
end

