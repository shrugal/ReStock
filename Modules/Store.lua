local Name, Addon = ...
local Models, Unit, Util = Addon.Models, Addon.Unit, Addon.Util
local Self = Addon.Store

-- Cache categories
Self.CAT_CHAR = "CHAR"
Self.CAT_STOCK = "STOCK"
Self.CAT_CRAFT = "CRAFT"
Self.CAT_RECIPE = "RECIPE"
Self.CAT_CURRENCY = "CURRENCY"

-- Stock locations
Self.LOC_BAGS = "BAGS"
Self.LOC_BANK = "BANK"
Self.LOC_MAIL = "MAIL"
Self.LOC_AUCTIONS = "AUCTIONS"
Self.LOC_VOID = "VOID"

-- Craft tradeskill lines
Self.LINE_ALCHEMY = 171
Self.LINE_BLACKSMITHING = 164
Self.LINE_ENCHANTING = 333
Self.LINE_ENGINEERING = 202
Self.LINE_INSCRIPTION = 773
Self.LINE_JEWELCRAFTING = 755
Self.LINE_LEATHERWORKING = 165
Self.LINE_TAILORING = 197
Self.LINE_SKINNING = 393
Self.LINE_MINING = 186
Self.LINE_HERBALISM = 182
Self.LINE_SMELTING = nil -- TODO
Self.LINE_COOKING = 185
Self.LINE_FISHING = 356
Self.LINE_ARCHAEOLOGY = nil -- TODO

-- Craft tradeskill spell ids
Self.PROF_ALCHEMY = 2259
Self.PROF_BLACKSMITHING = 3100
Self.PROF_ENCHANTING = 7411
Self.PROF_ENGINEERING = 4036
Self.PROF_INSCRIPTION = 45357
Self.PROF_JEWELCRAFTING = 25229
Self.PROF_LEATHERWORKING = 2108
Self.PROF_TAILORING = 3908
Self.PROF_SKINNING = 8613
Self.PROF_MINING = 2575
Self.PROF_HERBALISM = 2366
Self.PROF_SMELTING = 2656
Self.PROF_COOKING = 2550
Self.PROF_FISHING = 131474
Self.PROF_ARCHAEOLOGY = 78670

Self.IGNORE = {
    [Self.CAT_STOCK] = {
        [6948] = true,   -- Heathstone
        [6948] = true,   -- Garrison Hearthstone
        [140192] = true, -- Dalaran Hearthstone
    }
}

-- Last cache updates
Self.lastUpdate = {}

-------------------------------------------------------
--                        API                        --
-------------------------------------------------------

-- Get stock count for an item
function Self.GetItemStockCount(item, realmOrCache, faction, unit, loc)
    local id = tonumber(item) or Models.Item.GetInfo(item, "id")
    local cache = type(realmOrCache) == "table" and realmOrCache or Self.GetCache(Self.CAT_STOCK, realmOrCache, faction, unit, loc)

    if not cache then
        return 0
    elseif type(cache[id]) == "number" then
        return cache[id]
    else
        local count = 0
        for i,v in pairs(cache) do
            if type(v) == "table" then
                count = count + Self.GetItemStockCount(id, v)
            else
                break
            end
        end
        return count
    end
end

-- Get a list of craft recipes with mats for an item
function Self.GetItemCraftRecipes(item, realmOrCache, faction, unit)
    local id = tonumber(item) or Models.Item.GetInfo(item, "id")
    local cache = type(realmOrCache) == "table" and realmOrCache or Self.GetCache(Self.CAT_CRAFT, realmOrCache, faction, unit)

    if cache then
        local t = Util.Tbl()
        if type(cache[id]) == "string" then
            for i,recipeId in Util.Each(strsplit(",", cache[id])) do
                t[tonumber(recipeId)] = Models.Recipe.FromId(recipeId)
            end
        else
            for i,v in pairs(cache) do
                if type(v) == "table" then
                    local recipes = Self.GetItemCraftRecipes(id, v)
                    Util.TblMerge(t, recipes)
                    Util.TblRelease(recipes)
                else
                    break
                end
            end
        end
        return t
    end
