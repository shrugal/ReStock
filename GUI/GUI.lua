local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local AceGUI = LibStub("AceGUI-3.0")
local Unit, Util = Addon.Unit, Addon.Util
local Self = Addon.GUI

-- Row highlight frame
Self.HIGHLIGHT = CreateFrame("Frame", nil, UIParent)
Self.HIGHLIGHT:SetFrameStrata("BACKGROUND")
Self.HIGHLIGHT:Hide()
local tex = Self.HIGHLIGHT:CreateTexture(nil, "BACKGROUND")
tex:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight")
tex:SetVertexColor(1, 1, 1, .5)
tex:SetAllPoints(Self.HIGHLIGHT)

-- Row backgrounds
Self.ROW_BACKGROUND_DEFAULT = {1, 1, 1, .5}

-------------------------------------------------------
--                  Popup dialogs                    --
-------------------------------------------------------

-------------------------------------------------------
--                     Dropdowns                     --
-------------------------------------------------------

-------------------------------------------------------
--                      Helper                       --
-------------------------------------------------------

function Self.ReverseAnchor(anchor)
    return anchor:gsub("TOP", "B-OTTOM"):gsub("BOTTOM", "T-OP"):gsub("LEFT", "R-IGHT"):gsub("RIGHT", "L-EFT"):gsub("-", "")
end

-- Create an interactive label for a unit, with tooltip, unitmenu and whispering on click
function Self.CreateUnitLabel(parent, baseTooltip)
    return Self("InteractiveLabel")
        .SetFontObject(GameFontNormal)
        .SetCallback("OnEnter", baseTooltip and Self.TooltipUnit or Self.TooltipUnitFullName)
        .SetCallback("OnLeave", Self.TooltipHide)
        .SetCallback("OnClick", Self.UnitClick)
        .AddTo(parent)
end

-- Create an interactive label for an item, with tooltip and click support
function Self.CreateItemLabel(parent, anchor)
    local f = Self("InteractiveLabel")
        .SetFontObject(GameFontNormal)
        .SetCallback("OnEnter", Self.TooltipItemLink)
        .SetCallback("OnLeave", Self.TooltipHide)
        .SetCallback("OnClick", Self.ItemClick)
        .AddTo(parent)()

    -- Fix the stupid label anchors
    local methods = Util.TblCopySelect(f, "OnWidthSet", "SetText", "SetImage", "SetImageSize")
    for name,fn in pairs(methods) do
        f[name] = function (self, ...)
            fn(self, ...)

            if self.imageshown then
                local width, imagewidth = self.frame.width or self.frame:GetWidth() or 0, self.image:GetWidth()
                
                self.label:ClearAllPoints()
                self.image:ClearAllPoints()
                
                self.image:SetPoint("TOPLEFT")
                if self.image:GetHeight() > self.label:GetHeight() then
                    self.label:SetPoint("LEFT", self.image, "RIGHT", 4, 0)
                else
                    self.label:SetPoint("TOPLEFT", self.image, "TOPRIGHT", 4, 0)
                end
                self.label:SetWidth(width - imagewidth - 4)
                
                local height = max(self.image:GetHeight(), self.label:GetHeight())
                self.resizing = true
                self.frame:SetHeight(height)
                self.frame:SetWidth(Util.NumRound(self.frame:GetWidth()), 1)
                self.frame.height = height
                self.resizing = nil
            end
        end
    end
    f.OnRelease = function (self)
        for name,fn in pairs(methods) do f[name] = fn end
        Util.TblRelease(methods)
        f.OnRelease = nil
    end

    return f
end

-- Create an icon button
function Self.CreateIconButton(icon, parent, onClick, desc, width, height)
    f = Self("Icon")
        .SetImage(icon:sub(1, 9) == "Interface" and icon or "Interface\\Buttons\\" .. icon .. "-Up")
        .SetImageSize(width or 16, height or 16).SetHeight(height or 16).SetWidth(width or 16)
        .SetCallback("OnClick", function (...) onClick(...) GameTooltip:Hide() end)
        .SetCallback("OnEnter", Self.TooltipText)
        .SetCallback("OnLeave", Self.TooltipHide)
        .SetUserData("text", desc)
        .AddTo(parent)
        .Show()()
    f.image:SetPoint("TOP")
    f.OnRelease = Self.ResetIcon

    return f
