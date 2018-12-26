local Name, Addon = ...
local Data, Models, Store, Util = Addon.Data, Addon.Models, Addon.Store, Addon.Util
local Self = Models.Recipe

Self.MT = {__index = Self}

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-- Create a new recipe instance
function Self.Create(id, itemId, itemNum, mats)
    return setmetatable(Util.TblHash(
        "id", tonumber(id),
        "itemId", Data.Crafts.ENCHANT_SCROLLS[tonumber(itemId)] or tonumber(itemId),
        "itemNum", tonumber(itemNum),
        "mats", mats
    ), Self.MT)
end

-- Create a new recipe instance from a recipe ID
function Self.FromId(recipeId)
    recipeid = tonumber(recipeId)

    local itemLink = C_TradeSkillUI.GetRecipeItemLink(recipeId)
    if itemLink then
        local itemId = Models.Item.GetInfo(C_TradeSkillUI.GetRecipeItemLink(recipeId), "id")
        local itemNum = C_TradeSkillUI.GetRecipeNumItemsProduced(recipeId) or 1
    
        local mats = Util.Tbl()
        for i=1,C_TradeSkillUI.GetRecipeNumReagents(recipeId) do
            local matId = tonumber(Models.Item.GetInfo(C_TradeSkillUI.GetRecipeReagentItemLink(recipeId, i), "id"))
            local matNum = tonumber((select(3, C_TradeSkillUI.GetRecipeReagentInfo(recipeId, i))))
            mats[matId] = matNum
        end

        return Self.Create(recipeId, itemId, itemNum, mats)
    else
        return Self.Decode(Store.GetCache(Store.CAT_RECIPE, recipeId))
    end
end

-- Create a new recipe instance from table, int or string representation
function Self.Decode(recipe)
    if type(recipe) == "table" and getmetatable(recipe) == Self.MT then
        return recipe
    elseif tonumber(recipe) then
        return Self.FromId(recipe)
    elseif type(recipe) == "string" then
        local recipeId, item, mats = strsplit(":", recipe)
        local itemNum, itemId = strsplit("x", item)
    
        local t = Util.Tbl()
        for j,mat in Util.Each(strsplit(",", mats)) do
            local matNum, matId = strsplit("x", mat)
            t[tonumber(matId)] = tonumber(matNum)
        end
    
        return Self.Create(recipeId, itemId, itemNum, t)
    end
end

-------------------------------------------------------
--                       Methods                     --
-------------------------------------------------------

function Self:Encode()
    local mats = ""
    for matId,matNum in pairs(self.mats) do
        mats = mats .. (mats == "" and "" or ",") .. matNum .. "x" .. matId
    end
    return self.id .. ":" .. self.itemNum .. "x" .. self.itemId .. ":" .. mats
end

function Self:Store()
    Store.SetCache(Store.CAT_RECIPE, self.id, self:Encode())
    return self
end

-- Release the recipe
function Self:Release(fn, ...)
    local val
    if fn then val = Self[fn](self, ...) end
    Util.TblRelease(true, self)
    return val
end