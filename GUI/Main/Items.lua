local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local AceGUI = LibStub("AceGUI-3.0")
local GUI, Options, Store, Util = Addon.GUI, Addon.Options, Addon.Store, Addon.Util
local Self = GUI.Main.Items

Self.frames = {}

-------------------------------------------------------
--                     Show/Hide                     --
-------------------------------------------------------

-- Show the frame
function Self.Show()
end

-- Check if the frame is currently being shown
function Self.IsShown()
    return Self.frames.container and Self.frames.container.frame:IsShown()
end

-- Hide the frame
function Self.Hide()
    if Self.IsShown() then Self.frames.container.frame:Hide() end
end

-- Toggle the frame
function Self.Toggle()
    if Self.IsShown() then Self.Hide() else Self.Show() end
end

-------------------------------------------------------
--                       Update                      --
-------------------------------------------------------

function Self.Update()
    -- TODO
end