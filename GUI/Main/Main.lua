local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local AceGUI = LibStub("AceGUI-3.0")
local GUI, Options, Store, Util = Addon.GUI, Addon.Options, Addon.Store, Addon.Util
local Self = GUI.Main

Self.TAB_OPERATIONS = "Operations"
Self.TAB_ITEMS = "Items"
Self.TAB_CHARACTERS = "Characters"
Self.TABS = {Self.TAB_OPERATIONS, Self.TAB_ITEMS, Self.TAB_CHARACTERS}

Self.frames = {}
Self.status = {width = 700, height = 300}
Self.tab = nil

-------------------------------------------------------
--                     Show/Hide                     --
-------------------------------------------------------

-- Show the frame
function Self.Show(tab)

    -- WINDOW

    if not Self.frames.window then
        -- Window
        local window = GUI("Window")
            .SetLayout(nil)
            .SetFrameStrata("MEDIUM")
            .SetTitle(Name)
            .SetCallback("OnClose", function (self)
                Self.status.width = self.frame:GetWidth()
                Self.status.height = self.frame:GetHeight()
                self.optionsBtn, self.versionBtn = nil, nil
                self:Release()
                wipe(Self.frames)
            end)
            .SetMinResize(550, 200)
            .SetStatusTable(Self.status)()

        Self.frames.window = window

        -- Options button
        local f = GUI("Icon")
            .SetImage("Interface\\Buttons\\UI-OptionsButton")
            .SetImageSize(14, 14).SetHeight(16).SetWidth(16)
            .SetCallback("OnClick", function (self)
                Options.Show()
                GameTooltip:Hide()
            end)
            .SetCallback("OnEnter", GUI.TooltipText)
            .SetCallback("OnLeave", GUI.TooltipHide)
            .SetUserData("text", OPTIONS)
            .AddTo(window)()
        f.OnRelease = GUI.ResetIcon
        f.image:SetPoint("TOP", 0, -1)
        f.frame:SetParent(window.frame)
        f.frame:SetPoint("TOPRIGHT", window.closebutton, "TOPLEFT", -8, -8)
        f.frame:SetFrameStrata("HIGH")
        f.frame:Show()
        
        window.optionsBtn = f

        -- Version label
        f = GUI("Label")
            .SetText("v" .. Addon.VERSION)
            .SetColor(1, 0.82, 0)
            .AddTo(window)()
        f.OnRelease = GUI.ResetLabel
        f.frame:SetParent(window.frame)
        f.frame:SetPoint("RIGHT", window.optionsBtn.frame, "LEFT", -15, -1)
        f.frame:SetFrameStrata("HIGH")
        f.frame:Show()

        window.versionBtn = f

        -- Tabs
        local tabs = GUI("InlineGroup")
            .SetLayout("LIST")
            .AddTo(window)
            .SetPoint("TOPLEFT")
            .SetPoint("BOTTOMLEFT")
            .SetWidth(42)()
        tabs.frame:GetChildren():SetPoint("TOPLEFT", 0, 0)
        GUI(tabs.content)
            .SetPoint("TOPLEFT", 3, -3)
            .SetPoint("BOTTOMRIGHT", -3, 3)
        tabs.OnRelease = GUI.ResetInlineGroup

        Self.frames.tabs = tabs

        for i,tab in ipairs(Self.TABS) do
            local tex = Util.Select(tab,
                Self.TAB_OPERATIONS, "INV_Eng_GearspringParts",
                Self.TAB_ITEMS, "INV_Misc_PaperPackage01b",
                Self.TAB_CHARACTERS, "Ability_Mage_MassInvisibility"
            )

            local f = GUI.CreateIconButton("Interface\\ICONS\\" .. tex, tabs, function () Self.Show(tab) end, L["TAB_" .. tab:upper()], 35, 35)
            f:SetUserData("anchor", "ANCHOR_CURSOR")
        end

        -- Main
        local main = GUI("SimpleGroup")
            .SetLayout(nil)
            .AddTo(window)
            .SetPoint("TOPLEFT", tabs.frame, "TOPRIGHT")
            .SetPoint("BOTTOMRIGHT")()

        Self.frames.main = main

        tab = tab or Self.TAB_OPERATIONS
    end
    
    Self.frames.window.frame:Show()

    -- TAB

    if tab ~= Self.tab then
        if Self.tab and Self[Self.tab] then
            Self[Self.tab].Hide()
        end

        Self.tab = tab
        if Self[tab] then
            Self[tab].Show()
        end
    end
end

-- Check if the frame is currently being shown
function Self.IsShown()
    return Self.frames.window and Self.frames.window.frame:IsShown()
end

-- Hide the frame
function Self.Hide()
    if Self:IsShown() then Self.frames.window.frame:Hide() end
end

-- Toggle the frame
function Self.Toggle()
    if Self:IsShown() then Self.Hide() else Self.Show() end
end