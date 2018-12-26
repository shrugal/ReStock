local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local LibExtraTip = LibStub("LibExtraTip-1")
local Price, Models, Store, Unit, Util = Addon.Price, Addon.Models, Addon.Store, Addon.Unit, Addon.Util
local Self = Addon.GUI.Tooltip

function Self:OnEnable()
    LibExtraTip:AddCallback(Self.OnTooltipSetItem)
    -- LibExtraTip:AddCallback({type = "battlepet", callback = Self.OnTooltipSetItem})
    LibExtraTip:RegisterTooltip(GameTooltip)
    -- LibExtraTip:RegisterTooltip(ItemRefTooltip)
    -- LibExtraTip:RegisterTooltip(BattlePetTooltip)
    -- LibExtraTip:RegisterTooltip(FloatingBattlePetTooltip)
end

function Self:OnDisable()
    LibExtraTip:RemoveCallback(Self.OnTooltipSetItem)
end

function Self.OnTooltipSetItem(tooltip, link, quantity)
    local id = Models.Item.GetInfo(link, "id")
    if id and id ~= "" then

        -- STOCK

        local stock = Store.GetItemStockCount(id, true, true)
        if stock > 0 then
            LibExtraTip:AddLine(tooltip, " ", 0, 0, 0, true)
            LibExtraTip:AddDoubleLine(tooltip, L["STOCK"] .. ":", stock, 66/255, 244/255, 206/255, 1, 1, 1, true)

            for unit,cache in pairs(Store.GetCache(Store.CAT_STOCK, true, true)) do
                local num = Store.GetItemStockCount(id, cache)

                if num > 0 then
                    local s = ""
                    for loc,locCache in pairs(cache) do
                        local locNum = Store.GetItemStockCount(id, locCache)
                        if locNum > 0 then
                            s = s .. (s == "" and "" or ", ") .. L["LOC_" .. loc] .. ": " .. locNum
                        end
                    end

                    local class = Store.GetCache(Store.CAT_CHAR, true, true, unit)

                    LibExtraTip:AddDoubleLine(tooltip, Unit.ColoredName(unit, nil, class), num .. " (" .. s .. ")", 1, 1, 1, 1, 1, 1, true)
                end
            end
        end

        -- PRICES

        local marketPrice = Price.GetItemMarketPrice(id)
        local craftPrice = Price.GetItemCraftPrice(id)
        local convertPrice, method = Price.GetItemConvertValue(link)
        local sellPrice = Models.Item.GetInfo(link, "sellPrice") or 0

        if marketPrice or craftPrice or convertPrice or sellPrice > 0 then
            LibExtraTip:AddLine(tooltip, "\n" .. L["PRICE"] .. ":", 66/255, 244/255, 206/255, true)

            if marketPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["MARKET"], LibExtraTip:GetMoneyText(marketPrice, false), .9, .8, .5, 1, 1, 1, true)
            end

            if craftPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["CRAFT"], LibExtraTip:GetMoneyText(craftPrice, false), .9, .8, .5, 1, 1, 1, true)
            end

            if convertPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["CONVERT_" .. method], LibExtraTip:GetMoneyText(convertPrice, false), .9, .8, .5, 1, 1, 1, true)
            end

            if sellPrice > 0 then
                LibExtraTip:AddDoubleLine(tooltip, L["VENDOR"], LibExtraTip:GetMoneyText(sellPrice, false), .9, .8, .5, 1, 1, 1, true)
            end
        end
    end
end