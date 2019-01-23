local Name, Addon = ...
local Data, Models, Store, Util = Addon:Import("Data", "Models", "Store", "Util")
local Self, Super = Util.TblClass(Models.Model, Models.Recipe)

Self.STORE = "RECIPE"
Self.REF = "rcp"

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-- fetch a model from the store
function Self.Fetch(Static, id)
    id = tonumber(id)

    local itemLink = C_TradeSkillUI.GetRecipeItemLink(id)
    if itemLink then
        local itemId = Data.Crafts.ENCHANT_SCROLLS[id] or Models.Item:GetInfo(itemLink, "id")
        local itemNum = C_TradeSkillUI.GetRecipeNumItemsProduced(id) or 1
    
        local mats = Util.Tbl()
        for i=1,C_TradeSkillUI.GetRecipeNumReagents(id) do
            local matId = tonumber(Models.Item:GetInfo(C_TradeSkillUI.GetRecipeReagentItemLink(id, i), "id"))
            local matNum = tonumber((select(3, C_TradeSkillUI.GetRecipeReagentInfo(id, i))))
            mats[matId] = matNum
        end

        return Static(id, itemId, itemNum, mats)
    else
        return Super.Fetch(Static, id)
    end
end

-- Create a new instance from table, int or string representation
function Self.Decode(Static, data)
    if type(data) == "string" and not (tonumber(data) or Static:IsReference(data)) then
        local recipeId, item, mats = strsplit(":", data)
        local itemNum, itemId = strsplit("x", item)
    
        local t = Util.Tbl()
        for j,mat in Util.Each(strsplit(",", mats)) do
            local matNum, matId = strsplit("x", mat)
            t[tonumber(matId)] = tonumber(matNum)
        end
    
        return Static(recipeId, itemId, itemNum, t)
    else
        return Super.Decode(Static, data)
    end
end

-- Get store path for a model
function Self.GetStoreRoot(Static, ...)
    return Static.STORE, ...
end

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

function Self:Create(id, itemId, itemNum, mats)
    self.id = tonumber(id)
    self.itemId = tonumber(itemId)
    self.itemNum = tonumber(itemNum)
    self.mats = mats
end

-- Encode the instance for storage
function Self:Encode()
    local mats = ""
    for matId,matNum in pairs(self.mats) do
        mats = mats .. (mats == "" and "" or ",") .. matNum .. "x" .. matId
    end
    return self.id .. ":" .. self.itemNum .. "x" .. self.itemId .. ":" .. mats
end
Self.__tostring = Self.Encode

-- Store the instance, as well as a reference from the crafted item in the char's crafting line
function Self:Store(line)
    Super.Store(self)

    if line then
        local cache = Store.GetUnit(Store.CAT_CRAFT, line) or Util.Tbl()
        cache[self.itemId] = (cache[self.itemId] and cache[self.itemId] .. "," or "") .. self.id
        Store.SetUnit(Store.CAT_CRAFT, line, cache)
    end

    return self
end
