local Name, Addon = ...
local Models, Unit, Util = Addon.Models, Addon.Unit, Addon.Util
local Super = Models.Model
local Self = Models.Item

Self.__index = Self
setmetatable(Self, Super)

Self.STORE = Store.CAT_ITEM
Self.REF = "item"

-- For editor auto-completion:
-- Quality: LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_COMMON, LE_ITEM_QUALITY_UNCOMMON, LE_ITEM_QUALITY_RARE, LE_ITEM_QUALITY_EPIC, LE_ITEM_QUALITY_LEGENDARY, LE_ITEM_QUALITY_ARTIFACT, LE_ITEM_QUALITY_HEIRLOOM, LE_ITEM_QUALITY_WOW_TOKEN
-- Bind types: LE_ITEM_BIND_NONE, LE_ITEM_BIND_ON_ACQUIRE, LE_ITEM_BIND_ON_EQUIP, LE_ITEM_BIND_ON_USE, LE_ITEM_BIND_QUEST

-- Tooltip search patterns
Self.PATTERN_LINK = "(|?c?f?f?%x*|?H?item:[^|]*|?h?[^|]*|?h?|?r?)"
Self.PATTERN_ILVL = ITEM_LEVEL:gsub("%%d", "(%%d+)")
Self.PATTERN_ILVL_SCALED = ITEM_LEVEL_ALT:gsub("%(%%d%)", "%%%(%%%d%%%)"):gsub("%%d", "(%%d+)")
Self.PATTERN_MIN_LEVEL = ITEM_MIN_LEVEL:gsub("%%d", "(%%d+)")
Self.PATTERN_HEIRLOOM_LEVEL = ITEM_LEVEL_RANGE:gsub("%%d", "(%%d+)")
Self.PATTERN_RELIC_TYPE = RELIC_TOOLTIP_TYPE:gsub("%%s", "(.+)")
Self.PATTERN_CLASSES = ITEM_CLASSES_ALLOWED:gsub("%%s", "(.+)")
Self.PATTERN_SPEC = ITEM_REQ_SPECIALIZATION:gsub("%%s", "(.+)")
Self.PATTERN_STRENGTH = ITEM_MOD_STRENGTH:gsub("%%c%%s", "^%%p(.+)")
Self.PATTERN_INTELLECT = ITEM_MOD_INTELLECT:gsub("%%c%%s", "^%%p(.+)")
Self.PATTERN_AGILITY = ITEM_MOD_AGILITY:gsub("%%c%%s", "^%%p(.+)")
Self.PATTERN_SOULBOUND = ITEM_SOULBOUND
Self.PATTERN_TRADE_TIME_REMAINING = BIND_TRADE_TIME_REMAINING:gsub("%%s", ".+")
Self.PATTERN_APPEARANCE_KNOWN = TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN
Self.PATTERN_APPEARANCE_UNKNOWN = TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN
Self.PATTERN_APPEARANCE_UNKNOWN_ITEM = TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN

-- Item loading status
Self.INFO_NONE = 0
Self.INFO_LINK = 1
Self.INFO_BASIC = 2
Self.INFO_FULL = 3

-- Item info positions
Self.INFO = {
    link = {
        color = "%|cff(%x+)",
        name = "%|h%[([^%]]+)%]%|h",
        id = 1,
        -- enchantId = 2,
        -- gemId1 = 3,
        -- gemId2 = 4,
        -- gemId3 = 5,
        -- gemId4 = 6,
        -- suffixId = 7,
        -- uniqueId = 8,
        linkLevel = 9,
        -- specId = 10,
        -- upgradeId = 11,
        -- difficultyId = 12,
        numBonusIds = 13,
        -- bonusIds = 14,
        upgradeLevel = 15
    },
    basic = {
        name = 1,
        link = 2,
        quality = 3,
        level = 4,
        -- minLevel = 5,
        type = 6,
        subType = 7,
        -- stackCount = 8,
        equipLoc = 9,
        texture = 10,
        sellPrice = 11,
        classId = 12,
        subClassId = 13,
        bindType = 14,
        expacId = 15,
        -- setId = 16,
        isCraftingReagent = 17
    },
    full = {
        classes = true,
        spec = true,
        relicType = true,
        realLevel = true,
        realMinLevel = true,
        fromLevel = true,
        toLevel = true,
        attributes = true,
        isTransmogKnown = true
    }
}

-------------------------------------------------------
--                      Static                       --
-------------------------------------------------------

