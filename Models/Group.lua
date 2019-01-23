local Name, Addon = ...
local Models, Store, Util = Addon.Models, Addon.Store, Addon.Util
local Super = Models.Model
local Self = Models.Group

Self.__index = Self
setmetatable(Self, Super)

Self.STORE = Store.CAT_GROUP
Self.REF = "grp"

-- Group child types
Self.TYPE_ITEMS = "ITEMS"
Self.TYPE_CHARS = "CHARS"

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-- Create a new instance
function Self:Create(name, childType, children, subgroups)
    return Super.Create(Self, 
        "name", name,
        "childType", childType or Self.TYPE_ITEMS,
        "children", children or Util.Tbl(),
        "subgroups", subgroups or Util.Tbl()
    )
end

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

-- Get the instance path under the store root
function Self:GetStorePath(id)
    return self.childType, id and self.id or nil
end
