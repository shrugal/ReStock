local Name, Addon = ...
local Convert, Models, Store, Unit, Util = Addon.Convert, Addon.Models, Addon.Store, Addon.Unit, Addon.Util
local Self = Addon.Price

Self.METHOD_MARKET = "MARKET"
Self.METHOD_CRAFT = "CRAFT"
Self.METHOD_CONVERT = "CONVERT"
Self.METHODS = {Self.METHOD_MARKET, Self.METHOD_CRAFT, Self.METHOD_CONVERT}

-------------------------------------------------------
--                       Item                        --
-------------------------------------------------------

-- Lookup the cheapest price to get the item (market, craft, convert)
-- @param int|string item Item id, string or link
-- @param bool owned Use ACB price of owned items and mats where possible
-- @param table stack Item ids being looked up recursively to prevent loops
-- @return float Current min. price
-- @return string Method used
function Self.GetItemPrice(item, owned, stack)
    local itemId, price, method, clear = tonumber(item) or tonumber(Models.Item.GetInfo(item, "id"))

    if not stack then
        stack, clear = Util.Tbl(), true
    elseif Util.TblFind(stack, itemId) then
        return
    end

    tinsert(stack, itemId)

    for i,m in pairs(Self.METHODS) do
        local price2 = Self["GetItem" .. Util.StrUcFirst(m:lower()) .. "Price"](item, owned, stack)
        if price2 and (not price or price2 < price) then
            price, method = price2, m
        end
    end

    if clear then
        Util.TblRelease(stack)
    else
        tremove(stack)
    end

    return price, method
end

-- Lookup the price of the item on the AH
-- @param int|string item Item id, string or link
-- @param bool owned Use ACB price of owned items and mats where possible
-- @param table stack Item ids being looked up recursively to prevent loops
-- @return float Current realm minimum buyout (TODO: TUJ doesn't support this, so it's currently the same as the 2nd return value)
-- @return float Recent average realm market price (e.g. last 3 days)
-- @return float Historical average realm market price (e.g. last 14 days)
-- @return float Average region market price
function Self.GetItemMarketPrice(item, owned, stack)
    if false and owned then
        -- TODO: Calculate ACB price
    elseif TUJMarketInfo then
        local t = TUJMarketInfo(item, Util.Tbl())
        return t.recent, t.recent, t.market, t.globalMean, Util.TblRelease(t)
    end
end

-- Lookup the price to craft the item
-- @param int|string item Item id, string or link
-- @param bool owned Use ACB price of owned items and mats where possible
-- @param table stack Item ids being looked up recursively to prevent loops
-- @return float Current crafting price
function Self.GetItemCraftPrice(item, owned, stack)
    local recipes = Store.GetItemCraftRecipes(item)
    if recipes then
        local price
        for recipeId,recipe in pairs(recipes) do
            local price2 = Self.GetRecipePrice(recipe, owned, stack)
            if price2 and (not price or price2 / recipe.itemNum < price) then
                price = price2 / recipe.itemNum
            end
        end
        
        return price, Util.TblRelease(true, recipes)
    end
end

-- Lookup the price to convert other items to this item
-- @param int|string item Item id, string or link
-- @param bool owned Use ACB price of owned items and mats where possible
-- @param table stack Item ids being looked up recursively to prevent loops
-- @return float Current conversion price
function Self.GetItemConvertPrice(item, owned, stack)
    local id = tonumber(item) or Models.Item.GetInfo(item, "id")
    local price

    for method,items in pairs(Addon.Data.Conversions) do
        if items[id] and method ~= Convert.METHOD_DISENCHANT then -- TODO
            for matId,matRate in pairs(items[id]) do
                local price2 = Self.GetItemPrice(matId, owned, stack)
                if price2 and (not price or price2 / matRate < price) then
                    price = price2 / matRate
                end
            end
        end
    end

    return price
end

-- Lookup the value of conversion results for this item
-- @param int|string item Item id, string or link
-- @return float Current conversion result price
function Self.GetItemConvertValue(item)
    item = Models.Item.FromLink((select(2, GetItemInfo(item)))):GetBasicInfo()
    local price, method

    for m,items in pairs(Addon.Data.Conversions) do
        if m ~= Convert.METHOD_DISENCHANT then
            for itemId,sources in pairs(items) do
                if sources[item.id] then
                    local price = Self.GetItemMarketPrice(itemId)
                    if price2 and (not price or price2 * sources[item.id] < price) then
                        price, method = price2 * sources[item.id], m
                    end
                end
            end
        elseif Util.In(item.type, ARMOR, WEAPON) then
            local price2
            
            for id,sources in pairs(items) do
                for i,source in pairs(sources) do
                    if source.type == item.type and source.quality == item.quality and Util.NumIn(item.level, source.min, source.max) then
                        local price3 = Self.GetItemMarketPrice(id)
                        if price3 then
                            price2 = (price2 or 0) + price3 * source.amount
                        end
                    end
                end
            end

            if price2 and (not price or price2 < price) then
                price, method = price2, m
            end
        end
    end

    item:Release()
    return price, method
end

-------------------------------------------------------
--                      Recipe                       --
-------------------------------------------------------

-- Lookup the material price for this recipe
-- @param int|string recipe Recipe model instance
-- @param bool owned Use ACB price of owned items and mats where possible
-- @param table stack Item ids being looked up recursively to prevent loops
-- @return float Current recipe price
function Self.GetRecipePrice(recipe, owned, stack)
    local price = 0
    for matId,matNum in pairs(recipe.mats) do
        price = price + matNum * Self.GetItemPrice(matId, owned, stack)
    end    
    return price
end