-- Create an item instance from a link or id
function Self.Create(item, bagOrEquip, slot)
    return Super.Create(Self,
        "id", Self.GetInfo(item, "id"),
        "link", Self.GetInfo(item, "link"),
        "infoLevel", Self.INFO_NONE,
        "bagOrEquip", bagOrEquip,
        "slot", slot
    )
end

-- Create an item instance for the given equipment slot
function Self.FromSlot(slot, unit)
    local link = GetInventoryItemLink(unit or "player", slot)
    return link and Self.Create(link, slot) or nil
end

-- Create an item instance from the given bag position
function Self.FromBagSlot(bag, slot)
    local link = GetContainerItemLink(bag, slot)
    return link and Self.Create(link, bag, slot) or nil
end

-------------------- LINKS --------------------

-- Get the item link from a string
function Self.GetLink(str)
    if type(str) == "table" then
        return str.link
    elseif type(str) == "string" then
        return select(3, str:find(Self.PATTERN_LINK))
    end
end

-- Get a version of the link for the given player level
function Self.GetLinkForLevel(link, level)
    local i = 0
    return link:gsub(":[^:]*", function (s)
        i = i + 1
        if i == Self.INFO.link.linkLevel then
            return ":" .. (level or MAX_PLAYER_LEVEL)
        end
    end)
end

-- Get a version of the link that is scaled to the given player level
function Self.GetLinkScaled(link, level)
   local i, numBonusIds = 0, 1
   return link:gsub(":([^:]*)", function (s)
         i = i + 1
         if i == Self.INFO.link.numBonusIds then
            numBonusIds = tonumber(s) or 0
         elseif i == Self.INFO.link.upgradeLevel - 1 + numBonusIds then
            return ":" .. (level or MAX_PLAYER_LEVEL)
         end
   end)
end

-- Check if string is an item link
function Self.IsLink(str)
    str = Self.GetLink(str)

    if type(str) == "string" then
        local i, j = str:find(Self.PATTERN_LINK)
        return i == 1 and j == str:len()
    else
        return false
    end
end

-------------------- INFO --------------------

-- Get just one item attribute, without creating an item instance or figuring out all other attributes as well
local scanFn = function (i, line, lines, attr)
    -- classes
    if attr == "classes" then
        local classes = line:match(Self.PATTERN_CLASSES)
        return classes and Util.StrSplit(classes, ", ") or nil
    -- spec
    elseif attr == "spec" then
        local spec = line:match(Self.PATTERN_SPEC)
        return spec and Util.In(spec, Unit.Specs()) and spec or nil
    -- relicType
    elseif attr == "relicType" then
        return line:match(Self.PATTERN_RELIC_TYPE) or nil
    -- realLevel
    elseif attr == "realLevel" then
        return tonumber(select(2, line:match(Self.PATTERN_ILVL_SCALED)) or line:match(Self.PATTERN_ILVL))
    -- realMinLevel
    elseif attr == "realMinLevel" then
        return tonumber(line:match(Self.PATTERN_MIN_LEVEL))
    -- fromlevel, toLevel
    elseif Util.In(attr, "fromLevel", "toLevel") then
        local from, to = line:match(Self.PATTERN_HEIRLOOM_LEVEL)
        return from and to and tonumber(attr == "fromLevel" and from or to) or nil
    -- attributes
    elseif attr == "attributes" then
        local match
        for _,a in pairs(Self.ATTRIBUTES) do
            match = line:match(Self["PATTERN_" .. Util.Select(a, LE_UNIT_STAT_STRENGTH, "STRENGTH", LE_UNIT_STAT_INTELLECT, "INTELLECT", "AGILITY")])
            if match then break end
        end

        if match then
            local attrs = Util.Tbl()
            for j=i,min(lines, i + 3) do
                line = _G[Addon.ABBR .."_HiddenTooltipTextLeft" .. j]:GetText()
                for _,a in pairs(Self.ATTRIBUTES) do
                    if not attrs[a] then
                        match = line:match(Self["PATTERN_" .. Util.Select(a, LE_UNIT_STAT_STRENGTH, "STRENGTH", LE_UNIT_STAT_INTELLECT, "INTELLECT", "AGILITY")])
                        attrs[a] = match and tonumber((match:gsub(",", ""):gsub("\\.", ""))) or nil
                    end
                end
            end
            return attrs
        end
    -- isTransmogKnown
    elseif attr == "isTransmogKnown" then
        if line:match(Self.PATTERN_APPEARANCE_KNOWN) or line:match(Self.PATTERN_APPEARANCE_UNKNOWN_ITEM) then
            return true
        elseif line:match(Self.PATTERN_APPEARANCE_UNKNOWN) then
            return false
        end
    end
