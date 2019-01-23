local Name, Addon = ...
local Version = GetAddOnMetadata(Name, "Version")
LibStub("AceAddon-3.0"):NewAddon(Addon, Name, "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

-- Constants
Addon.ABBR = "RS"
Addon.VERSION = tonumber(Version) or Version
Addon.DEBUG = false

-- Import function
function Addon:Import(...)
    local t = Addon.Util.Tbl(...)
    for i,v in pairs(t) do t[i] = Addon.Util.TblGet(self, v) end
    return Addon.Util.TblReleaseReturn(t, unpack(t))
end

-- Core
Addon.Options = {}
Addon.Price = {}
Addon.Store = {}

-- Models
Addon.Models = {
    Model = {},
    Group = {},
    Item = {},
    Operation = {},
    Recipe = {},
    Task = {},
}

-- Util
Addon.Comm = {}
Addon.Unit = {}
Addon.Util = {}

-- Modules
Addon.Auction = Addon:NewModule("Auction", nil, "AceEvent-3.0", "AceHook-3.0")
Addon.Convert = Addon:NewModule("Convert", nil, "AceEvent-3.0", "AceHook-3.0")
Addon.Craft = Addon:NewModule("Craft", nil, "AceEvent-3.0", "AceHook-3.0")
Addon.Inventory = Addon:NewModule("Inventory", nil, "AceEvent-3.0", "AceHook-3.0")
Addon.Mail = Addon:NewModule("Mail", nil, "AceEvent-3.0", "AceHook-3.0")
Addon.Store = Addon:NewModule("Store", nil, "AceEvent-3.0", "AceHook-3.0")

-- GUI
Addon.GUI = {
    Main = {
        Tasks = Addon:NewModule("Tasks"),
        Items = Addon:NewModule("Items"),
        Characters = Addon:NewModule("Characters"),
    },
    Tooltip = Addon:NewModule("Tooltip", nil, "AceHook-3.0")
}

-- Data
Addon.Data = {
    Conversions = {},
    Crafts = {}
}

-- TODO: DEBUG
RS = Addon