end

-- Arrange visible icon buttons
function Self.ArrangeIconButtons(parent, margin, xOff, yOff)
    margin = margin or 4
    local n, width, prev = 0, 0

    for i=#parent.children,1,-1 do
        local child = parent.children[i]
        if child:IsShown() then
            if not prev then
                child.frame:SetPoint("TOPRIGHT", xOff or 0, yOff or 0)
            else
                child.frame:SetPoint("TOPRIGHT", prev.frame, "TOPLEFT", -margin, 0)
            end
            n, prev, width = n + 1, child, width + child.frame:GetWidth()
        end
    end

    Self(parent).SetWidth(max(0, width + (n-1) * margin)).Show()
end

-- Display the given text as tooltip
function Self.TooltipText(self)
    local text = self:GetUserData("text")
    local anchor = self:GetUserData("anchor") or "ANCHOR_TOP"
    if text then
        GameTooltip:SetOwner(self.frame, anchor)
        GameTooltip:SetText(text)
        GameTooltip:Show()
    end
end

-- Display a regular unit tooltip
function Self.TooltipUnit(self)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:SetUnit(self:GetUserData("unit"))
    GameTooltip:Show()
end

-- Display a tooltip showing only the full name of an x-realm player
function Self.TooltipUnitFullName(self)
    local unit = self:GetUserData("unit")
    if unit and Unit.Realm(unit) ~= Unit.RealmName() then
        local c = Unit.Color(unit)
        GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
        GameTooltip:SetText(Unit.FullName(unit), c.r, c.g, c.b, false)
        GameTooltip:Show()
    end
end

-- Display a tooltip for an item link
function Self.TooltipItemLink(self)
    local link = self:GetUserData("link")
    if link then
        GameTooltip:SetOwner(self.frame, self:GetUserData("anchor") or "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    end
end

function Self.TooltipChat(self)
    local chat = self:GetUserData("roll").chat
    local anchor = chat and self:GetUserData("anchor") or "TOP"

    GameTooltip:SetOwner(self.frame, "ANCHOR_" .. anchor)
    GameTooltip:SetText(WHISPER)
    if chat then for i,line in ipairs(chat) do
        GameTooltip:AddLine(line, 1, 1, 1, true)
    end end
    GameTooltip:Show()
end

-- Hide the tooltip
function Self.TooltipHide()
    GameTooltip:Hide()
end

-- Handle clicks on unit labels
function Self.UnitClick(self, event, button)
    local unit = self:GetUserData("unit")
    if unit then
        if button == "LeftButton" then
            ChatFrame_SendTell(unit)
        elseif button == "RightButton" then
            -- local dropDown = Self.DROPDOWN_UNIT
            -- dropDown.which = Unit.IsSelf(unit) and "SELF" or UnitInRaid(unit) and "RAID_PLAYER" or UnitInParty(unit) and "PARTY" or "PLAYER"
            -- dropDown.unit = unit
            -- ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)
        end
    end
end

-- Handle clicks on item labels/icons
function Self.ItemClick(self)
    if IsModifiedClick("DRESSUP") then
        return DressUpItemLink(self:GetUserData("link"))
    elseif IsModifiedClick("CHATLINK") then
        return ChatEdit_InsertLink(self:GetUserData("link"))
    end
end

function Self.ResetIcon(self)
    self.image:SetPoint("TOP", 0, -5)
    self.frame:SetFrameStrata("MEDIUM")
    self.frame:RegisterForClicks("LeftButtonUp")
    self.OnRelease = nil
end

function Self.ResetLabel(self)
    self.label:SetPoint("TOPLEFT")
    self.frame:SetFrameStrata("MEDIUM")
    self.frame:SetScript("OnUpdate", nil)
    self.OnRelease = nil
end

function Self.ResetInlineGroup(self)
    self.frame:GetChildren():SetPoint("TOPLEFT", 0, -17)
    self.content:SetPoint("TOPLEFT", 10, -10)
    self.content:SetPoint("BOTTOMRIGHT", -10, 10)
    self.OnRelease = nil
end