end

-------------------------------------------------------
--                       Cache                       --
-------------------------------------------------------

--[[ Structure

CHAR:
    realm:
        faction:
            unit: class
STOCK:
    realm:
        faction:
            unit:
                loc:
                    id: amount
                    or
                    bag: id: amount
CRAFT:
    realm:
        faction:
            unit:
                line:
                    id: recipes
RECIPE:
    id: recipe

]]

-- Get a cache or cache entry
function Self.GetCache(cat, ...)
    local realm, faction, unit, val = ...
    if realm == true then
        return Self.GetCache(cat, Addon.REALM, select(2, ...))
    elseif realm == Addon.REALM and faction == true then
        return Self.GetCache(cat, realm, Addon.FACTION, select(3, ...))
    elseif realm == Addon.REALM and faction == Addon.FACTION and unit == true then
        return Self.GetCache(cat, realm, faction, Addon.UNIT, select(4, ...))
    elseif cat == Self.CAT_STOCK and tonumber(val) then
        return Self.GetCache(cat, realm, faction, unit, Self.GetBagLoc(val), tonumber(val), select(5, ...))
    end

    return Util.TblGet(Self.cache, cat, ...)
end

-- Set a cache or cache entry
function Self.SetCache(cat, ...)
    local realm, faction, unit, val = ...
    if realm == true then
        return Self.SetCache(cat, Addon.REALM, select(2, ...))
    elseif realm == Addon.REALM and faction == true then
        return Self.SetCache(cat, realm, Addon.FACTION, select(3, ...))
    elseif realm == Addon.REALM and faction == Addon.FACTION and unit == true then
        return Self.SetCache(cat, realm, faction, Addon.UNIT, select(4, ...))
    elseif cat == Self.CAT_STOCK and tonumber(val) then
        return Self.SetCache(cat, realm, faction, unit, Self.GetBagLoc(val), tonumber(val), select(5, ...))
    end

    return Util.TblSet(Self.cache, cat, ...)
end

-- Get a cache for the current player
function Self.GetCachePlayer(cat, ...)
    return Self.GetCache(cat, true, true, true, ...)
end

-- Set a cache for the current player
function Self.SetCachePlayer(cat, ...)
    return Self.SetCache(cat, true, true, true, ...)
end

-------------------------------------------------------
--                       Update                      --
-------------------------------------------------------

-- Update one bag
function Self.UpdateBag(bag)
    if GetContainerNumSlots(bag) > 0 then
        local cache = Self.GetCachePlayer(Self.CAT_STOCK, bag)
        if cache then wipe(cache) end

        for slot=1,GetContainerNumSlots(bag) do
            local id, count = GetContainerItemID(bag, slot), select(2, GetContainerItemInfo(bag, slot))
            if id and count and not Self.IGNORE[Self.CAT_STOCK][id] then
                cache = cache or Util.Tbl()
                cache[id] = (cache[id] or 0) + count
            end
        end

        Self.SetCachePlayer(Self.CAT_STOCK, bag, cache)
    end
end

-- Update all bag items
function Self.UpdateBags()
    Self.CleanLocPreUpdate(Self.LOC_BAGS)

    for bag=BACKPACK_CONTAINER,NUM_BAG_SLOTS do
        Self.UpdateBag(bag)
    end

    Self.CleanLocPostUpdate(Self.LOC_BAGS)
end

-- Update bank items
function Self.UpdateBank()
    Self.CleanLocPreUpdate(Self.LOC_BANK)

    -- Bags
    Self.UpdateBag(BANK_CONTAINER)
    for bag=NUM_BAG_SLOTS+1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
        Self.UpdateBag(bag)
    end

    -- Reagents
    if IsReagentBankUnlocked() then
        Self.UpdateBag(REAGENTBANK_CONTAINER)
    end

    Self.CleanLocPostUpdate(Self.LOC_BANK)
end

