local Name, Addon = ...
local Models, Store, Util = Addon.Models, Addon.Store, Addon.Util
local Self = Models.Model

Self.__index = Self

Self.STORE = nil
Self.REF = nil

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-- Create a new instance
function Self.Create(Static, ...)
    return setmetatable(Util.TblHash(...), Static)
end

-- Get a list of models form the store
function Self.Find(Static, ...)
    return Store.Get(Static:GetStoreRoot(...))
end

-- Start querying the list of models
function Self.Query(Static, ...)
    return Util(Static:Find(...)).Copy()
end

-- Fetch a model from the store
function Self.Fetch(Static, ...)
    return Model:Decode(Static:Find(...))
end

-- Create a new instance from table, int or string representation
function Self.Decode(Static, ...)
    local Model = Static:IsReference(...)
    if Model then
        return Model:Fetch(select(2, strsplit(":", (...))))
    elseif type(...) == "table" then
        return getmetatable(...) == Static and ... or setmetatable(..., Static)
    elseif ... ~= nil then
        return Static:Fetch(...)
    end
end

-- Get store path for a model
function Self.GetStoreRoot(Static, ...)
    return Static.STORE, Addon.REALM, Addon.FACTION, ...
end

-- Check if the given data is a reference string
function Self.IsReference(Static, ref)
    if type(ref) == "string" then
        if Static == Self then
            if ref:find(":") then
                for _,Model in pairs(Models) do
                    if Model.REF and (...):find(Model.REF .. ":") == 1 then
                        return Model
                    end
                end
            end
        elseif ref:find(Static.REF .. ":") == 1 then
            return Static
        end
    end
end

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

-- Encode the instance for storage
function Self:Encode()
    return self
end

-- Get the instance path under the store root
function Self:GetStorePath(id)
    return id and self.id or nil
end

-- Get the full instance path in the store
function Self:GetFullStorePath(id)
    return strjoin(".", self:GetStoreRoot(self:GetStorePath(id)))
end

-- Get a reference string for this instance
function Self:GetReference()
    return strjoin(":", self.REF, self:GetStorePath(true))
end

-- Store the instance
function Self:Store()
    local path = self:GetFullStorePath()
    local cache = Store.Get(path) or Util.Tbl()

    self.id = self.id or #cache + 1
    cache[self.id] = self:Encode()
    Store.Set(path, cache)

    return self
end

-- Remove the instance from the store
function Self:Remove()
    if self.id then
        Store.Set(self:GetFullStorePath(true), nil)
    end
    return self
end

-- Release the instance
function Self:Release()
    Util.TblRelease(true, self)
end
