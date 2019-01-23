local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local Models, Store, Unit, Util = Addon.Models, Addon.Store, Addon.Unit, Addon.Util
local Self = Addon

Self.MSG_ITEM_MOVE = "RS_ITEM_MOVE"
Self.MSG_ITEM_SWITCH = "RS_ITEM_SWITCH"

-- Remember the last locked item slot
Self.lastLocked = {}
-- Remember the bag of the last looted item
Self.lastLootedBag = nil

-- (Un)Register

function Self.RegisterEvents()
    -- Item
    Addon:RegisterEvent("ITEM_PUSH")
    Addon:RegisterEvent("ITEM_LOCKED")
    Addon:RegisterEvent("ITEM_UNLOCKED")
end

function Self.UnregisterEvents()
    -- Item
    Addon:UnregisterEvent("ITEM_PUSH")
    Addon:UnregisterEvent("ITEM_LOCKED")
    Addon:UnregisterEvent("ITEM_UNLOCKED")
end

-------------------------------------------------------
--                      Items                        --
-------------------------------------------------------

function Self:ITEM_PUSH(event, bagId)
    Self.lastLootedBag = bagId == 0 and 0 or (bagId - CharacterBag0Slot:GetID() + 1)
end

function Self:ITEM_LOCKED(event, bagOrEquip, slot)
    tinsert(Self.lastLocked, Util.Tbl(bagOrEquip, slot))
end

function Self:ITEM_UNLOCKED(event, bagOrEquip, slot)
    local pos = Util.Tbl(bagOrEquip, slot)
    
    -- Check if items have been moved or switched
    if #Self.lastLocked == 1 and not Util.TblEquals(pos, Self.lastLocked[1]) then
        Self:SendMessage(Self.MSG_ITEM_MOVE, Self.lastLocked[1][1], Self.lastLocked[1][2], pos[1], pos[2])
    elseif #Self.lastLocked == 2 then
        Self:SendMessage(Self.MSG_ITEM_SWITCH, Self.lastLocked[1][1], Self.lastLocked[1][2], Self.lastLocked[2][1], Self.lastLocked[2][2])
    end

    Util.TblRelease(pos)
    for _,t in pairs(Self.lastLocked) do Util.TblRelease(t) end
    wipe(Self.lastLocked)
end