function Self.ResetCheckBox(self)
    self.checkbg:SetSize(24, 24)
    self.checkbg:SetPoint("TOPLEFT")
    self.checkbg:SetTexCoord(0, 1, 0, 1)
    self.check:SetTexCoord(0, 1, 0, 1)
    self.OnRelease = nil
end

function Self.ShowExportWindow(title, text)
    local f = Self("Frame").SetLayout("Fill").SetTitle(Name .. " - " .. title).Show()()
    Self("MultiLineEditBox").DisableButton(true).SetLabel().SetText(text).AddTo(f)
    return f
end

-- Add row-highlighting to a table
function Self.TableRowHighlight(parent, skip)
    skip = skip or 0
    local isOver = false
    local tblObj = parent:GetUserData("table")
    local spaceV = tblObj.spaceV or tblObj.space or 0

    parent.frame:SetScript("OnEnter", function (self)
        if not isOver then
            self:SetScript("OnUpdate", function (self)
                if not MouseIsOver(self) then
                    isOver = false
                    self:SetScript("OnUpdate", nil)
                    
                    if Self.HIGHLIGHT:GetParent() == self then
                        Self.HIGHLIGHT:SetParent(UIParent)
                        Self.HIGHLIGHT:Hide()
                    end
                else
                    local cY = select(2, GetCursorPosition()) / UIParent:GetEffectiveScale()
                    local frameTop, frameBottom = parent.frame:GetTop(), parent.frame:GetBottom()
                    local top, bottom

                    for i=skip+1,#parent.children do
                        local childTop, childBottom = parent.children[i].frame:GetTop(), parent.children[i].frame:GetBottom()
                        if childTop and childBottom and childTop + spaceV/2 >= cY and childBottom - spaceV/2 <= cY then
                            top =  min(frameTop, max(top or 0, childTop + spaceV/2))
                            bottom = max(frameBottom, min(bottom or frameTop, childBottom - spaceV/2))
                        end
                    end
                    
                    if top and bottom then
                        Self(Self.HIGHLIGHT)
                            .SetParent(self)
                            .SetPoint("LEFT").SetPoint("RIGHT")
                            .SetPoint("TOP", 0, top - frameTop)
                            .SetHeight(top - bottom)
                            .Show()
                    else
                        Self.HIGHLIGHT:Hide()
                    end
                end
            end)
        end
        isOver = true
    end)

    local OnRelease = parent.OnRelease
    parent.OnRelease = function (self, ...)
        self.frame:SetScript("OnEnter", nil)
        self.frame:SetScript("OnUpdate", nil)
        self.OnRelease = OnRelease
        if OnRelease then OnRelease(self, ...) end
    end
end

