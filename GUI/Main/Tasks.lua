local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local AceGUI = LibStub("AceGUI-3.0")
local GUI, Models, Options, Store, Util = Addon.GUI, Addon.Models, Addon.Options, Addon.Store, Addon.Util
local Self = GUI.Main.Tasks

Self.frames = {}

-------------------------------------------------------
--                     Show/Hide                     --
-------------------------------------------------------

-- Show the frame
function Self.Show()
    if not Self.frames.container then
        Self.frames.container = GUI("SimpleGroup")
            .SetParent(GUI.Main.frames.main)
            .SetAllPoints()
            .SetLayout(nil)()

        Self.Update()
    end

    Self.frames.container.frame:Show()
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
    local parent = Self.frames.container
    local detailsWidth = 300
    local header = Util.Tbl("ID", "ITEMS", "CHARACTER", "LOCATION", "AMOUNT")

    local children = parent.children
    local list, details = unpack(children)

    if #children == 0 then
        local title, btn

        -- List title
        title = GUI("Label")
            .SetFontObject(GameFontNormalLarge)
            .SetText(L["TASKS"])
            .AddTo(parent)
            .SetPoint("TOPLEFT", 3, -3)()

        -- List buttons
        btn = GUI("Button")
            .SetAutoWidth(true)
            .SetText("-")
            .AddTo(parent)
            .SetPoint("TOPRIGHT", -detailsWidth, 1, 0)
            .SetCallback("OnClick", Self.OnRemoveClick)()
        btn = GUI("Button")
            .SetAutoWidth(true)
            .SetText("+")
            .AddTo(parent)
            .SetPoint("TOPRIGHT", btn.frame, "TOPLEFT", -2, 0)
            .SetCallback("OnClick", Self.OnAddClick)()

        -- List
        list = GUI("ScrollFrame")
            .SetLayout("RS_Table")
            .SetUserData("table", {
                space = 10,
                columns = {20, 1, 1, 1, {25, 100}}
            })
            .AddTo(parent)
            .SetPoint("TOPLEFT", title.frame, "BOTTOMLEFT", 0, -5)
            .SetPoint("BOTTOMRIGHT", -detailsWidth, 0)
            .PauseLayout()()

        -- List header
        for i,v in ipairs(header) do
            GUI("Label").SetFontObject(GameFontNormal).SetText(L[v]).SetColor(1, 0.82, 0).AddTo(list)
        end

        -- Details title
        title = GUI("Label")
            .SetFontObject(GameFontNormalLarge)
            .SetText(L["DETAILS"])
            .AddTo(parent)
            .SetPoint("TOPLEFT", parent.frame, "TOPRIGHT", -detailsWidth + 5, -3)()

        -- Details
        details = GUI("ScrollFrame")
            .SetLayout("Flow")
            .AddTo(parent)
            .SetPoint("TOPLEFT", title.frame, "BOTTOMLEFT")
            .SetPoint("BOTTOMRIGHT")()
    else
        list:PauseLayout()
    end

    -- LIST

    local it = Util.Iter(#header + 1)
    local ops = Store.GetFaction(Store.CAT_TASK)
    local items = ops and Util(ops).Copy().List()()

    if not items or #items == 0 then
        -- TODO
    else
        for i,item in ipairs(items) do
            if not children[it(0) + 1] then
                -- ID
                GUI("Label").SetFontObject(GameFontNormal).AddTo(list)()
            
                -- Items
                GUI.CreateItemLabel(list, "ANCHOR_RIGHT")
                
                -- Character
                GUI("Label").SetFontObject(GameFontNormal).AddTo(list)()

                -- Location
                GUI("Label").SetFontObject(GameFontNormal).AddTo(list)()

                -- Amount
                GUI("Label").SetFontObject(GameFontNormal).AddTo(list)()
            end

            -- ID
            GUI(children[it()]).SetText(item.id).Show()

            -- Items
            GUI(children[it()])
                .SetImage(roll.item.texture)
                .SetText(roll.item.link)
                .SetUserData("link", roll.item.link)
                .Show()

            -- Character
            GUI(children[it()]).SetText(item.char).Show()

            -- Location
            GUI(children[it()]).SetText(item.loc).Show()

            -- Amount
            GUI(children[it()]).SetText(item.amount).Show()
        end
    end

    -- Release the rest
    while children[it()] do
        children[it(0)]:Release()
        children[it(0)] = nil
    end

    -- Cleanup and layout
    Util.TblRelease(items, header)
    list:ResumeLayout()
    list:DoLayout()
end

function Self.OnAddClick(frame)
    print("ADD")
end

function Self.OnRemoveClick(frame)
    print("REMOVE")
end