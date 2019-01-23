local Name, Addon = ...
local Craft, Inventory, Models, Unit, Util = Addon:Import("Craft", "Inventory", "Models", "Unit", "Util")
local Self = Addon.Store

-- Cache categories
Self.CAT_GROUP = Models.Group.STORE
Self.CAT_ITEM = Models.Item.STORE
Self.CAT_OPERATION = Models.Operation.STORE
Self.CAT_RECIPE = Models.Recipe.STORE
Self.CAT_TASK = "TASK" -- TODO

Self.CAT_CHAR = "CHAR"
Self.CAT_CRAFT = "CRAFT"
Self.CAT_CURRENCY = "CURRENCY"
Self.CAT_ITEMS = "ITEMS"
Self.CAT_STOCK = "STOCK"

-- Stock locations
Self.LOC_BAGS = "BAGS"
Self.LOC_BANK = "BANK"
Self.LOC_MAIL = "MAIL"
Self.LOC_AUCTIONS = "AUCTIONS"
Self.LOC_VOID = "VOID"

Self.IGNORE = {
    [Self.CAT_STOCK] = {
        [6948] = true,   -- Heathstone
        [110560] = true, -- Garrison Hearthstone
        [140192] = true, -- Dalaran Hearthstone
        [141652] = true, -- Mana Divining Stone
        [141605] = true, -- Flight Master Whistle
        [138111] = true, -- Stormforged Grapple Launcher
    }
}

-- Last cache updates
Self.lastUpdate = {}

function Self.Inspect()
    Util.TblInspect(Self.cache)
end

function Self.Wipe()
    Util.TblWipe(1, Self.cache)
end

-- Get stock count for an item
function Self.GetItemCount(cache, item)
    local id = tonumber(item) or Models.Item:GetInfo(item, "id")

    if not (id and cache) then
        return 0
    elseif tonumber(cache[id]) then
        return cache[id]
    else
        local count = 0
        for i,v in pairs(cache) do
            if type(v) == "table" then
                count = count + Self.GetItemCount(v, id)
            else
                break
            end
        end
        return count
    end
end

-- Increment stock count for an item
function Self.IncItemCount(cache, item, inc)
    local id = tonumber(item) or Models.Item:GetInfo(item, "id")

    if id and not (
        Self.IGNORE[Self.CAT_STOCK][id]
        or Models.Item:GetInfo(item, "type") == "Quest"
        or Models.Item:GetInfo(item, "quality") == LE_ITEM_QUALITY_POOR
    ) then
        local count = (cache and cache[id] or 0) + (inc or 1)
        if count > 0 or cache then
            cache = cache or Util.Tbl()
            cache[id] = count > 0 and count or nil
        end
    end
    return cache
end

-- Decrement stock count for an item
function Self.DecItemCount(cache, item, dec)
    return Self.IncItemCount(cache, item, -(dec or 1))
end

-- Get a list of craft recipes with mats for an item
function Self.GetItemRecipes(cache, item)
    cache = cache or Self.GetFaction(Self.CAT_CRAFT)
    local id = tonumber(item) or Models.Item:GetInfo(item, "id")
    local t = Util.Tbl()
    
    if cache then
        if type(cache[id]) == "string" then
            for i,recipeId in Util.Each(strsplit(",", cache[id])) do
                t[tonumber(recipeId)] = Models.Recipe:Fetch(recipeId)
            end
        else
            for i,v in pairs(cache) do
                if type(v) == "table" then
                    local recipes = Self.GetItemRecipes(v, id)
                    Util.TblMerge(t, recipes)
                    Util.TblRelease(recipes)
                else
                    break
                end
            end
        end
    end

    return t
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
OPERATION:
    realm:
        faction:
            id: operation
TASK:
    realm:
        faction:
            id: task
ITEM:
    realm:
        faction:
            id: item
ITEMS:
    ["name:id", ...]
]]

-- Get a cache or cache entry
function Self.Get(cat, ...)
    if cat == Self.CAT_STOCK then
        local realm, faction, unit, bag = ...
        if tonumber(bag) then
            return Self.Get(cat, realm, faction, unit, Inventory.GetBagLoc(bag), tonumber(bag), select(5, ...))
        end
    end

    return Util.TblGet(Self.cache, cat, ...)
end

-- Set a cache or cache entry
function Self.Set(cat, ...)
    if cat == Self.CAT_STOCK then
        local realm, faction, unit, bag = ...
        if tonumber(bag) then
            return Self.Set(cat, realm, faction, unit, Inventory.GetBagLoc(bag), tonumber(bag), select(5, ...))
        end
    end

    return Util.TblSet(Self.cache, cat, ...)
end

-- Get and set for the current realm/faction/unit
function Self.GetRealm(cat, ...) return Self.Get(cat, Addon.REALM, ...) end
function Self.SetRealm(cat, ...) return Self.Set(cat, Addon.REALM, ...) end
function Self.GetFaction(cat, ...) return Self.Get(cat, Addon.REALM, Addon.FACTION, ...) end
function Self.SetFaction(cat, ...) return Self.Set(cat, Addon.REALM, Addon.FACTION, ...) end
function Self.GetUnit(cat, ...) return Self.Get(cat, Addon.REALM, Addon.FACTION, Addon.UNIT, ...) end
function Self.SetUnit(cat, ...) return Self.Set(cat, Addon.REALM, Addon.FACTION, Addon.UNIT, ...) end

-------------------------------------------------------
--                    Update cache                   --
-------------------------------------------------------

-- AUCTIONS

