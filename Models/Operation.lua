local Name, Addon = ...
local Data, Models, Store, Util = Addon.Data, Addon.Models, Addon.Store, Addon.Util
local Super = Models.Model
local Self = Models.Operation

Self.__index = Self
setmetatable(Self, Super)

Self.STORE = Store.CAT_OPERATION
Self.REF = "op"

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-- Create a new instance
function Self:Create(item, char, loc, amount, options)
    return Super.Create(Self, 
        "item", item,
        "char", char,
        "loc", loc,
        "amount", tonumber(amount) or 0,
        "options", options or Util.Tbl()
    )
end

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

