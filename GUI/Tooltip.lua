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
    local q = IsShiftKeyDown() and quantity or 1

    if id and id ~= "" then

        -- STOCK

        local cache = Store.GetFactionCache(Store.CAT_STOCK)
        local stock = Store.GetItemCount(cache, id)

        if stock > 0 then
            LibExtraTip:AddLine(tooltip, " ", 0, 0, 0, true)
            LibExtraTip:AddDoubleLine(tooltip, L["STOCK"] .. ":", stock, 66/255, 244/255, 206/255, 1, 1, 1, true)

            for unit,unitCache in pairs(cache) do
                local num = Store.GetItemCount(unitCache, id)

                if num > 0 then
                    local s = ""
                    for loc,locCache in pairs(unitCache) do
                        local locNum = Store.GetItemCount(locCache, id)
                        if locNum > 0 then
                            s = s .. (s == "" and "" or ", ") .. L["LOC_" .. loc] .. ": " .. locNum
                        end
                    end

                    local class = Store.GetFactionCache(Store.CAT_CHAR, unit)

                    LibExtraTip:AddDoubleLine(tooltip, Unit.ColoredName(unit, nil, class), num .. " (" .. s .. ")", 1, 1, 1, 1, 1, 1, true)
                end
            end
        end

        -- PRICES

        local buyoutPrice, marketPrice, historicPrice = Price.GetItemMarketPrice(id)
        local craftPrice = Price.GetItemCraftPrice(id)
        local convertPrice, method = Price.GetItemConvertValue(link)
        local sellPrice = Models.Item.GetInfo(link, "sellPrice") or 0

        if buyoutPrice or marketPrice or historicPrice or craftPrice or convertPrice or sellPrice > 0 then
            local txt = "\n" .. L["PRICE"] .. (quantity > 1 and " (" .. q .. ")" or "") .. ":"
            LibExtraTip:AddLine(tooltip, txt, 66/255, 244/255, 206/255, true)

            if buyoutPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["BUYOUT"], LibExtraTip:GetMoneyText(buyoutPrice * q, false), .9, .8, .5, 1, 1, 1, true)
            end

            if marketPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["MARKET"], LibExtraTip:GetMoneyText(marketPrice * q, false), .9, .8, .5, 1, 1, 1, true)
            end

            if historicPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["HISTORIC"], LibExtraTip:GetMoneyText(historicPrice * q, false), .9, .8, .5, 1, 1, 1, true)
            end

            if craftPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["CRAFT"], LibExtraTip:GetMoneyText(craftPrice * q, false), .9, .8, .5, 1, 1, 1, true)
            end

            if convertPrice then
                LibExtraTip:AddDoubleLine(tooltip, L["CONVERT_" .. method], LibExtraTip:GetMoneyText(convertPrice * q, false), .9, .8, .5, 1, 1, 1, true)
            end

            if sellPrice > 0 then
                LibExtraTip:AddDoubleLine(tooltip, L["VENDOR"], LibExtraTip:GetMoneyText(sellPrice * q, false), .9, .8, .5, 1, 1, 1, true)
            end
        end
    end
end