-- Update mail items
function Self.UpdateMail()
    -- We can only reliably update the cache if we have can check every mail
    local curr, total = GetInboxNumItems()
    if curr <= total then
        local cache = wipe(Self.GetCachePlayer(Self.CAT_STOCK, Self.LOC_MAIL) or Util.Tbl())

        for slot=1,curr do
            for item=1,ATTACHMENTS_MAX_RECEIVE do
                local _, id, _, count = GetInboxItem(slot, item)
                Self.IncStockCountBy(cache, id, count)
            end
        end

        Self.SetCachePlayer(Self.CAT_STOCK, Self.LOC_MAIL, cache)
    end
end

-- Update mail items when sending
function Self.UpdateMailSend(unit)
    local cache = Util.TblGet(Self.cache, Addon.REALM, Addon.FACTION, unit, Self.LOC_MAIL) or Util.Tbl()

    for slot=1,ATTACHMENTS_MAX_SEND do
        if HasSendMailItem(slot) then
            local _, id, _, count = GetSendMailItem(slot)
            Self.IncStockCountBy(cache, id, count)
        end
    end

    Util.TblSet(Self.cache, Addon.REALM, Addon.FACTION, unit, Self.LOC_MAIL, cache)
end

-- Update mail items when canceling auctions
function Self.UpdateMailCanceledAuctions(slot)
    local cache = Self.GetCachePlayer(Self.CAT_STOCK, Self.LOC_MAIL) or Util.Tbl()

    local _, _, count, _, _, _, _, _, _, _, _, _, _, _, _, _, id = GetAuctionItemInfo("owner", slot)
    Self.IncStockCountBy(cache, id, count)

    Self.SetCachePlayer(Self.CAT_STOCK, Self.LOC_MAIL, cache)
end

-- Update auction items
function Self.UpdateAuctions()
    local cache = wipe(Self.GetCachePlayer(Self.CAT_STOCK, Self.LOC_AUCTIONS) or Util.Tbl())

    for slot=1,GetNumAuctionItems("owner") do
        local _, _, count, _, _, _, _, _, _, _, _, _, _, _, _, _, id = GetAuctionItemInfo("owner", slot)
        Self.IncStockCountBy(cache, id, count)
    end

    Self.SetCachePlayer(Self.CAT_STOCK, Self.LOC_AUCTIONS, cache)
end

function Self.UpdateCraftRecipes()
    if not Self.IsCraftInfoAvailable() then return end

    local line = Self.GetCurrentCraftLine()

    local cache = Self.GetCachePlayer(Self.CAT_CRAFT, line)
    if cache then wipe(cache) end

    local info = Util.Tbl()
    for i,recipeId in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
        C_TradeSkillUI.GetRecipeInfo(recipeId, info)

        if info.craftable and info.learned then
            -- Save recipe
            local recipe = Models.Recipe.FromId(recipeId):Store()

            -- Save item->recipe index
            cache = cache or Util.Tbl()
            cache[recipe.itemId] = (cache[recipe.itemId] and cache[recipe.itemId] .. "," or "") .. recipeId

            recipe:Release()
        end
    end

    Util.TblRelease(info)

    -- Save cache
    Self.SetCachePlayer(Self.CAT_CRAFT, line, cache)
    Util.TblSet(Self.lastUpdate, Self.CAT_CRAFT, line, time())
end

-------------------------------------------------------
--                       Helper                      --
-------------------------------------------------------

function Self.GetBagLoc(bag)
    return (bag == BANK_CONTAINER or bag == REAGENTBANK_CONTAINER or bag > NUM_BAG_SLOTS) and Self.LOC_BANK or Self.LOC_BAGS
end

function Self.IsCraftInfoAvailable()
    return C_TradeSkillUI.IsTradeSkillReady() and not (C_TradeSkillUI.IsTradeSkillGuild() or C_TradeSkillUI.IsTradeSkillLinked() or C_TradeSkillUI.IsNPCCrafting())
end

