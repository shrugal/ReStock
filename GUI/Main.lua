local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local AceGUI = LibStub("AceGUI-3.0")
local GUI, Options, Unit, Util = Addon.GUI, Addon.Options, Addon.Unit, Addon.Util
local Self = GUI.Main

Self.TAB_OPERATIONS = "OPERATIONS"
Self.TAB_ITEMS = "ITEMS"
Self.TAB_CHARACTERS = "CHARACTERS"
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
        local tabs = GUI("SimpleGroup")
            .SetLayout("Flow")
            .AddTo(window)
            .SetPoint("TOPLEFT")
            .SetPoint("TOPRIGHT")()

        Self.frames.tabs = tabs

        for i,tab in ipairs(Self.TABS) do
            f = GUI("InteractiveLabel")
                .SetText(L["TAB_" .. tab])
                .AddTo(tabs)
                .SetCallback("OnClick", function () Self.Show(tab) end)()
        end

        -- Main
        local main = GUI("SimpleGroup")
            .SetLayout(nil)
            .AddTo(window)
            .SetPoint("TOPLEFT", tabs, "BOTTOMLEFT")
            .SetPoint("BOTTOMRIGHT")

        Self.frames.main = main

        tab = tab or Self.TAB_OPERATIONS
    else
        Self.frames.window.frame:Show()
    end

    -- TAB

    if not tab or Self.tab == tab then
        return
    elseif Self.tab then
        Self.frames.main:ReleaseChildren()
    end

    Self.tab = tab
    Self["RenderTab" .. Util.StrUcFirst(tab:lower())]()
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

function Self.RenderTabOperations()

end

function Self.RenderTabItems()

end

function Self.RenderTabCharacters()

end