local Name, Addon = ...
local Models, Store, Util = Addon.Models, Addon.Store, Addon.Util
local Self = Addon.Craft

-- Craft tradeskill lines
Self.LINE_ALCHEMY = 171
Self.LINE_BLACKSMITHING = 164
Self.LINE_ENCHANTING = 333
Self.LINE_ENGINEERING = 202
Self.LINE_INSCRIPTION = 773
Self.LINE_JEWELCRAFTING = 755
Self.LINE_LEATHERWORKING = 165
Self.LINE_TAILORING = 197
Self.LINE_SKINNING = 393
Self.LINE_MINING = 186
Self.LINE_HERBALISM = 182
Self.LINE_SMELTING = nil -- TODO
Self.LINE_COOKING = 185
Self.LINE_FISHING = 356
Self.LINE_ARCHAEOLOGY = nil -- TODO

-- Craft tradeskill spell ids
Self.PROF_ALCHEMY = 2259
Self.PROF_BLACKSMITHING = 3100
Self.PROF_ENCHANTING = 7411
Self.PROF_ENGINEERING = 4036
Self.PROF_INSCRIPTION = 45357
Self.PROF_JEWELCRAFTING = 25229
Self.PROF_LEATHERWORKING = 2108
Self.PROF_TAILORING = 3908
Self.PROF_SKINNING = 8613
Self.PROF_MINING = 2575
Self.PROF_HERBALISM = 2366
Self.PROF_SMELTING = 2656
Self.PROF_COOKING = 2550
Self.PROF_FISHING = 131474
Self.PROF_ARCHAEOLOGY = 78670

function Self.IsInfoAvailable()
    return C_TradeSkillUI.IsTradeSkillReady() and not (C_TradeSkillUI.IsTradeSkillGuild() or C_TradeSkillUI.IsTradeSkillLinked() or C_TradeSkillUI.IsNPCCrafting())
end

function Self.GetCurrentLine()
    local line, _, _, _, _, parentLine = C_TradeSkillUI.GetTradeSkillLine()
    return parentLine or line
end