-- <Mod name here> <Mod URL here> by <Mod author here>
-- Faction file by <Faction file contributors here>
-- 
-- Unique Faction ID
local factionid = "Psyclones";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

CF_FactionNames[factionid] = "Psyclones";
CF_FactionDescriptions[factionid] = "Abomnations escaped from some secret lab, weak but armed with extreme psi powers.";
CF_FactionPlayable[factionid] = true;

CF_RequiredModules[factionid] = {"Psyclones.rte"}
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;


-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 0
-- Relation points increase
CF_RelationsBonuses[factionid] = 0
-- Hew HQ build price reduction
CF_ExpansionBonuses[factionid] = 0

-- Gold per turn increase
CF_MineBonuses[factionid] = 0
-- Science per turn increase
CF_LabBonuses[factionid] = 10
-- Delivery time reduction
CF_AirfieldBonuses[factionid] = 0
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 0
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 0
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 100


-- Define brain unit
CF_Brains[factionid] = "Psyclone Mastermind";
CF_BrainModules[factionid] = "Psyclones.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 500;

-- Define dropship
CF_Crafts[factionid] = "Drop Ship MK1";
CF_CraftModules[factionid] = "Base.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 120;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/Bombing.lua"

-- Define buyable actors available for purchase or unlocks
CF_ActNames[factionid] = {}
CF_ActPresets[factionid] = {}
CF_ActModules[factionid] = {}
CF_ActPrices[factionid] = {}
CF_ActDescriptions[factionid] = {}
CF_ActUnlockData[factionid] = {}
CF_ActClasses[factionid] = {}
CF_ActTypes[factionid] = {}
CF_ActPowers[factionid] = {}
CF_ActOffsets[factionid] = {}

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Psyclone Light"
CF_ActPresets[factionid][i] = "Psyclone Light"
CF_ActModules[factionid][i] = "Psyclones.rte"
CF_ActPrices[factionid][i] = 75
CF_ActDescriptions[factionid][i] = "Psyclone Light"
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 2

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Psyclone Medium"
CF_ActPresets[factionid][i] = "Psyclone Medium"
CF_ActModules[factionid][i] = "Psyclones.rte"
CF_ActPrices[factionid][i] = 100
CF_ActDescriptions[factionid][i] = "Psyclone Medium"
CF_ActUnlockData[factionid][i] = 2000
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 4

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Psyclone Heavy"
CF_ActPresets[factionid][i] = "Psyclone Heavy"
CF_ActModules[factionid][i] = "Psyclones.rte"
CF_ActPrices[factionid][i] = 150
CF_ActDescriptions[factionid][i] = "Psyclone Heavy"
CF_ActUnlockData[factionid][i] = 4000
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

-- Define buyable items available for purchase or unlocks
CF_ItmNames[factionid] = {}
CF_ItmPresets[factionid] = {}
CF_ItmModules[factionid] = {}
CF_ItmPrices[factionid] = {}
CF_ItmDescriptions[factionid] = {}
CF_ItmUnlockData[factionid] = {}
CF_ItmClasses[factionid] = {}
CF_ItmTypes[factionid] = {}
CF_ItmPowers[factionid] = {} -- AI will select weapons based on this value 1 - weakest, 10 toughest, 0 never use

-- Available weapon types
-- PISTOL, RIFLE, SHOTGUN, SNIPER, HEAVY, SHIELD, DIGGER, GRENADE

local i = 0
i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Light Digger"
CF_ItmPresets[factionid][i] = "Light Digger"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Lightest in the digger family. Cheapest of them all and works as a nice melee weapon on soft targets."
CF_ItmUnlockData[factionid][i] = 0 -- 0 means available at start
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Medium Digger"
CF_ItmPresets[factionid][i] = "Medium Digger"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Stronger digger. This one can pierce rocks with some effort and dig impressive tunnels and its melee weapon capabilities are much greater."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Heavy Digger"
CF_ItmPresets[factionid][i] = "Heavy Digger"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Heaviest and the most powerful of them all. Eats concrete with great hunger and allows you to make complex mining caves incredibly fast. Shreds anyone unfortunate who stand in its way."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Riot Shield"
CF_ItmPresets[factionid][i] = "Riot Shield"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "This metal shield provides excellent additional frontal protection to the user and it can stop numerous hits before breaking up."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Smpl. #29 Psi Catalyst"
CF_ItmPresets[factionid][i] = "Smpl. #29 Psi Catalyst"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "Increases psi power of nearby friendly actors by 20%"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Smpl. #47 Psi Inhibitor"
CF_ItmPresets[factionid][i] = "Smpl. #47 Psi Inhibitor"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "Decreases psi power of nearby hostile actors by 25%"
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-2 Pistol"
CF_ItmPresets[factionid][i] = "XM-2 Pistol"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = ""
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-10 Submachine Gun"
CF_ItmPresets[factionid][i] = "XM-10 Submachine Gun"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = ""
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Battle Rifle"
CF_ItmPresets[factionid][i] = "Battle Rifle"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = ""
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 1

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Shotgun"
CF_ItmPresets[factionid][i] = "Shotgun"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = ""
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 1