function Self.GetCurrentCraftLine()
    local line, _, _, _, _, parentLine = C_TradeSkillUI.GetTradeSkillLine()
    return parentLine or line
end

function Self.DecodeRecipe(recipe)
    local item, mats = strsplit(":", recipe)
    local itemNum, itemId = strsplit("x", item)

    local t = Util.Tbl()
    for j,mat in Util.Each(strsplit(",", mats)) do
        local matNum, matId = strsplit("x", mat)
        t[tonumber(matId)] = tonumber(matNum)
    end

    return itemId, itemNum, t
end

function Self.Inspect()
    Util.TblInspect(Self.cache)
end

function Self.CleanLocPreUpdate(loc)
    local cache = Self.GetCachePlayer(Self.CAT_STOCK, loc)
    if cache then
        for i,v in pairs(cache) do wipe(v) end
    end
end

function Self.CleanLocPostUpdate(loc)
    local cache = Self.GetCachePlayer(Self.CAT_STOCK, loc)
    if cache then
        local keys = Util.TblKeys(cache)
        for _,key in pairs(keys) do
            if Util.TblCount(cache[key]) == 0 then cache[key] = nil end
        end
        Util.TblRelease(keys)
    end
end

function Self.IncStockCountBy(cache, id, count)
    if cache and id and count and not Self.IGNORE[Self.CAT_STOCK][id] then
        cache[id] = (cache[id] or 0) + count
    end
end

-------------------------------------------------------
--                    Events/Hooks                   --
-------------------------------------------------------

function Self:OnEnable()
    -- Get or create cache
    ReStockStore = ReStockStore or Util.Tbl()
    Self.cache = ReStockStore

    -- Update char info
    Self.SetCachePlayer(Self.CAT_CHAR, (select(2, UnitClass("player"))))
    
    -- Update bags
    Self.UpdateBags()

    -- Register events
    Self:RegisterEvent("BAG_UPDATE", Self.UpdateBags)
    Self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", Self.UpdateBank)
    Self:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED", Self.UpdateBank)
    Self:RegisterEvent("BANKFRAME_OPENED", Self.UpdateBank)
    Self:RegisterEvent("MAIL_SHOW")
    Self:RegisterEvent("MAIL_INBOX_UPDATE", Self.UpdateMail)
    Self:RegisterEvent("AUCTION_OWNED_LIST_UPDATE", Self.UpdateAuctions)
    Self:RegisterEvent("AUCTION_HOUSE_SHOW", Self.UpdateAuctions)
    Self:RegisterEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
    Self:RegisterMessage(Addon.MSG_ITEM_MOVE, "ITEM_MOVE_OR_SWITCH")
    Self:RegisterMessage(Addon.MSG_ITEM_SWITCH, "ITEM_MOVE_OR_SWITCH")

    -- Hooks
    Self:SecureHook("SendMail", "OnSendMail")
    Self:SecureHook("CancelAuction", "OnCancelAuction")
end

function Self:ITEM_MOVE_OR_SWITCH(_, fromBagOrEquip, fromSlot, toBagOrEquip, toSlot)
    if fromSlot then
        Self.UpdateBag(fromBagOrEquip)
    end
    if toSlot and fromBagOrEquip ~= toBagOrEquip then
        Self.UpdateBag(toBagOrEquip)
    end
end

function Self:MAIL_SHOW()
    CheckInbox()
end

function Self:TRADE_SKILL_DATA_SOURCE_CHANGED()
    local line = Self.GetCurrentCraftLine()
    local lastUpdate = Util.TblGet(Self.lastUpdate, Self.CAT_CRAFT, line)

    if not lastUpdate then
        Self.UpdateCraftRecipes()
    end
end

function Self:OnSendMail(unit)
    unit = Unit.ShortName(unit)
    if Util.TblGet(Self.cache, Addon.REALM, Addon.FACTION, unit) then
        Self.UpdateMailSend(unit)
    end
end

function Self:OnCancelAuction(slot)
    Self.UpdateMailCanceledAuctions(slot)
end