end

function Self.GetInfo(item, attr, ...)
    local isInstance = type(item) == "table" and item.link and true
    local id = isInstance and item.id or tonumber(item)
    local link = isInstance and item.link or Self.IsLink(item) and item
    item = isInstance and item or link or id

    if not item then
        return
    -- id
    elseif attr == "id" and id then
        return id
    -- quality
    elseif attr == "quality" then
        local color = Self.GetInfo(item, "color")
        -- This is a workaround for epic item links having color "a335ee", but ITEM_QUALITY_COLORS has "a334ee"
        return color == "a335ee" and 4 or color and Util.TblFindWhere(ITEM_QUALITY_COLORS, "hex", "|cff" .. color) or 1
    -- level, baseLevel, realLevel
    elseif Util.In(attr, "level", "baseLevel") or attr == "realLevel" and not Self.IsScaled(item) then
        return (select(attr == "baseLevel" and 3 or 1, GetDetailedItemLevelInfo(link or id)))
    -- realMinLevel
    elseif attr == "realMinLevel" and not Self.IsScaled(item) then
        return (select(Self.INFO.basic.minLevel, GetItemInfo(link or id)))
    -- maxLevel
    elseif attr == "maxLevel" then
        if Self.GetInfo(item, "quality") == LE_ITEM_QUALITY_HEIRLOOM then
            return Self.GetInfo(Self.GetLinkForLevel(link, Self.GetInfo(item, "toLevel")), "level", ...)
        else
            return Self.GetInfo(item, "realLevel", ...)
        end
    -- isRelic
    elseif attr == "isRelic" then
        return Self.GetInfo(item, "subType") == "Artifact Relic"
    -- isEquippable
    elseif attr == "isEquippable" then
        return IsEquippableItem(link or id) or Self.GetInfo(item, "isRelic")
    -- From link
    elseif Self.INFO.link[attr] then
        if isInstance then
            return item:GetLinkInfo()[attr]
        else
            if type(Self.INFO.link[attr]) == "string" then
                return select(3, link:find(Self.INFO.link[attr]))
            else
                local info, i, numBonusIds, bonusIds = Self.INFO.link, 0, 1
                for v in link:gmatch(":(%-?%d*)") do
                    i = i + 1
                    if attr == "bonusIds" and i > info.numBonusIds then
                        if i > info.numBonusIds + numBonusIds then
                            return bonusIds
                        else
                            bonusIds = bonusIds or Util.Tbl()
                            tinsert(bonusIds, tonumber(v))
                        end
                    elseif i == info[attr] - 1 + numBonusIds then
                        return tonumber(v)
                    elseif i == info.numBonusIds then
                        numBonusIds = tonumber(v) or 0
                    end
                end
            end
        end
    -- From GetItemInfo()
    elseif Self.INFO.basic[attr] then
        if isInstance then
            return item:GetBasicInfo()[attr]
        else
            return (select(Self.INFO.basic[attr], GetItemInfo(link or id)))
        end
    -- From ScanTooltip()
    elseif Self.INFO.full[attr] then
        if isInstance then
            return item:GetFullInfo()[attr]
        else
            local val = Util.ScanTooltip(fullScanFn, link, nil, attr)
            return val
                or attr == "realLevel" and Self.GetInfo(item, "level")
                or attr == "realMinLevel" and Self.GetInfo(item, "minLevel")
                or val
        end
    end
end

-------------------------------------------------------
--                      Members                      --
-------------------------------------------------------

-- Get item info from a link
function Self:GetLinkInfo()
    if self.infoLevel < Self.INFO_LINK then
        local info = Self.INFO.link

        -- Extract string data
        for attr,p in pairs(info) do
            if type(p) == "string" then
                self[attr] = select(3, self.link:find(p))
            end
        end

        -- Extract int data
        local i, attr = 0
        for v in self.link:gmatch(":(%-?%d*)") do
            i = i + 1
   
            if info.bonusIds and Util.NumIn(i - info.numBonusIds, 1, self.numBonusIds or 0) then
                Util.TblSet(self, "bonusIds", i - info.numBonusIds, tonumber(v))
            else
                attr = Util.TblFind(info, i - 1 + (self.numBonusIds or 1))
                if attr then
                    self[attr] = tonumber(v)
                end
            end
        end
        
        -- Some extra infos TODO: This is a workaround for epic item links having color "a335ee", but ITEM_QUALITY_COLORS has "a334ee"
        self.quality = self.color == "a335ee" and 4 or self.color and Util.TblFindWhere(ITEM_QUALITY_COLORS, "hex", "|cff" .. self.color) or 1
        self.infoLevel = Self.INFO_LINK
    end

    return self, self.infoLevel >= Self.INFO_LINK
