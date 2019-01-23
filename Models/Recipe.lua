local Name, Addon = ...
local Data, Models, Store, Util = Addon.Data, Addon.Models, Addon.Store, Addon.Util
local Super = Models.Model
local Self = Models.Recipe

Self.__index = Self
setmetatable(Self, Super)

Self.STORE = Store.CAT_RECIPE
Self.REF = "rcp"

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

function Self:Create(id, itemId, itemNum, mats)
    return Super.Create(Self,
        "id", tonumber(id),
        "itemId", tonumber(itemId),
        "itemNum", tonumber(itemNum),
        "mats", mats
    )
end

-- fetch a model from the store
function Self:Fetch(id)
    id = tonumber(id)

    local itemLink = C_TradeSkillUI.GetRecipeItemLink(id)
    if itemLink then
        local itemId = Data.Crafts.ENCHANT_SCROLLS[id] or Models.Item.GetInfo(itemLink, "id")
        local itemNum = C_TradeSkillUI.GetRecipeNumItemsProduced(id) or 1
    
        local mats = Util.Tbl()
        for i=1,C_TradeSkillUI.GetRecipeNumReagents(id) do
            local matId = tonumber(Models.Item.GetInfo(C_TradeSkillUI.GetRecipeReagentItemLink(id, i), "id"))
            local matNum = tonumber((select(3, C_TradeSkillUI.GetRecipeReagentInfo(id, i))))
            mats[matId] = matNum
        end

        return Self:Create(id, itemId, itemNum, mats)
    else
        return Super.Fetch(Self, id)
    end
end

-- Create a new instance from table, int or string representation
function Self:Decode(data)
    if type(data) == "string" and not tonumber(data) then
        local recipeId, item, mats = strsplit(":", data)
        local itemNum, itemId = strsplit("x", item)
    
        local t = Util.Tbl()
        for j,mat in Util.Each(strsplit(",", mats)) do
            local matNum, matId = strsplit("x", mat)
            t[tonumber(matId)] = tonumber(matNum)
        end
    
        return Self:Create(recipeId, itemId, itemNum, t)
    else
        return Super.Decode(Self, data)
    end
end

-------------------------------------------------------
--                       Members                     --
-------------------------------------------------------

-- Encode the instance for storage
function Self:Encode()
    local mats = ""
    for matId,matNum in pairs(self.mats) do
        mats = mats .. (mats == "" and "" or ",") .. matNum .. "x" .. matId
    end
    return self.id .. ":" .. self.itemNum .. "x" .. self.itemId .. ":" .. mats
end
Self.__tostring = Self.Encode
