local Name, Addon = ...
local Convert = Addon.Convert
local Self = Addon.Data.Conversions

-------------------------------------------------------
--                       Mill                        --
-------------------------------------------------------

Self[Convert.METHOD_MILL] = {
    ------------------ Common Pigments ------------------
    [39151] = {
        -- Alabaster Pigment (Ivory / Moonglow Ink)
        [765] = 0.5,
        [2447] = 0.5,
        [2449] = 0.6
    },
    [39343] = {
        -- Azure Pigment (Ink of the Sea)
        [39969] = 0.5,
        [36904] = 0.5,
        [36907] = 0.5,
        [36901] = 0.5,
        [39970] = 0.5,
        [37921] = 0.5,
        [36905] = 0.6,
        [36906] = 0.6,
        [36903] = 0.6
    },
    [61979] = {
        -- Ashen Pigment (Blackfallow Ink)
        [52983] = 0.5,
        [52984] = 0.5,
        [52985] = 0.5,
        [52986] = 0.5,
        [52987] = 0.6,
        [52988] = 0.6
    },
    [39334] = {
        -- Dusky Pigment (Midnight Ink)
        [785] = 0.5,
        [2450] = 0.5,
        [2452] = 0.5,
        [2453] = 0.6,
        [3820] = 0.6
    },
    [39339] = {
        -- Emerald Pigment (Jadefire Ink)
        [3818] = 0.5,
        [3821] = 0.5,
        [3358] = 0.6,
        [3819] = 0.6
    },
    [39338] = {
        -- Golden Pigment (Lion's Ink)
        [3355] = 0.5,
        [3369] = 0.5,
        [3356] = 0.6,
        [3357] = 0.6
    },
    [39342] = {
        -- Nether Pigment (Ethereal Ink)
        [22785] = 0.5,
        [22786] = 0.5,
        [22787] = 0.5,
        [22789] = 0.5,
        [22790] = 0.6,
        [22791] = 0.6,
        [22792] = 0.6,
        [22793] = 0.6
    },
    [79251] = {
        -- Shadow Pigment (Ink of Dreams)
        [72237] = 0.5,
        [72234] = 0.5,
        [79010] = 0.5,
        [72235] = 0.5,
        [89639] = 0.5,
        [79011] = 0.6
    },
    [39341] = {
        -- Silvery Pigment (Shimmering Ink)
        [13463] = 0.5,
        [13464] = 0.5,
        [13465] = 0.6,
        [13466] = 0.6,
        [13467] = 0.6
    },
    [39340] = {
        -- Violet Pigment (Celestial Ink)
        [4625] = 0.5,
        [8831] = 0.5,
        [8838] = 0.5,
        [8839] = 0.6,
        [8845] = 0.6,
        [8846] = 0.6
    },
    [114931] = {
        -- Cerulean Pigment (Warbinder's Ink)
        [109124] = 0.42,
        [109125] = 0.42,
        [109126] = 0.42,
        [109127] = 0.42,
        [109128] = 0.42,
        [109129] = 0.42
    },
    [129032] = {
        -- Roseate Pigment (no legion ink)
        [124101] = 0.42,
        [124102] = 0.42,
        [124103] = 0.42,
        [124104] = 0.47,
        [124105] = 1.22,
        [124106] = 0.42,
        [128304] = 0.2,
        [151565] = 0.43
    },
    ------------------ Rare Pigments ------------------
    [43109] = {
        -- Icy Pigment (Snowfall Ink)
        [39969] = 0.05,
        [36904] = 0.05,
        [36907] = 0.05,
        [36901] = 0.05,
        [39970] = 0.05,
        [37921] = 0.05,
        [36905] = 0.1,
        [36906] = 0.1,
        [36903] = 0.1
    },
    [61980] = {
        -- Burning Embers (Inferno Ink)
        [52983] = 0.05,
        [52984] = 0.05,
        [52985] = 0.05,
        [52986] = 0.05,
        [52987] = 0.1,
        [52988] = 0.1
    },
    [43104] = {
        -- Burnt Pigment (Dawnstar Ink)
        [3356] = 0.1,
        [3357] = 0.1,
        [3369] = 0.05,
        [3355] = 0.05
    },
    [43108] = {
        -- Ebon Pigment (Darkflame Ink)
        [22792] = 0.1,
        [22790] = 0.1,
        [22791] = 0.1,
        [22793] = 0.1,
        [22786] = 0.05,
        [22785] = 0.05,
        [22787] = 0.05,
        [22789] = 0.05
    },
    [43105] = {
        -- Indigo Pigment (Royal Ink)
        [3358] = 0.1,
        [3819] = 0.1,
        [3821] = 0.05,
        [3818] = 0.05
    },
    [79253] = {
        -- Misty Pigment (Starlight Ink)
        [72237] = 0.05,
        [72234] = 0.05,
        [79010] = 0.05,
        [72235] = 0.05,
        [79011] = 0.1,
        [89639] = 0.05
    },
    [43106] = {
        -- Ruby Pigment (Fiery Ink)
        [4625] = 0.05,
        [8838] = 0.05,
        [8831] = 0.05,
        [8845] = 0.1,
        [8846] = 0.1,
        [8839] = 0.1
    },
    [43107] = {
        -- Sapphire Pigment (Ink of the Sky)
        [13463] = 0.05,
        [13464] = 0.05,
        [13465] = 0.1,
        [13466] = 0.1,
        [13467] = 0.1
    },
    [43103] = {
        -- Sapphire Pigment (Ink of the Sky)
        [2453] = 0.1,
        [3820] = 0.1,
        [2450] = 0.05,
        [785] = 0.05,
        [2452] = 0.05
    },
    [129034] = {
        -- Sallow Pigment (no legion ink)
        [124101] = 0.04,
        [124102] = 0.04,
        [124103] = 0.05,
        [124104] = 0.05,
        [124105] = 0.04,
        [124106] = 2.14,
        [128304] = 0.0018,
        [151565] = 0.048
    },
    ------------------ BFA Pigments ------------------
    [153669] = {
        -- Viridescent Pigment
        [152505] = 0.1325,
        [152506] = 0.1325,
        [152507] = 0.1325,
        [152508] = 0.1325,
        [152509] = 0.1325,
        [152511] = 0.1325,
        [152510] = 0.325
    },
    [153636] = {
        -- Crimson Pigment
        [152505] = 0.315,
        [152506] = 0.315,
        [152507] = 0.315,
        [152508] = 0.315,
        [152509] = 0.315,
        [152511] = 0.315,
        [152510] = 0.315
    },
    [153635] = {
        -- Ultramarine Pigment
        [152505] = 0.825,
        [152506] = 0.825,
        [152507] = 0.825,
        [152508] = 0.825,
        [152509] = 0.825,
        [152511] = 0.825,
        [152510] = 0.825
    }
}

-------------------------------------------------------
--                     Prospect                      --
-------------------------------------------------------

Self[Convert.METHOD_PROSPECT] = {
    ------------------ Vanilla Gems ------------------
    [774] = {
        -- Malachite
        [2770] = 0.1
    },
    [818] = {
        -- Tigerseye
        [2770] = 0.1
    },
    [1210] = {
        -- Shadowgem
        [2771] = 0.08,
        [2770] = 0.02
    },
    [1206] = {
        -- Moss Agate
        [2771] = 0.06
    },
    [1705] = {
        -- Lesser Moonstone
        [2771] = 0.08,
        [2772] = 0.06
    },
    [1529] = {
        -- Jade
        [2772] = 0.08,
        [2771] = 0.006
    },
    [3864] = {
        -- Citrine
        [2772] = 0.08,
        [3858] = 0.06,
        [2771] = 0.006
    },
    [7909] = {
        -- Aquamarine
        [3858] = 0.06,
        [2772] = 0.01,
        [2771] = 0.006
    },
    [7910] = {
        -- Star Ruby
        [3858] = 0.08,
        [10620] = 0.02,
        [2772] = 0.01
    },
    [12361] = {
        -- Blue Sapphire
        [10620] = 0.06,
        [3858] = 0.006
    },
    [12799] = {
        -- Large Opal
        [10620] = 0.06,
        [3858] = 0.006
    },
    [12800] = {
        -- Azerothian Diamond
        [10620] = 0.06,
        [3858] = 0.004
    },
    [12364] = {
        -- Huge Emerald
        [10620] = 0.06,
        [3858] = 0.004
    },
    ------------------ Uncommon Gems ------------------
    [23117] = {
        -- Azure Moonstone
        [23424] = 0.04,
        [23425] = 0.04
    },
    [23077] = {
        -- Blood Garnet
        [23424] = 0.04,
        [23425] = 0.04
    },
    [23079] = {
        -- Deep Peridot
        [23424] = 0.04,
        [23425] = 0.04
    },
    [21929] = {
        -- Flame Spessarite
        [23424] = 0.04,
        [23425] = 0.04
    },
    [23112] = {
        -- Golden Draenite
        [23424] = 0.04,
        [23425] = 0.04
    },
    [23107] = {
        -- Shadow Draenite
        [23424] = 0.04,
        [23425] = 0.04
    },
    [36917] = {
        -- Bloodstone
        [36909] = 0.05,
        [36912] = 0.04,
        [36910] = 0.05
    },
    [36923] = {
        -- Chalcedony
        [36909] = 0.05,
        [36912] = 0.04,
        [36910] = 0.05
    },
    [36932] = {
        -- Dark Jade
        [36909] = 0.05,
        [36912] = 0.04,
        [36910] = 0.05
    },
    [36929] = {
        -- Huge Citrine
        [36909] = 0.05,
        [36912] = 0.04,
        [36910] = 0.05
    },
    [36926] = {
        -- Shadow Crystal
        [36909] = 0.05,
        [36912] = 0.04,
        [36910] = 0.05
    },
    [36920] = {
        -- Sun Crystal
        [36909] = 0.05,
        [36912] = 0.04,
        [36910] = 0.04
    },
    [52182] = {
        -- Jasper
        [53038] = 0.05,
        [52185] = 0.04,
        [52183] = 0.04
    },
    [52180] = {
        -- Nightstone
        [53038] = 0.05,
        [52185] = 0.04,
        [52183] = 0.04
    },
    [52178] = {
        -- Zephyrite
        [53038] = 0.05,
        [52185] = 0.04,
        [52183] = 0.04
    },
    [52179] = {
        -- Alicite
        [53038] = 0.05,
        [52185] = 0.04,
        [52183] = 0.04
    },
    [52177] = {
        -- Carnelian
        [53038] = 0.05,
        [52185] = 0.04,
        [52183] = 0.04
    },
    [52181] = {
        -- Hessonite
        [53038] = 0.05,
        [52185] = 0.04,
        [52183] = 0.04
    },
    [76130] = {
        -- Tiger Opal
        [72092] = 0.05,
        [72093] = 0.05,
        [72103] = 0.04,
        [72094] = 0.04
    },
    [76133] = {
        -- Lapis Lazuli
        [72092] = 0.05,
        [72093] = 0.05,
        [72103] = 0.04,
        [72094] = 0.04
    },
    [76134] = {
        -- Sunstone
        [72092] = 0.05,
        [72093] = 0.05,
        [72103] = 0.04,
        [72094] = 0.04
    },
    [76135] = {
        -- Roguestone
        [72092] = 0.05,
        [72093] = 0.05,
        [72103] = 0.04,
        [72094] = 0.04
    },
    [76136] = {
        -- Pandarian Garnet
        [72092] = 0.05,
        [72093] = 0.05,
        [72103] = 0.04,
        [72094] = 0.04
    },
    [76137] = {
        -- Alexandrite
        [72092] = 0.05,
        [72093] = 0.05,
        [72103] = 0.04,
        [72094] = 0.04
    },
    [130172] = {
        -- Sangrite
        [123918] = 0.007,
        [123919] = 0.022
    },
    [130173] = {
        -- Deep Amber
        [123918] = 0.011,
        [123919] = 0.042
    },
    [130174] = {
        -- Azsunite
        [123918] = 0.012,
        [123919] = 0.043
    },
    [130175] = {
        -- Chaotic Spinel
        [123918] = 0.006,
        [123919] = 0.021
    },
    [130176] = {
        -- Skystone
        [123918] = 0.012,
        [123919] = 0.04
    },
    [130177] = {
        -- Queen's Opal
        [123918] = 0.012,
        [123919] = 0.045
    },
    [129100] = {
        -- Gem Chip - mostly trash but limited use in some professions
        [123918] = 0.2,
        [123919] = 0.2
    },
    [153700] = {
        -- Golden Beryl - BFA
        [152579] = 0.06,
        [152512] = 0.055,
        [152513] = 0.065
    },
    [153701] = {
        -- Rubellite- - BFA
        [152579] = 0.06,
        [152512] = 0.055,
        [152513] = 0.065
    },
    [153702] = {
        -- Kubiline - BFA
        [152579] = 0.06,
        [152512] = 0.055,
        [152513] = 0.065
    },
    [153703] = {
        -- Solstone - BFA
        [152579] = 0.06,
        [152512] = 0.055,
        [152513] = 0.065
    },
    [153704] = {
        -- Viridium - BFA
        [152579] = 0.06,
        [152512] = 0.055,
        [152513] = 0.065
    },
    [153705] = {
        -- Kyanite - BFA
        [152579] = 0.06,
        [152512] = 0.055,
        [152513] = 0.065
    },
    ------------------ Rare Gems ------------------
    [23440] = {
        -- Dawnstone
        [23424] = 0.002,
        [23425] = 0.008
    },
    [23436] = {
        -- Living Ruby
        [23424] = 0.002,
        [23425] = 0.008
    },
    [23441] = {
        -- Nightseye
        [23424] = 0.002,
        [23425] = 0.008
    },
    [23439] = {
        -- Noble Topaz
        [23424] = 0.002,
        [23425] = 0.008
    },
    [23438] = {
        -- Star of Elune
        [23424] = 0.002,
        [23425] = 0.008
    },
    [23437] = {
        -- Talasite
        [23424] = 0.002,
        [23425] = 0.008
    },
    [36921] = {
        -- Autumn's Glow
        [36909] = 0.002,
        [36912] = 0.008,
        [36910] = 0.008
    },
    [36933] = {
        -- Forest Emerald
        [36909] = 0.002,
        [36912] = 0.008,
        [36910] = 0.008
    },
    [36930] = {
        -- Monarch Topaz
        [36909] = 0.002,
        [36912] = 0.008,
        [36910] = 0.008
    },
    [36918] = {
        -- Scarlet Ruby
        [36909] = 0.002,
        [36912] = 0.008,
        [36910] = 0.008
    },
    [36924] = {
        -- Sky Sapphire
        [36909] = 0.002,
        [36912] = 0.008,
        [36910] = 0.008
    },
    [36927] = {
        -- Twilight Opal
        [36909] = 0.002,
        [36912] = 0.008,
        [36910] = 0.008
    },
    [52192] = {
        -- Dream Emerald
        [53038] = 0.016,
        [52185] = 0.01,
        [52183] = 0.008
    },
    [52193] = {
        -- Ember Topaz
        [53038] = 0.016,
        [52185] = 0.01,
        [52183] = 0.008
    },
    [52190] = {
        -- Inferno Ruby
        [53038] = 0.016,
        [52185] = 0.01,
        [52183] = 0.008
    },
    [52195] = {
        -- Amberjewel
        [53038] = 0.016,
        [52185] = 0.01,
        [52183] = 0.008
    },
    [52194] = {
        -- Demonseye
        [53038] = 0.016,
        [52185] = 0.01,
        [52183] = 0.008
    },
    [52191] = {
        -- Ocean Sapphire
        [53038] = 0.016,
        [52185] = 0.01,
        [52183] = 0.008
    },
    [76131] = {
        -- Primordial Ruby
        [72092] = 0.008,
        [72093] = 0.008,
        [72103] = 0.03,
        [72094] = 0.03
    },
    [76138] = {
        -- River's Heart
        [72092] = 0.008,
        [72093] = 0.008,
        [72103] = 0.03,
        [72094] = 0.03
    },
    [76139] = {
        -- Wild Jade
        [72092] = 0.008,
        [72093] = 0.008,
        [72103] = 0.03,
        [72094] = 0.03
    },
    [76140] = {
        -- VeMILLon Onyx
        [72092] = 0.008,
        [72093] = 0.008,
        [72103] = 0.03,
        [72094] = 0.03
    },
    [76141] = {
        -- Imperial Amethyst
        [72092] = 0.008,
        [72093] = 0.008,
        [72103] = 0.03,
        [72094] = 0.03
    },
    [76142] = {
        -- Sun's Radiance
        [72092] = 0.008,
        [72093] = 0.008,
        [72103] = 0.03,
        [72094] = 0.03
    },
    [130178] = {
        -- FuryStone
        [123918] = 0.001,
        [123919] = 0.005
    },
    [130179] = {
        -- Eye of Prophecy
        [123918] = 0.002,
        [123919] = 0.007
    },
    [130180] = {
        -- Dawnlight
        [123918] = 0.002,
        [123919] = 0.007
    },
    [130181] = {
        -- Pandemonite
        [123918] = 0.001,
        [123919] = 0.003
    },
    [130182] = {
        -- Maelstrom Sapphire
        [123918] = 0.002,
        [123919] = 0.007
    },
    [130183] = {
        -- Shadowruby
        [123918] = 0.002,
        [123919] = 0.006
    },
    [154120] = {
        -- Owlseye - BFA
        [152579] = 0.015,
        [152512] = 0.0085,
        [152513] = 0.0235
    },
    [154121] = {
        -- Scarlet Diamond - BFA
        [152579] = 0.015,
        [152512] = 0.0085,
        [152513] = 0.0235
    },
    [154122] = {
        -- Tidal Amethyst - BFA
        [152579] = 0.015,
        [152512] = 0.0085,
        [152513] = 0.0235
    },
    [154123] = {
        -- Amberblaze - BFA
        [152579] = 0.015,
        [152512] = 0.0085,
        [152513] = 0.0235
    },
    [154124] = {
        -- Laribole - BFA
        [152579] = 0.015,
        [152512] = 0.0085,
        [152513] = 0.0235
    },
    [154125] = {
        -- Royal Quartz - BFA
        [152579] = 0.015,
        [152512] = 0.0085,
        [152513] = 0.0235
    },
    ------------------ Epic Gems ------------------
    [151579] = {
        -- Labradorite
        [151564] = 0.0056
    },
    [151719] = {
        -- Lightsphene
        [151564] = 0.0064
    },
    [151718] = {
        -- Argulite
        [151564] = 0.0060
    },
    [151720] = {
        -- Chemirine
        [151564] = 0.0063
    },
    [151722] = {
        -- Florid Malachite
        [151564] = 0.0035
    },
    [151721] = {
        -- Hesselian
        [151564] = 0.0040
    },
    [153706] = {
        -- Kraken's Eye -  BFA
        [152579] = 0.0065,
        [152512] = 0.006,
        [152513] = 0.0081
    }
}

-------------------------------------------------------
--                     Transform                     --
-------------------------------------------------------

Self[Convert.METHOD_TRANSFORM] = {
    ------------------ Essences ------------------
    [52719] = {
        -- Celestial Essence
        [52718] = 1 / 3
    },
    [52718] = {
        -- Celestial Essence
        [52719] = 3
    },
    [34055] = {
        -- Cosmic Essence
        [34056] = 1 / 3
    },
    [34056] = {
        -- Cosmic Essence
        [34055] = 3
    },
    [22446] = {
        -- Planar Essence
        [22447] = 1 / 3
    },
    [22447] = {
        -- Planar Essence
        [22446] = 3
    },
    [16203] = {
        -- Eternal Essence
        [16202] = 1 / 3
    },
    [16202] = {
        -- Eternal Essence
        [16203] = 3
    },
    [10939] = {
        -- Magic Essence
        [10938] = 1 / 3
    },
    [10938] = {
        -- Magic Essence
        [10939] = 3
    },
    ------------------ Shards ------------------
    [52721] = {
        -- Heavenly Shard
        [52720] = 1 / 3
    },
    [34052] = {
        -- Dream Shard
        [34053] = 1 / 3
    },
    [74247] = {
        -- Ethereal Shard
        [74252] = 1 / 3
    },
    [111245] = {
        -- Luminous Shard
        [115502] = 0.1
    },
    ------------------ Crystals ------------------
    [113588] = {
        -- Temporal Crystal
        [115504] = 0.1
    },
    ------------------ Primals / Motes ------------------
    [21885] = {
        -- Water
        [22578] = 0.1
    },
    [22456] = {
        -- Shadow
        [22577] = 0.1
    },
    [22457] = {
        -- Mana
        [22576] = 0.1
    },
    [21886] = {
        -- Life
        [22575] = 0.1
    },
    [21884] = {
        -- Fire
        [22574] = 0.1
    },
    [22452] = {
        -- Earth
        [22573] = 0.1
    },
    [22451] = {
        -- Air
        [22572] = 0.1
    },
    -- ------------------ Crystalized / Eternal ------------------
    [37700] = {
        -- Air
        [35623] = 10
    },
    [35623] = {
        -- Air
        [37700] = 0.1
    },
    [37701] = {
        -- Earth
        [35624] = 10
    },
    [35624] = {
        -- Earth
        [37701] = 0.1
    },
    [37702] = {
        -- Fire
        [36860] = 10
    },
    [36860] = {
        -- Fire
        [37702] = 0.1
    },
    [37703] = {
        -- Shadow
        [35627] = 10
    },
    [35627] = {
        -- Shadow
        [37703] = 0.1
    },
    [37704] = {
        -- Life
        [35625] = 10
    },
    [35625] = {
        -- Life
        [37704] = 0.1
    },
    [37705] = {
        -- Water
        [35622] = 10
    },
    [35622] = {
        -- Water
        [37705] = 0.1
    },
    ------------------ Wod Fish ------------------
    [109137] = {
        [111601] = 4, -- Enormous Crescent Saberfish
        [111595] = 2, -- Crescent Saberfish
        [111589] = 1 -- Small Crescent Saberfish
    },
    [109138] = {
        [111676] = 4, -- Enormous Jawless Skulker
        [111669] = 2, -- Jawless Skulker
        [111650] = 1 -- Small Jawless Skulker
    },
    [109139] = {
        [111675] = 4, -- Enormous Fat Sleeper
        [111668] = 2, -- Fat Sleeper
        [111651] = 1 -- Small Fat Sleeper
    },
    [109140] = {
        [111674] = 4, -- Enormous Blind Lake Sturgeon
        [111667] = 2, -- Blind Lake Sturgeon
        [111652] = 1 -- Small Blind Lake Sturgeon
    },
    [109141] = {
        [111673] = 4, -- Enormous Fire Ammonite
        [111666] = 2, -- Fire Ammonite
        [111656] = 1 -- Small Fire Ammonite
    },
    [109142] = {
        [111672] = 4, -- Enormous Sea Scorpion
        [111665] = 2, -- Sea Scorpion
        [111658] = 1 -- Small Sea Scorpion
    },
    [109143] = {
        [111671] = 4, -- Enormous Abyssal Gulper Eel
        [111664] = 2, -- Abyssal Gulper Eel
        [111659] = 1 -- Small Abyssal Gulper Eel
    },
    [109144] = {
        [111670] = 4, -- Enormous Blackwater Whiptail
        [111663] = 2, -- Blackwater Whiptail
        [111662] = 1 -- Small Blackwater Whiptail
    },
    ------------------ Aromatic Fish Oil (BFA) ------------------
    [160711] = {
        [152545] = 1, -- Frenzied Fangtooth
        [152547] = 1, -- Great Sea Catfish
        [152546] = 1, -- Lane Snapper
        [152549] = 1, -- Redtail Loach
        [152543] = 1, -- Sand Shifter
        [152544] = 1, -- Slimy Mackerel
        [152548] = 1 -- Tiragarde Perch
    },
    ------------------ Ore Nuggets ------------------
    [2771] = {
        -- Tin Ore
        [108295] = 0.1
    },
    [2772] = {
        -- Iron Ore
        [108297] = 0.1
    },
    [2775] = {
        -- Silver Ore
        [108294] = 0.1
    },
    [2776] = {
        -- Gold Ore
        [108296] = 0.1
    },
    [3858] = {
        -- Mithril Ore
        [108300] = 0.1
    },
    [7911] = {
        -- Truesilver Ore
        [108299] = 0.1
    },
    [10620] = {
        -- Thorium Ore
        [108298] = 0.1
    },
    [23424] = {
        -- Fel Iron Ore
        [108301] = 0.1
    },
    [23425] = {
        -- Adamantite Ore
        [108302] = 0.1
    },
    [23426] = {
        -- Khorium Ore
        [108304] = 0.1
    },
    [23427] = {
        -- Eternium Ore
        [108303] = 0.1
    },
    [36909] = {
        -- Cobalt Ore
        [108305] = 0.1
    },
    [36910] = {
        -- Titanium Ore
        [108391] = 0.1
    },
    [36912] = {
        -- Saronite Ore
        [108306] = 0.1
    },
    [52183] = {
        -- Pyrite Ore
        [108309] = 0.1
    },
    [52185] = {
        -- Elementium Ore
        [108308] = 0.1
    },
    [53038] = {
        -- Obsidium Ore
        [108307] = 0.1
    },
    [72092] = {
        -- Ghost Iron Ore
        [97512] = 0.1
    },
    [109119] = {
        -- True Iron Ore
        [109991] = 0.1
    },
    ------------------ Herb Parts ------------------
    [2449] = {
        -- Earthroot
        [108319] = 0.1
    }
}

-------------------------------------------------------
--                       Trade                       --
-------------------------------------------------------

Self[Convert.METHOD_TRADE] = {
    [37101] = {
        -- Ivory Ink
        [129032] = 1
    },
    [39469] = {
        -- Moonglow Ink
        [129032] = 1
    },
    [39774] = {
        -- Midnight Ink
        [129032] = 1
    },
    [43116] = {
        -- Lion's Ink
        [129032] = 1
    },
    [43118] = {
        -- Jadefire Ink
        [129032] = 1
    },
    [43120] = {
        -- Celestial Ink
        [129032] = 1
    },
    [43122] = {
        -- Shimmering Ink
        [129032] = 1
    },
    [43124] = {
        -- Ethereal Ink
        [129032] = 1
    },
    [43126] = {
        -- Ink of the Sea
        [129032] = 1
    },
    [43127] = {
        -- Snowfall Ink
        [129032] = 0.1
    },
    [61978] = {
        -- Blackfallow Ink
        [129032] = 1
    },
    [61981] = {
        -- Inferno Ink
        [129032] = 0.1
    },
    [79254] = {
        -- Ink of Dreams
        [129032] = 1
    },
    [79255] = {
        -- Starlight Ink
        [129032] = 0.1
    },
    [113111] = {
        -- Warbinder's Ink
        [129032] = 1
    }
}

-------------------------------------------------------
--                     Disenchant                    --
-------------------------------------------------------

Self[Convert.METHOD_DISENCHANT] = {
    ------------------ Dust ------------------
    [10940] = {
        -- Strange Dust
        {type = ARMOR, quality = 2, min = 5, max = 15, amount = 1.222},
        {type = ARMOR, quality = 2, min = 16, max = 20, amount = 2.025},
        {type = ARMOR, quality = 2, min = 21, max = 25, amount = 5.008},
        {type = ARMOR, quality = 3, min = 16, max = 25, amount = 0.127},
        {type = WEAPON, quality = 2, min = 5, max = 15, amount = 0.302},
        {type = WEAPON, quality = 2, min = 16, max = 20, amount = 0.507},
        {type = WEAPON, quality = 2, min = 21, max = 25, amount = 0.753},
        {type = WEAPON, quality = 3, min = 16, max = 25, amount = 0.127}
    },
    [16204] = {
        -- Light Illusion Dust
        {type = ARMOR, quality = 2, min = 26, max = 45, amount = 1.155},
        {type = ARMOR, quality = 3, min = 26, max = 45, amount = 0.127},
        {type = WEAPON, quality = 2, min = 26, max = 45, amount = 0.344},
        {type = WEAPON, quality = 3, min = 26, max = 45, amount = 0.127}
    },
    [156930] = {
        -- Rich Illusion Dust
        {type = ARMOR, quality = 2, min = 46, max = 58, amount = 1.155},
        {type = ARMOR, quality = 3, min = 46, max = 58, amount = 0.127},
        {type = ARMOR, quality = 4, min = 58, max = 65, amount = 0.900},
        {type = WEAPON, quality = 2, min = 46, max = 58, amount = 0.344},
        {type = WEAPON, quality = 3, min = 46, max = 58, amount = 0.127},
        {type = WEAPON, quality = 4, min = 58, max = 65, amount = 0.900}
    },
    [22445] = {
        -- Arcane Dust
        {type = ARMOR, quality = 2, min = 59, max = 70, amount = 1.933},
        {type = ARMOR, quality = 2, min = 71, max = 80, amount = 2.655},
        {type = WEAPON, quality = 2, min = 80, max = 99, amount = 0.750},
        {type = WEAPON, quality = 2, min = 71, max = 80, amount = 0.787}
    },
    [34054] = {
        -- Infinite Dust
        {type = ARMOR, quality = 2, min = 80, max = 90, amount = 1.933},
        {type = ARMOR, quality = 2, min = 91, max = 100, amount = 4.155},
        {type = WEAPON, quality = 2, min = 80, max = 90, amount = 0.562},
        {type = WEAPON, quality = 2, min = 91, max = 100, amount = 1.200}
    },
    [52555] = {
        -- Hypnotic Dust
        {type = ARMOR, quality = 2, min = 101, max = 103, amount = 1.556},
        {type = ARMOR, quality = 2, min = 104, max = 106, amount = 2.304},
        {type = ARMOR, quality = 2, min = 107, max = 108, amount = 2.628},
        {type = WEAPON, quality = 2, min = 101, max = 103, amount = 0.450},
        {type = WEAPON, quality = 2, min = 104, max = 106, amount = 0.677},
        {type = WEAPON, quality = 2, min = 107, max = 108, amount = 0.774}
    },
    [74249] = {
        -- Spirit Dust
        {type = ARMOR, quality = 2, min = 108, max = 109, amount = 2.285},
        {type = ARMOR, quality = 2, min = 110, max = 113, amount = 2.710},
        {type = ARMOR, quality = 2, min = 114, max = 115, amount = 3.135},
        {type = WEAPON, quality = 2, min = 108, max = 109, amount = 2.245},
        {type = WEAPON, quality = 2, min = 110, max = 113, amount = 2.700},
        {type = WEAPON, quality = 2, min = 114, max = 115, amount = 3.560}
    },
    [109693] = {
        -- Draenic Dust
        {type = ARMOR, quality = 2, min = 116, max = 136, amount = 2.600},
        {type = ARMOR, quality = 3, min = 116, max = 138, amount = 5.810},
        {type = WEAPON, quality = 2, min = 116, max = 136, amount = 2.600},
        {type = WEAPON, quality = 3, min = 116, max = 138, amount = 6.220}
    },
    [124440] = {
        -- Arkhana
        {type = ARMOR, quality = 2, min = 138, max = 170, amount = 4.750},
        {type = WEAPON, quality = 2, min = 138, max = 170, amount = 4.750}
    },
    [152875] = {
        -- Gloom Dust
        {type = ARMOR, quality = 2, min = 172, max = 225, amount = 4.130},
        {type = ARMOR, quality = 2, min = 226, max = 310, amount = 5.474},
        {type = ARMOR, quality = 3, min = 182, max = 999, amount = 1.425},
        {type = ARMOR, quality = 4, min = 300, max = 999, amount = 1.000},
        {type = WEAPON, quality = 2, min = 172, max = 225, amount = 4.130},
        {type = WEAPON, quality = 2, min = 226, max = 310, amount = 5.474},
        {type = WEAPON, quality = 3, min = 182, max = 999, amount = 1.425},
        {type = WEAPON, quality = 4, min = 300, max = 999, amount = 1.000}
    },
    ------------------ Essence ------------------
    [10938] = {
        -- lesser Magic Essence
        {type = ARMOR, quality = 2, min = 5, max = 15, amount = 0.303},
        {type = WEAPON, quality = 2, min = 5, max = 15, amount = 1.218}
    },
    [10939] = {
        -- Greater Magic Essence
        {type = ARMOR, quality = 2, min = 16, max = 25, amount = 0.307},
        {type = ARMOR, quality = 3, min = 16, max = 25, amount = 0.307},
        {type = WEAPON, quality = 2, min = 16, max = 25, amount = 2.000},
        {type = WEAPON, quality = 3, min = 16, max = 25, amount = 2.000}
    },
    [16202] = {
        -- Lesser Eternal Essence
        {type = ARMOR, quality = 2, min = 26, max = 45, amount = 0.346},
        {type = ARMOR, quality = 3, min = 26, max = 45, amount = 0.500},
        {type = WEAPON, quality = 2, min = 26, max = 45, amount = 1.302},
        {type = WEAPON, quality = 3, min = 26, max = 45, amount = 0.500}
    },
    [16203] = {
        -- Greater Eternal Essence
        {type = ARMOR, quality = 2, min = 46, max = 58, amount = 0.346},
        {type = ARMOR, quality = 3, min = 46, max = 58, amount = 0.550},
        {type = ARMOR, quality = 4, min = 58, max = 65, amount = 2.800},
        {type = WEAPON, quality = 2, min = 46, max = 58, amount = 1.182},
        {type = WEAPON, quality = 3, min = 46, max = 58, amount = 0.550},
        {type = WEAPON, quality = 4, min = 58, max = 65, amount = 2.800}
    },
    [22447] = {
        -- Lesser Planar Essence
        {type = ARMOR, quality = 2, min = 59, max = 70, amount = 0.562},
        {type = WEAPON, quality = 2, min = 59, max = 70, amount = 1.932}
    },
    [22446] = {
        -- Greater Planar Essence
        {type = ARMOR, quality = 2, min = 71, max = 80, amount = 0.339},
        {type = WEAPON, quality = 2, min = 71, max = 80, amount = 1.157}
    },
    [34056] = {
        -- Lesser Cosmic Essence
        {type = ARMOR, quality = 2, min = 80, max = 90, amount = 0.562},
        {type = WEAPON, quality = 2, min = 80, max = 90, amount = 1.932}
    },
    [34055] = {
        -- Greater Cosmic Essence
        {type = ARMOR, quality = 2, min = 91, max = 100, amount = 0.339},
        {type = WEAPON, quality = 2, min = 91, max = 100, amount = 1.157}
    },
    [52718] = {
        -- Lesser Celestial Essence
        {type = ARMOR, quality = 2, min = 101, max = 103, amount = 0.562},
        {type = WEAPON, quality = 2, min = 101, max = 103, amount = 1.932}
    },
    [52719] = {
        -- Greater Celestial Essence
        {type = ARMOR, quality = 2, min = 104, max = 108, amount = 0.339},
        {type = WEAPON, quality = 2, min = 104, max = 108, amount = 1.157}
    },
    [74250] = {
        -- Mysterious Essence
        {type = ARMOR, quality = 2, min = 108, max = 111, amount = 0.178},
        {type = ARMOR, quality = 2, min = 112, max = 113, amount = 0.244},
        {type = ARMOR, quality = 2, min = 114, max = 115, amount = 0.244},
        {type = WEAPON, quality = 2, min = 108, max = 111, amount = 0.178},
        {type = WEAPON, quality = 2, min = 112, max = 113, amount = 0.244},
        {type = WEAPON, quality = 2, min = 114, max = 115, amount = 0.333}
    },
    ------------------ Shard ------------------
    [14343] = {
        -- Small Brilliant Shard
        {type = ARMOR, quality = 2, min = 26, max = 45, amount = 0.033},
        {type = ARMOR, quality = 3, min = 26, max = 45, amount = 1.000},
        {type = WEAPON, quality = 2, min = 26, max = 45, amount = 0.033},
        {type = WEAPON, quality = 3, min = 26, max = 45, amount = 1.000}
    },
    [14344] = {
        -- Large Brilliant Shard
        {type = ARMOR, quality = 2, min = 46, max = 58, amount = 0.033},
        {type = ARMOR, quality = 3, min = 46, max = 58, amount = 2.000},
        {type = ARMOR, quality = 4, min = 46, max = 65, amount = 3.500},
        {type = WEAPON, quality = 2, min = 46, max = 58, amount = 0.033},
        {type = WEAPON, quality = 3, min = 46, max = 58, amount = 2.000},
        {type = WEAPON, quality = 4, min = 46, max = 65, amount = 3.500}
    },
    [22448] = {
        -- Small Prismatic Shard
        {type = ARMOR, quality = 2, min = 59, max = 70, amount = 0.033},
        {type = ARMOR, quality = 3, min = 59, max = 70, amount = 1.030},
        {type = WEAPON, quality = 2, min = 59, max = 70, amount = 0.033},
        {type = WEAPON, quality = 3, min = 59, max = 70, amount = 1.030}
    },
    [22449] = {
        -- Large Prismatic Shard
        {type = ARMOR, quality = 2, min = 71, max = 80, amount = 0.033},
        {type = ARMOR, quality = 3, min = 71, max = 80, amount = 1.03},
        {type = WEAPON, quality = 2, min = 71, max = 80, amount = 0.033},
        {type = WEAPON, quality = 3, min = 71, max = 80, amount = 1.03}
    },
    [34053] = {
        -- Small Dream Shard
        {type = ARMOR, quality = 2, min = 80, max = 90, amount = 0.033},
        {type = ARMOR, quality = 3, min = 80, max = 90, amount = 1.000},
        {type = WEAPON, quality = 2, min = 80, max = 90, amount = 0.033},
        {type = WEAPON, quality = 3, min = 80, max = 90, amount = 1.000}
    },
    [34052] = {
        -- Dream Shard
        {type = ARMOR, quality = 3, min = 91, max = 100, amount = 0.033},
        {type = ARMOR, quality = 3, min = 91, max = 100, amount = 1.000},
        {type = WEAPON, quality = 3, min = 91, max = 100, amount = 0.033},
        {type = WEAPON, quality = 3, min = 91, max = 100, amount = 1.000}
    },
    [52720] = {
        -- Small Heavenly Shard
        {type = ARMOR, quality = 3, min = 100, max = 106, amount = 1.000},
        {type = WEAPON, quality = 3, min = 100, max = 106, amount = 1.000}
    },
    [52721] = {
        -- Heavenly Shard
        {type = ARMOR, quality = 3, min = 107, max = 108, amount = 1.000},
        {type = WEAPON, quality = 3, min = 107, max = 108, amount = 1.000}
    },
    [74252] = {
        --Small Ethereal Shard
        {type = ARMOR, quality = 3, min = 110, max = 115, amount = 1.000},
        {type = WEAPON, quality = 3, min = 110, max = 115, amount = 1.000}
    },
    [74247] = {
        -- Ethereal Shard
        {type = ARMOR, quality = 3, min = 110, max = 115, amount = 1.000},
        {type = WEAPON, quality = 3, min = 110, max = 115, amount = 1.000}
    },
    [111245] = {
        -- Luminous Shard
        {type = ARMOR, quality = 3, min = 130, max = 138, amount = 0.100},
        {type = WEAPON, quality = 3, min = 130, max = 138, amount = 0.100}
    },
    [124441] = {
        -- Leylight Shard
        {type = ARMOR, quality = 3, min = 138, max = 180, amount = 1.000},
        {type = WEAPON, quality = 3, min = 138, max = 180, amount = 1.000}
    },
    [152876] = {
        -- Umbra Shard
        {type = ARMOR, quality = 3, min = 182, max = 999, amount = 1.500},
        {type = ARMOR, quality = 4, min = 300, max = 999, amount = 1.200},
        {type = WEAPON, quality = 3, min = 182, max = 999, amount = 1.500},
        {type = WEAPON, quality = 4, min = 300, max = 999, amount = 1.200}
    },
    ------------------ Crystal ------------------
    [22450] = {
        -- Void Crystal
        {type = ARMOR, quality = 4, min = 73, max = 94, amount = 1.470},
        {type = WEAPON, quality = 4, min = 73, max = 94, amount = 1.470}
    },
    [34057] = {
        -- Abyss Crystal
        {type = ARMOR, quality = 4, min = 100, max = 102, amount = 1.000},
        {type = WEAPON, quality = 4, min = 100, max = 102, amount = 1.000}
    },
    [52722] = {
        -- Maelstrom Crystal
        {type = ARMOR, quality = 4, min = 108, max = 114, amount = 1.000},
        {type = WEAPON, quality = 4, min = 108, max = 114, amount = 1.000}
    },
    [74248] = {
        -- Sha Crystal
        {type = ARMOR, quality = 4, min = 116, max = 130, amount = 1.000},
        {type = WEAPON, quality = 4, min = 116, max = 130, amount = 1.000}
    },
    [115504] = {
        -- Fractured Temporal Crystal
        {type = ARMOR, quality = 3, min = 116, max = 138, amount = 0.300},
        {type = ARMOR, quality = 4, min = 132, max = 149, amount = 0.750},
        {type = WEAPON, quality = 3, min = 116, max = 138, amount = 0.150},
        {type = WEAPON, quality = 4, min = 132, max = 149, amount = 0.750}
    },
    [113588] = {
        -- Temporal Crystal
        {type = ARMOR, quality = 3, min = 116, max = 138, amount = 0.050},
        {type = ARMOR, quality = 4, min = 132, max = 149, amount = 0.750},
        {type = WEAPON, quality = 3, min = 116, max = 138, amount = 0.050},
        {type = WEAPON, quality = 4, min = 132, max = 149, amount = 0.750}
    },
    [124442] = {
        -- Chaos Crystal
        {type = ARMOR, quality = 4, min = 160, max = 265, amount = 1.000},
        {type = WEAPON, quality = 4, min = 160, max = 265, amount = 1.000}
    },
    [152877] = {
        -- Veiled Crystal
        {type = ARMOR, quality = 3, min = 182, max = 999, amount = 0.050},
        {type = ARMOR, quality = 4, min = 300, max = 999, amount = 1.000},
        {type = WEAPON, quality = 3, min = 182, max = 999, amount = 0.050},
        {type = WEAPON, quality = 4, min = 300, max = 999, amount = 1.000}
    }
}
