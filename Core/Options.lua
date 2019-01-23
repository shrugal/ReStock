local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local C = LibStub("AceConfig-3.0")
local CD = LibStub("AceConfigDialog-3.0")
local CR = LibStub("AceConfigRegistry-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")
local GUI, Unit, Util = Addon.GUI, Addon.Unit, Addon.Util
local Self = Addon.Options

Self.WIDTH_FULL = "full"
Self.WIDTH_HALF = 1.7
Self.WIDTH_THIRD = 1.1
Self.WIDTH_QUARTER = 0.85

Self.it = Util.Iter()
Self.registered = false
Self.frames = {}

-- Register options
function Self.Register()
    Self.registered = true

    -- General
    C:RegisterOptionsTable(Name, Self.RegisterGeneral)
    Self.frames.General = CD:AddToBlizOptions(Name)
end

-- Show the options panel
function Self.Show(name)
    local panel = Self.frames[name or "General"]

    -- Have to call it twice because of a blizzard UI bug
    InterfaceOptionsFrame_OpenToCategory(panel)
    InterfaceOptionsFrame_OpenToCategory(panel)
end

-------------------------------------------------------
--                      General                      --
-------------------------------------------------------

function Self.RegisterGeneral()
    local it = Self.it

    return {
        type = "group",
        args = {
            info = {
                type = "description",
                fontSize = "medium",
                order = it(),
                name = L["OPT_VERSION"]:format(Addon.VERSION) .. "  |cff999999-|r  " .. L["OPT_AUTHOR"] .. "  |cff999999-|r  " .. L["OPT_TRANSLATION"] .. "\n"
            },
            enable = {
                name = L["OPT_ENABLE"],
                desc = L["OPT_ENABLE_DESC"],
                type = "toggle",
                order = it(),
                set = function (_, val)
                    Addon.db.profile.enabled = val
                    Addon:OnTrackingChanged(true)
                    Addon:Info(L[val and "ENABLED" or "DISABLED"])
                end,
                get = function (_) return Addon.db.profile.enabled end,
                width = Self.WIDTH_HALF
            }
        }
    }
end

-------------------------------------------------------
--                    Migration                      --
-------------------------------------------------------

-- Migrate options from an older version to the current one
function Self.Migrate()
    local p, f, c = Addon.db.profile, Addon.db.factionrealm, Addon.db.char

    -- Profile
    if p then
        if p.version then end
        p.version = 1
    end

    -- Factionrealm
    if f then
        if f.version then end
        f.version = 1
    end
    
    -- Char
    if c then
        if c.version then end
        c.version = 1
    end
end

-- Migrate a single option
function Self.MigrateOption(key, source, dest, depth, destKey, filter, keep)
    if source then
        depth = type(depth) == "number" and depth or depth and 10 or 0
        destKey = destKey or key
        local val = source[key]

        if type(val) == "table" and depth > 0 then
            for i,v in pairs(val) do
                local filterType = type(filter)
                if not filter or filterType == "table" and Util.In(i, filter) or filterType == "string" and i:match(filter) or filterType == "function" and filter(i, v, depth) then
                    dest[destKey] = dest[destKey] or {}
                    Self.MigrateOption(i, val, dest[destKey], depth - 1)
                end
            end
        else
            dest[destKey] = Util.Default(val, dest[destKey])
        end

        if not keep then
            source[key] = nil
        end
    end
end

-------------------------------------------------------
--                   Minimap Icon                    --
-------------------------------------------------------

function Self.RegisterMinimapIcon()
    local plugin = LDB:NewDataObject(Name, {
        type = "data source",
        text = Name,
        icon = "Interface\\GossipFrame\\VendorGossipIcon"
    })

    -- OnClick
    plugin.OnClick = function (_, btn)
        if btn == "RightButton" then
            Self.Show()
        else
            GUI.Main.Toggle()
        end
    end

    -- OnTooltip
    plugin.OnTooltipShow = function (ToolTip)
        ToolTip:AddLine(Name)
        ToolTip:AddLine(L["TIP_MINIMAP_ICON"], 1, 1, 1)
    end

    -- Icon
    if not ReStockIconDB then ReStockIconDB = {} end
    LDBIcon:Register(Name, plugin, ReStockIconDB)
end

-------------------------------------------------------
--                      Helper                       --
-------------------------------------------------------