local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local AceGUI = LibStub("AceGUI-3.0")
local GUI, Models, Options, Store, Util = Addon.GUI, Addon.Models, Addon.Options, Addon.Store, Addon.Util
local Self = GUI.Main.Tasks

Self.COLOR_SELECTED = {1, 1, 1, .5}
Self.COLOR_CHECKED = {1, 1, 1, .2}

Self.frames = {}
Self.checked = {}
Self.selected = nil
Self.tasks = Util.Tbl()

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
    local header = Util.Tbl("", "ITEMS", "CHARACTER", "LOCATION", "AMOUNT")

    local list, details = Self.frames.list, Self.frames.details
    if #parent.children == 0 then
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
            .SetCallback("OnRowClick", function (self, _, row, btn)
                local task = Self.tasks[row]
                if task and btn == "LeftButton" then
                    Self.Select(task)
                end
            end)
            .PauseLayout()()
        GUI.TableRowBackground(list, Self.ListRowBackground, #header)
        GUI.TableRowHighlight(list, #header)
        GUI.TableRowClick(list, #header)

        Self.frames.list = list

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

        Self.frames.details = details
    else
        list:PauseLayout()
    end

    -- LIST

    local children = list.children
    local it = Util.Iter(#header)

    Util.TblRelease(Self.tasks)
    Self.tasks = Models.Task:Query().List()()

    if not Self.tasks or #Self.tasks == 0 then
        -- TODO
    else
        for i,task in ipairs(Self.tasks) do
            if not children[it(0) + 1] then
                -- Checkbox
                local cb = GUI("CheckBox")
                    .SetWidth(14).SetHeight(14)
                    .SetCallback("OnValueChanged", function (self)
                        local id = self:GetUserData("id")
                        if id then
                            Self.checked[id] = self:GetValue() and true or nil
                            list:UpdateRowBackgrounds()
                        end
                    end)
                    .AddTo(list)()
                cb.checkbg:SetSize(14, 14)
                cb.checkbg:SetPoint("TOPLEFT", 2, 0)
                cb.checkbg:SetTexCoord(0.15, 0.85, 0.15, 0.85)
                cb.check:SetTexCoord(0.15, 0.85, 0.15, 0.85)
                cb.OnRelease = GUI.ResetCheckBox
            
                -- Item
                GUI.CreateItemLabel(list, "ANCHOR_RIGHT")
                
                -- Character
                GUI("Label").SetFontObject(GameFontNormal).AddTo(list)

                -- Location
                GUI("Label").SetFontObject(GameFontNormal).AddTo(list)

                -- Amount
                GUI("Label").SetFontObject(GameFontNormal).AddTo(list)
            end

            -- Checkbox
            GUI(children[it()])
                .SetValue(Self.checked[task.id])
                .SetUserData("id", task.id)
                .Show()

            -- Item
            GUI(children[it()])
                .SetImage(task.item and task.item.texture or "")
                .SetText(task.item and task.item.link or "-")
                .SetUserData("link", task.item and task.item.link or nil)
                .Show()

            -- Character
            GUI(children[it()]).SetText(task.char).Show()

            -- Location
            GUI(children[it()]).SetText(task.loc).Show()

            -- Amount
            GUI(children[it()]).SetText(task.amount).Show()
        end
    end

    -- Release the rest
    while children[it()] do
        children[it(0)]:Release()
        children[it(0)] = nil
    end

    -- Cleanup and layout
    Util.TblRelease(header)
    list:ResumeLayout()
    list:DoLayout()
end

function Self.Select(task)
    task = Models.Task:Decode(task)
    if not task then return end

    Self.selected = task.id

    if Self.frames.list then
        Self.frames.list:UpdateRowBackgrounds()
    end
end

function Self.ListRowBackground(self, row)
    local task = Self.tasks[row]
    return task and (
        task.id == Self.selected and Self.COLOR_SELECTED
        or Self.checked[task.id] and Self.COLOR_CHECKED
    )
end

function Self.OnAddClick(frame)
    Models.Task():Store()
    Self.Update()
end

function Self.OnRemoveClick(frame)
    for id in pairs(Self.checked) do
        local task = Models.Task:Fetch(id)
        if task then
            task:Remove():Release()
        end
    end
    wipe(Self.checked)
    Self.Update()
end