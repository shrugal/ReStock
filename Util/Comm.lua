local Name, Addon = ...
local Unit, Util = Addon.Unit, Addon.Util
local Self = Addon.Comm

Self.PREFIX = Addon.ABBR
Self.CHAT_PREFIX = "[" .. Addon.ABBR .. "] "
-- Max # of whispers per item for all addons in the group
Self.MAX_WHISPERS = 2

-- Distribution types
Self.TYPE_GROUP = "GROUP"
Self.TYPE_PARTY = "PARTY"
Self.TYPE_RAID = "RAID"
Self.TYPE_GUILD = "GUILD"
Self.TYPE_OFFICER = "OFFICER"
Self.TYPE_BATTLEGROUND = "BATTLEGROUND"
Self.TYPE_WHISPER = "WHISPER"
Self.TYPE_INSTANCE = "INSTANCE_CHAT"
Self.TYPES = {Self.TYPE_GROUP, Self.TYPE_PARTY, Self.TYPE_RAID, Self.TYPE_GUILD, Self.TYPE_OFFICER, Self.TYPE_BATTLEGROUND, Self.TYPE_WHISPER, Self.TYPE_INSTANCE}

-------------------------------------------------------
--                      Chatting                     --
-------------------------------------------------------

-- Get the complete message prefix for an event
function Self.GetPrefix(event)
    if event:sub(1, 3) ~= Self.PREFIX then
        event = Self.PREFIX .. event
    end

    return event
end

-- Figure out the channel and target for a message
function Self.GetDestination(target)
    local target = target or Self.TYPE_GROUP

    if target == Self.TYPE_GROUP then
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            return Self.TYPE_INSTANCE
        elseif IsInRaid() then
            return Self.TYPE_RAID
        else
            return Self.TYPE_PARTY
        end
    elseif Util.TblFind(Self.TYPES, target) then
        return target
    else
        return Self.TYPE_WHISPER, Unit.Name(target)
    end
end

-- Send an addon message
function Self.Send(event, txt, target, prio, callbackFn, callbackArg)
    event = Self.GetPrefix(event)
    local channel, player = Self.GetDestination(target)

    -- TODO: This fixes a beta bug that causes a dc when sending empty strings
    txt = (not txt or txt == "") and " " or txt

    -- Send the message
    Addon:SendCommMessage(event, txt, channel, player, prio, callbackFn, callbackArg)
end

-- Send structured addon data
function Self.SendData(event, data, target, prio, callbackFn, callbackArg)
    Self.Send(event, Addon:Serialize(data), target, prio, callbackFn, callbackArg)
end

-- Listen for an addon message
function Self.Listen(event, method, fromSelf, fromAll)
    Addon:RegisterComm(Self.GetPrefix(event), function (event, msg, channel, sender)
        msg = msg ~= "" and msg ~= " " and msg or nil
        local unit = Unit(sender)
        if fromAll or Unit.InGroup(unit, not fromSelf) then
            method(event, msg, channel, sender, unit)
        end
    end)
end

-- Listen for an addon message with data
function Self.ListenData(event, method, fromSelf, fromAll)
    Self.Listen(event, function (event, data, ...)
        local success, data = Addon:Deserialize(data)
        if success then
            method(event, data, ...)
        end
    end, fromSelf, fromAll)
end