end

-- Get info from GetItemInfo()
function Self:GetBasicInfo()
    self:GetLinkInfo()
    
    if self.infoLevel == Self.INFO_LINK then
        local data = Util.Tbl(GetItemInfo(self.link))
        if next(data) then
            -- Get correct level
            local level, _, baseLevel = GetDetailedItemLevelInfo(self.link)

            -- Set data
            for attr,pos in pairs(Self.INFO.basic) do
                self[attr] = data[pos]
            end
            
            -- Some extra data
            self.level = level or self.level
            self.baseLevel = baseLevel or self.level
            self.isRelic = self.subType == "Artifact Relic"
            self.isEquippable = IsEquippableItem(self.link) or self.isRelic
            self.isSoulbound = self.bindType == LE_ITEM_BIND_ON_ACQUIRE or self.isEquipped and self.bindType == LE_ITEM_BIND_ON_EQUIP
            self.isTradable = Util.Default(self.isTradable, not self.isSoulbound or nil)
            self.infoLevel = Self.INFO_BASIC
        end
        Util.TblRelease(data)
    end

    return self, self.infoLevel >= Self.INFO_BASIC
end

-- Get extra info by scanning the tooltip
function Self:GetFullInfo()
    self:GetBasicInfo()

    if self.infoLevel == Self.INFO_BASIC and self.isEquippable then
        Util.ScanTooltip(function (i, line, lines)
            self.infoLevel = Self.INFO_FULL

            for attr in pairs(Self.INFO.full) do
                if self[attr] == nil then
                    self[attr] = fullScanFn(i, line, lines, attr)
                end
            end
        end, self.link)

        -- Effective and max level
        self.realLevel = self.realLevel or self.level
        self.maxLevel = self.quality == LE_ITEM_QUALITY_HEIRLOOM and Self.GetInfo(Self.GetLinkForLevel(self.link, self.toLevel), "level") or self.realLevel
    end

    return self, self.infoLevel >= Self.INFO_FULL
end

-------------------- LOADING --------------------

-- Check if item data is loaded
function Self:IsLoaded()
    return self:GetBasicInfo().infoLevel >= Self.INFO_BASIC
end

-- Run a function when item data is loaded
function Self:OnLoaded(fn, ...)
    local args, try = {...}
    try = function (n)
        if self:IsLoaded() then
            fn(unpack(args))
        elseif n > 0 then
            Addon:ScheduleTimer(try, 0.1, n-1)
        end
    end
    try(10)
end

-------------------- HELPER --------------------

-- Get the real (unscaled) item level
function Self:GetRealLevel()
    return Self.IsScalingActive(self.owner) and self:GetFullInfo().effectiveLevel or self:GetBasicInfo().level
end

-- Check if the item should get special treatment for being a weapon
function Self:IsWeapon()
    return Util.In(self:GetBasicInfo().equipLoc, Self.TYPES_WEAPON)
end

-- Check if the item is a Legion legendary
function Self:IsLegionLegendary()
    return Self.GetInfo(self, "expacId") == Self.EXPAC_LEGION and Self.GetInfo(self, "quality") == LE_ITEM_QUALITY_LEGENDARY
end

-- Check if the item is a Legion artifact
function Self:IsLegionArtifact()
    return Self.GetInfo(self, "expacId") == Self.EXPAC_LEGION and Self.GetInfo(self, "quality") == LE_ITEM_QUALITY_ARTIFACT
end

-- Check if the item has azerite traits
function Self:IsAzeriteGear()
    return self:GetBasicInfo().expacId == Self.EXPAC_BFA and self.quality >= LE_ITEM_QUALITY_RARE and Util.In(self.equipLoc, Self.TYPE_HEAD, Self.TYPE_SHOULDER, Self.TYPE_CHEST, Self.TYPE_ROBE)
end