-- Update auction items
function Self.UpdateAuctions()
    local cache = Util.TblWipe(Self.GetUnit(Self.CAT_STOCK, Self.LOC_AUCTIONS))

    for slot=1,GetNumAuctionItems("owner") do
        local _, _, count, _, _, _, _, _, _, _, _, _, _, _, _, _, id = GetAuctionItemInfo("owner", slot)
        cache = Self.IncItemCount(cache, id, count)
    end

    Self.SetUnit(Self.CAT_STOCK, Self.LOC_AUCTIONS, cache)
end

-- INVENTORY

-- Update one bag
function Self.UpdateBag(bag)
    local cache = Util.TblWipe(Self.GetUnit(Self.CAT_STOCK, bag))

    if GetContainerNumSlots(bag) > 0 then
        for slot=1,GetContainerNumSlots(bag) do
            local link, count = GetContainerItemLink(bag, slot), select(2, GetContainerItemInfo(bag, slot))
            cache = Self.IncItemCount(cache, link, count)
        end

        Self.SetUnit(Self.CAT_STOCK, bag, cache)
    end
end

-- Update all bag items
function Self.UpdateBags()
    for bag=BACKPACK_CONTAINER,NUM_BAG_SLOTS do
        Self.UpdateBag(bag)
    end
end

-- Update bank items
function Self.UpdateBank()
    -- Bags
    Self.UpdateBag(BANK_CONTAINER)
    for bag=NUM_BAG_SLOTS+1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
        Self.UpdateBag(bag)
    end

    -- Reagents
    if IsReagentBankUnlocked() then
        Self.UpdateBag(REAGENTBANK_CONTAINER)
    end
end

-- MAIL

-- Update mail items
function Self.UpdateMail()
    -- We can only reliably update the cache if we can check every mail
    local curr, total = GetInboxNumItems()
    if curr <= total then
        local cache = Util.TblWipe(Self.GetUnit(Self.CAT_STOCK, Self.LOC_MAIL))

        for slot=1,curr do
            for item=1,ATTACHMENTS_MAX_RECEIVE do
                local _, id, _, count = GetInboxItem(slot, item)
                cache = Self.IncItemCount(cache, id, count)
            end
        end

        Self.SetUnit(Self.CAT_STOCK, Self.LOC_MAIL, cache)
    end
end

-- Update mail items when sending
function Self.UpdateMailSend(unit)
    local cache = Self.GetFaction(Self.LOC_MAIL, unit)

    for slot=1,ATTACHMENTS_MAX_SEND do
        if HasSendMailItem(slot) then
            local _, id, _, count = GetSendMailItem(slot)
            cache = Self.IncItemCount(cache, id, count)
        end
    end

    Self.SetFaction(Self.CAT_STOCK, unit, Self.LOC_MAIL, cache)
end

-- Update mail items when canceling auctions
function Self.UpdateMailAuctionCanceled(slot)
    local cache = Self.GetUnit(Self.CAT_STOCK, Self.LOC_MAIL)

    local _, _, count, _, _, _, _, _, _, _, _, _, _, _, _, _, id = GetAuctionItemInfo("owner", slot)
    cache = Self.IncItemCount(cache, id, count)

    Self.SetUnit(Self.CAT_STOCK, Self.LOC_MAIL, cache)
end

-- CRAFT

function Self.UpdateRecipes()
    if not Craft.IsInfoAvailable() then return end

    local line = Craft.GetCurrentLine()
    Util.TblWipe(Self.GetUnit(Self.CAT_CRAFT, line))

    local info = Util.Tbl()
    for i,recipeId in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
        C_TradeSkillUI.GetRecipeInfo(recipeId, info)

        if info.craftable and info.learned then
            Models.Recipe:Fetch(recipeId):Store(line):Release()
        end
    end

    -- Save last update and cleanup
    Util.TblSet(Self.lastUpdate, Self.CAT_CRAFT, line, time())
    Util.TblRelease(info)
end

-------------------------------------------------------
--                    Events/Hooks                   --
-------------------------------------------------------

function Self:OnEnable()
    -- Get or create cache
    ReStockStore = ReStockStore or Util.Tbl()
    Self.cache = ReStockStore

    -- Update char info
    Self.SetUnit(Self.CAT_CHAR, (select(2, UnitClass("player"))))

    -- Events
    Self:RegisterEvent("AUCTION_OWNED_LIST_UPDATE", Self.UpdateAuctions)
    Self:RegisterEvent("AUCTION_HOUSE_SHOW", Self.UpdateAuctions)
    Self:RegisterEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
    Self:RegisterEvent("BAG_UPDATE", Self.UpdateBags)
    Self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", Self.UpdateBank)
    Self:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED", Self.UpdateBank)
    Self:RegisterEvent("BANKFRAME_OPENED", Self.UpdateBank)
    Self:RegisterEvent("MAIL_SHOW")
    Self:RegisterEvent("MAIL_INBOX_UPDATE", Self.UpdateMail)

    Self:RegisterMessage(Addon.MSG_ITEM_MOVE, "ITEM_MOVE_OR_SWITCH")
    Self:RegisterMessage(Addon.MSG_ITEM_SWITCH, "ITEM_MOVE_OR_SWITCH")

    -- Hooks
    Self:SecureHook("CancelAuction", Self.UpdateMailAuctionCanceled)
    Self:SecureHook("SendMail", "OnSendMail")
end

function Self:TRADE_SKILL_DATA_SOURCE_CHANGED()
    local line = Craft.GetCurrentLine()
    local lastUpdate = Util.TblGet(Self.lastUpdate, Self.CAT_CRAFT, line)

    if not lastUpdate then
        Self.UpdateRecipes()
    end
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

function Self:OnSendMail(unit)
    unit = Unit.ShortName(unit)
    if Self.GetFaction(Self.CAT_CHAR, unit) then
        Self.UpdateMailSend(unit)
    end
end
