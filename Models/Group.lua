local Name, Addon = ...
local Models, Store, Util = Addon:Import("Models", "Store", "Util")
local Self, Super = Util.TblClass(Models.Model, Models.Group)

Self.STORE = "GROUP"
Self.REF = "grp"

-- Group child types
Self.TYPE_ITEMS = "ITEMS"
Self.TYPE_CHARS = "CHARS"

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

-- Create a new instance
function Self:Create(name, childType, children, subgroups)
    self.name = name
    self.childType = childType or Self.TYPE_ITEMS
    self.children = children or Util.Tbl()
    self.subgroups = subgroups or Util.Tbl()
end

-- Get the instance path under the store root
function Self:GetStorePath(id)
    return self.childType, id and self.id or nil
end
