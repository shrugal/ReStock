local Name, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(Name)
local GUI, Options, Store, Util = Addon.GUI, Addon.Options, Addon.Store, Addon.Util
local Self = Addon

-- Echo levels
Self.ECHO_NONE = 0
Self.ECHO_ERROR = 1
Self.ECHO_INFO = 2
Self.ECHO_VERBOSE = 3
Self.ECHO_DEBUG = 4

-- Player info
Self.REALM = GetRealmName("player")
Self.FACTION = UnitFactionGroup("player")
Self.UNIT = UnitName("player")

Self.storage = nil

-------------------------------------------------------
--                    Addon stuff                    --
-------------------------------------------------------

-- Called when the addon is loaded
function Self:OnInitialize()
    self:ToggleDebug(ReStockDebug or self.DEBUG)
    
    self.db = LibStub("AceDB-3.0"):New(Name .. "DB", {
        -- VERSION 1
        profile = {
            enabled = true
        },
        -- VERSION 1
        -- factionrealm = {},
        -- VERSION 1
        -- char = {}
    }, true)

    -- Set enabled state
    self:SetEnabledState(self.db.profile.enabled)
    
    -- Migrate and register options
    Options.Migrate()
    Options.Register()
    Options.RegisterMinimapIcon()

    -- Register chat commands
    self:RegisterChatCommand(Name, "HandleChatCommand")
    self:RegisterChatCommand("rs", "HandleChatCommand")
end

-- Called when the addon is enabled
function Self:OnEnable()
    -- Register hooks and events
    self.RegisterHooks()
    self:RegisterEvents()
end

-- Called when the addon is disabled
function Self:OnDisable()
    -- Unregister hooks and events
    self.UnregisterHooks()
    self.UnregisterEvents()
end

function Self:ToggleDebug(debug)
    if debug ~= nil then
        self.DEBUG = debug
    else
        self.DEBUG = not self.DEBUG
    end

    ReStockDebug = self.DEBUG

    if self.db then
        self:Info("Debugging " .. (self.DEBUG and "en" or "dis") .. "abled")
    end
end

-------------------------------------------------------
--                   Chat command                    --
-------------------------------------------------------

-- Chat command handling
function Self:HandleChatCommand(msg)
    local args = {self:GetArgs(msg, 10)}
    local cmd = args[1]

    -- Help
    if cmd == "help" then
        self:Help()
    -- Options
    elseif cmd == "options" then
        Options.Show()
    -- Config
    elseif cmd == "config" then
        local name, pre, line = Name, "rs config", msg:sub(cmd:len() + 2)

        -- Handle submenus
        local subs = Util.Tbl()
        if Util.In(args[2], subs) then
            name, pre, line = name .. " " .. Util.StrUcFirst(args[2]), pre .. " " .. args[2], line:sub(args[2]:len() + 2)
        end

        LibStub("AceConfigCmd-3.0").HandleCommand(Addon, pre, name, line)

        -- Add submenus as additional options
        if Util.StrIsEmpty(args[2]) then
            for i,v in pairs(subs) do
                local name = Util.StrUcFirst(v)
                local getter = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(Name .. " " .. name)
                print("  |cffffff78" .. v .. "|r - " .. (getter("cmd", "AceConfigCmd-3.0").name or name))
            end
        end

        Util.TblRelease(subs)
    -- Toggle debug mode
    elseif cmd == "debug" then
        self:ToggleDebug()
    -- Unknown
    else
        self:Err(L["ERROR_CMD_UNKNOWN"], cmd)
    end
end

function Self:Help()
    self:Print(L["HELP"])
end

-------------------------------------------------------
--                      Logging                      --
-------------------------------------------------------

-- Write to log and print if lvl is high enough
function Self:Echo(lvl, line, ...)
    if lvl == self.ECHO_DEBUG then
        for i=1, select("#", ...) do
            line = line .. (i == 1 and " - " or ", ") .. Util.ToString((select(i, ...)))
        end
    else
        line = line:format(...)
    end

    self:Log(lvl, line)

    if not self.db or self.db.profile.messages.echo >= lvl then
        self:Print(line)
    end
end

-- Shortcuts for different log levels
function Self:Error(...) self:Echo(self.ECHO_ERROR, ...) end
function Self:Info(...) self:Echo(self.ECHO_INFO, ...) end
function Self:Verbose(...) self:Echo(self.ECHO_VERBOSE, ...) end
function Self:Debug(...) self:Echo(self.ECHO_DEBUG, ...) end

-- Add an entry to the debug log
function Self:Log(lvl, line)
    tinsert(self.log, ("[%.1f] %s: %s"):format(GetTime(), self.ECHO_LEVELS[lvl or self.ECHO_INFO], line or "-"))
    while #self.log > self.LOG_MAX_ENTRIES do
        Util.TblShift(self.log)
    end
end

-- Export the debug log
function Self:LogExport()
    local _, name, _, _, lang, _, region = RI:GetRealmInfo(realm or GetRealmName())    
    local txt = ("~ ReStock ~ Version: %s ~ Date: %s ~ Locale: %s ~ Realm: %s-%s (%s) ~"):format(self.VERSION, date(), GetLocale(), region, name, lang)
    txt = txt .. "\n" .. Util.TblConcat(self.log, "\n")

    GUI.ShowExportWindow("Export log", txt)
end

-------------------------------------------------------
--                       Timer                       --
-------------------------------------------------------

function Self:ExtendTimerTo(timer, to, ...)
    if not timer.canceled and (select("#", ...) > 0 or timer.ends - GetTime() < to) then
        Self:CancelTimer(timer)
        local fn = timer.looping and Self.ScheduleRepeatingTimer or Self.ScheduleTimer

        if select("#", ...) > 0 then
            timer = fn(Self, timer.func, to, ...)
        else
            timer = fn(Self, timer.func, to, unpack(timer, 1, timer.argsCount))
        end

        return timer, true
    else
        return timer, false
    end
end

function Self:ExtendTimerBy(timer, by, ...)
    return self:ExtendTimerTo(timer, (timer.ends - GetTime()) + by, ...)
end

function Self:TimerIsRunning(timer)
    return timer and not timer.canceled and timer.ends > GetTime()
end