-- Add row-backgrounds to a table
function Self.TableRowBackground(parent, colors, skip)
    colors = colors or Self.ROW_BACKGROUND_DEFAULT
    skip = skip or 0
    local tblObj = parent:GetUserData("table")
    local spaceV = tblObj.spaceV or tblObj.space or 0
    local textures = Util.Tbl()

    parent.UpdateRowBackgrounds = function (self)
        Util.TblCall(textures, "Hide")

        local frameTop, frameBottom = parent.frame:GetTop(), parent.frame:GetBottom()
        local cols, tex, row, top, bottom, last, child, childTop, childBottom, color = 0, 1

        for i=skip + 1, #parent.children + 1 do
            child = parent.children[i]
            last = i == #parent.children + 1

            if child then
                childTop, childBottom = child.frame:GetTop(), child.frame:GetBottom()
            end

            if row and last or child and child:IsShown() and childTop and childBottom then
                if row and (last or childTop < bottom) then
                    -- Determine color
                    if type(colors) == "function" then
                        color = colors(parent, row, cols, top - frameTop, top - bottom)
                    elseif type(colors) == "table" and type(colors[1]) ~= "number" then
                        color = colors[row % #colors]
                    else
                        color = colors
                    end

                    if color then
                        textures[tex] = textures[tex] or parent.content:CreateTexture(nil, "BACKGROUND")
                        Self(textures[tex])
                            .SetPoint("LEFT")
                            .SetPoint("RIGHT")
                            .SetPoint("TOP", 0, top - frameTop)
                            .SetHeight(top - bottom)
                            .SetColorTexture(unpack(color == true and Self.ROW_BACKGROUND_DEFAULT or color))
                            .Show()
                        tex = tex + 1
                    end

                    row, cols, top, bottom = row + 1, 0
                end

                if not last then
                    row = row or 1
                    cols = cols + 1
                    top =  min(frameTop, max(top or 0, childTop + spaceV/2))
                    bottom = max(frameBottom, min(bottom or frameTop, childBottom - spaceV/2))
                end
            end
        end
    end

    local LayoutFinished = parent.LayoutFinished
    parent.LayoutFinished = function (self, ...)
        if LayoutFinished then LayoutFinished(self, ...) end
        parent.UpdateRowBackgrounds(self)
    end

    local OnRelease = parent.OnRelease
    parent.OnRelease = function (self, ...)
        Util.TblCall(textures, "Hide")
        self.LayoutFinished = LayoutFinished
        self.UpdateRowBackgrounds = nil
        self.OnRelease = OnRelease
        if OnRelease then OnRelease(self, ...) end
    end
end

-- Add row click callback to a table
function Self.TableRowClick(parent, skip)
    skip = skip or 0
    local tblObj = parent:GetUserData("table")
    local spaceV = tblObj.spaceV or tblObj.space or 0
    local clicked = Util.Tbl()

    parent.frame:SetScript("OnMouseDown", function (self, btn)
        clicked[btn] = true
    end)

    parent.frame:SetScript("OnMouseUp", function (self, btn, inside, ...)
        if inside and clicked[btn] then
            local cY = select(2, GetCursorPosition()) / UIParent:GetEffectiveScale()
            local row, left = 0

            for i=skip+1,#parent.children do
                local child = parent.children[i]
                local top, bottom, childLeft = child.frame:GetTop(), child.frame:GetBottom(), child.frame:GetLeft()

                if top and bottom and childLeft then
                    if not left or childLeft <= left then
                        row, left = row + 1, childLeft
                    end

                    if top and bottom and Util.NumIn(cY, bottom - spaceV/2, top + spaceV/2) then
                        parent:Fire("OnRowClick", row, btn) break
                    end
                end
            end
        end
        clicked[btn] = nil
    end)

    local OnRelease = parent.OnRelease
    parent.OnRelease = function (self, ...)
        self:SetScript("OnMouseDown", nil)
        self:SetScript("OnMouseUp", nil)
        self.OnRelease = OnRelease
        if OnRelease then OnRelease(self, ...) end
    end
end

-------------------------------------------------------
--               AceGUI table layout                 --
-------------------------------------------------------

-- Get alignment method and value. Possible alignment methods are a callback, a number, "start", "middle", "end", "fill" or "TOPLEFT", "BOTTOMRIGHT" etc.
local GetCellAlign = function (dir, tableObj, colObj, cellObj, cell, child)
    local fn = cellObj and (cellObj["align" .. dir] or cellObj.align)
            or colObj and (colObj["align" .. dir] or colObj.align)
            or tableObj["align" .. dir] or tableObj.align
            or "CENTERLEFT"
    local child, cell, val = child or 0, cell or 0, nil

    if type(fn) == "string" then
        fn = fn:lower()
        fn = dir == "V" and (fn:sub(1, 3) == "top" and "start" or fn:sub(1, 6) == "bottom" and "end" or fn:sub(1, 6) == "center" and "middle")
          or dir == "H" and (fn:sub(-4) == "left" and "start" or fn:sub(-5) == "right" and "end" or fn:sub(-6) == "center" and "middle")
          or fn
        val = (fn == "start" or fn == "fill") and 0 or fn == "end" and cell - child or (cell - child) / 2
    elseif type(fn) == "function" then
        val = fn(child or 0, cell, dir)
    else
        val = fn
    end

    return fn, max(0, min(val, cell))
end

-- Get width or height for multiple cells combined
local GetCellDimension = function (dir, laneDim, from, to, space)
    local dim = 0
    for cell=from,to do
        dim = dim + (laneDim[cell] or 0)
    end
    return dim + max(0, to - from) * (space or 0)
end

--[[ Options
============
Container:
 - columns ({col, col, ...}): Column settings. "col" can be a number (<= 0: content width, <1: rel. width, <10: weight, >=10: abs. width) or a table with column setting.
 - space, spaceH, spaceV: Overall, horizontal and vertical spacing between cells.
 - align, alignH, alignV: Overall, horizontal and vertical cell alignment. See GetCellAlign() for possible values.
Columns:
 - width: Fixed column width (nil or <=0: content width, <1: rel. width, >=1: abs. width).
 - min or 1: Min width for content based width
 - max or 2: Max width for content based width
 - weight: Flexible column width. The leftover width after accounting for fixed-width columns is distributed to weighted columns according to their weights.
 - align, alignH, alignV: Overwrites the container setting for alignment.
Cell:
 - colspan: Makes a cell span multiple columns.
 - rowspan: Makes a cell span multiple rows.
 - align, alignH, alignV: Overwrites the container and column setting for alignment.
]]
AceGUI:RegisterLayout("RS_Table", function (content, children)
    local obj = content.obj
    obj:PauseLayout()

    local tableObj = obj:GetUserData("table")
    local cols = tableObj.columns
    local spaceH = tableObj.spaceH or tableObj.space or 0
    local spaceV = tableObj.spaceV or tableObj.space or 0
    local totalH = (content:GetWidth() or content.width or 0) - spaceH * (#cols - 1)
    
    -- We need to reuse these because layout events can come in very frequently
    local layoutCache = obj:GetUserData("layoutCache")
    if not layoutCache then
        layoutCache = {{}, {}, {}, {}, {}, {}}
        obj:SetUserData("layoutCache", layoutCache)
    end
    local t, laneH, laneV, rowspans, rowStart, colStart = unpack(layoutCache)
    
    -- Create the grid
    local n, slotFound = 0
    for i,child in ipairs(children) do
        if child:IsShown() then
            repeat
                n = n + 1
                local col = (n - 1) % #cols + 1
                local row = ceil(n / #cols)
                local rowspan = rowspans[col]
                local cell = rowspan and rowspan.child or child
                local cellObj = cell:GetUserData("cell")
                slotFound = not rowspan

                -- Rowspan
                if not rowspan and cellObj and cellObj.rowspan then
                    rowspan = {child = child, from = row, to = row + cellObj.rowspan - 1}
                    rowspans[col] = rowspan
                end
                if rowspan and i == #children then
                    rowspan.to = row
                end

                -- Colspan
                local colspan = max(0, min((cellObj and cellObj.colspan or 1) - 1, #cols - col))
                n = n + colspan

                -- Place the cell
                if not rowspan or rowspan.to == row then
                    t[n] = cell
                    rowStart[cell] = rowspan and rowspan.from or row
                    colStart[cell] = col

                    if rowspan then
                        rowspans[col] = nil
                    end
                end
            until slotFound
        end
    end

    local rows = ceil(n / #cols)

    -- Determine fixed size cols and collect weights
    local extantH, totalWeight = totalH, 0
    for col,colObj in ipairs(cols) do
        laneH[col] = 0

        if type(colObj) == "number" then
            colObj = {[colObj >= 1 and colObj < 10 and "weight" or "width"] = colObj}
            cols[col] = colObj
        end

        if colObj.weight then
            -- Weight
            totalWeight = totalWeight + (colObj.weight or 1)
        else
            if not colObj.width or colObj.width <= 0 then
                -- Content width
                for row=1,rows do
                    local child = t[(row - 1) * #cols + col]
                    if child then
                        local f = child.frame
                        f:ClearAllPoints()
                        local childH = f:GetWidth() or 0
    
                        laneH[col] = max(laneH[col], childH - GetCellDimension("H", laneH, colStart[child], col - 1, spaceH))
                    end
                end

                laneH[col] = max(colObj.min or colObj[1] or 0, min(laneH[col], colObj.max or colObj[2] or laneH[col]))
            else
                -- Rel./Abs. width
                laneH[col] = colObj.width < 1 and colObj.width * totalH or colObj.width
            end
            extantH = max(0, extantH - laneH[col])
        end
    end

    -- Determine sizes based on weight
    local scale = totalWeight > 0 and extantH / totalWeight or 0
    for col,colObj in pairs(cols) do
        if colObj.weight then
            laneH[col] = scale * colObj.weight
        end
    end

    -- Arrange children
    for row=1,rows do
        local rowV = 0

        -- Horizontal placement and sizing
        for col=1,#cols do
            local child = t[(row - 1) * #cols + col]
            if child then
                local colObj = cols[colStart[child]]
                if not child.GetUserData then Util.Dump(row, col, (row - 1) * #cols + col, child) end
                local cellObj = child:GetUserData("cell")
                local offsetH = GetCellDimension("H", laneH, 1, colStart[child] - 1, spaceH) + (colStart[child] == 1 and 0 or spaceH)
                local cellH = GetCellDimension("H", laneH, colStart[child], col, spaceH)
                
                local f = child.frame
                f:ClearAllPoints()
                local childH = f:GetWidth() or 0

                local alignFn, align = GetCellAlign("H", tableObj, colObj, cellObj, cellH, childH)
                f:SetPoint("LEFT", content, offsetH + align, 0)
                if child:IsFullWidth() or alignFn == "fill" or childH > cellH then
                    f:SetPoint("RIGHT", content, "LEFT", offsetH + align + cellH, 0)
                end
                
                if child.DoLayout then
                    child:DoLayout()
                end

                rowV = max(rowV, (f:GetHeight() or 0) - GetCellDimension("V", laneV, rowStart[child], row - 1, spaceV))
            end
        end

        laneV[row] = rowV

        -- Vertical placement and sizing
        for col=1,#cols do
            local child = t[(row - 1) * #cols + col]
            if child then
                local colObj = cols[colStart[child]]
                local cellObj = child:GetUserData("cell")
                local offsetV = GetCellDimension("V", laneV, 1, rowStart[child] - 1, spaceV) + (rowStart[child] == 1 and 0 or spaceV)
                local cellV = GetCellDimension("V", laneV, rowStart[child], row, spaceV)
                    
                local f = child.frame
                local childV = f:GetHeight() or 0

                local alignFn, align = GetCellAlign("V", tableObj, colObj, cellObj, cellV, childV)
                if child:IsFullHeight() or alignFn == "fill" then
                    f:SetHeight(cellV)
                end
                f:SetPoint("TOP", content, 0, -(offsetV + align))
            end
        end
    end

    -- Calculate total width and height
    local totalH = GetCellDimension("H", laneH, 1, #laneH, spaceH)
    local totalV = GetCellDimension("V", laneV, 1, #laneV, spaceV)
    
    -- Cleanup
    for _,v in pairs(layoutCache) do wipe(v) end

    Util.Safecall(obj.LayoutFinished, obj, totalH, totalV)
    obj:ResumeLayout()
end)

-- Enable chain-calling
Self.C = {f = nil, k = nil}
local Fn = function (...)
    local c, k, f = Self.C, rawget(Self.C, "k"), rawget(Self.C, "f")
    if k == "AddTo" then
        local parent, beforeWidget = ...
        if parent.type == "Dropdown-Pullout" then
            parent:AddItem(f)
        elseif not parent.children or beforeWidget == false then
            (f.frame or f):SetParent(parent.frame or parent)
        else
            parent:AddChild(f, beforeWidget)
        end
    else
        if k == "Toggle" then
            k = (...) and "Show" or "Hide"
        end

        local obj = f[k] and f
            or f.frame and f.frame[k] and f.frame
            or f.image and f.image[k] and f.image
            or f.label and f.label[k] and f.label
        obj[k](obj, ...)

        -- Fix Label's stupid image anchoring
        if Util.In(obj.type, "Label", "InteractiveLabel") and Util.In(k, "SetText", "SetFont", "SetFontObject", "SetImage") then
            local strWidth, imgWidth = obj.label:GetStringWidth(), obj.imageshown and obj.image:GetWidth() or 0
            local width = Util.NumRound(strWidth + imgWidth + (min(strWidth, imgWidth) > 0 and 4 or 0), 1)
            obj:SetWidth(width)
        end
    end
    return c
end
setmetatable(Self.C, {
    __index = function (c, k)
        c.k = Util.StrUcFirst(k)
        return Fn
    end,
    __call = function (c, i)
        local f = rawget(c, "f")
        if i ~= nil then return f[i] else return f end
    end
})
setmetatable(Self, {
    __call = function (_, f, ...)
        Self.C.f = type(f) == "string" and AceGUI:Create(f, ...) or f
        Self.C.k = nil
        return Self.C
    end
})