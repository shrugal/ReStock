local Name, Addon = ...
local Version = GetAddOnMetadata(Name, "Version")
LibStub("AceAddon-3.0"):NewAddon(Addon, Name, "AceConsole-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

-- Constants
Addon.ABBR = "RS"
Addon.VERSION = tonumber(Version) or Version
Addon.DEBUG = false

-- Core
Addon.Options = {}

-- Models
Addon.Models = {
    Recipe = {},
    Item = {}
}

-- Util
Addon.Comm = {}
Addon.Unit = {}
Addon.Util = {}

-- Modules
Addon.Convert = Addon:NewModule("Convert", nil, "AceEvent-3.0", "AceHook-3.0")
Addon.Price = Addon:NewModule("Price", nil, "AceEvent-3.0", "AceHook-3.0")
Addon.Store = Addon:NewModule("Store", nil, "AceEvent-3.0", "AceHook-3.0")

-- GUI
Addon.GUI = {
    Main = {},
    Tooltip = Addon:NewModule("Tooltip", nil, "AceHook-3.0")
}

-- Data
Addon.Data = {
    Conversions = {},
    Crafts = {}
}

-- TODO: DEBUG
RS = Addon