local Name, Addon = ...
local Models, Store, Util = Addon.Models, Addon.Store, Addon.Util
local Self = Addon.Inventory

function Self.GetBagLoc(bag)
    return (bag == BANK_CONTAINER or bag == REAGENTBANK_CONTAINER or bag > NUM_BAG_SLOTS) and Store.LOC_BANK or Store.LOC_BAGS
end