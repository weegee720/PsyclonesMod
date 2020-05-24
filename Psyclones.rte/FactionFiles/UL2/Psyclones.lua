-- Psyclones http://forums.datarealms.com/viewtopic.php?f=61&t=39729 by weegee
-- Faction file by weegee
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
CF_LabBonuses[factionid] = 0
-- Delivery time reduction
CF_AirfieldBonuses[factionid] = 0
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 0
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 0
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 0

-- How many more troops dropship can hold
CF_DropShipCapacityBonuses[factionid] = math.floor(CF_MaxUnitsPerDropship * 1.5)

CF_HackTimeBonuses[factionid] = 75
CF_HackRewardBonuses[factionid] = 100

-- Prefered brain inventory items. Brain gets the best available items of the classes specified in list for free.
CF_PreferedBrainInventory[factionid] = {CF_WeaponTypes.DIGGER, CF_WeaponTypes.RIFLE, CF_WeaponTypes.PISTOL}

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
--CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/Bombing.lua"
CF_SuperWeaponScripts[factionid] = "Psyclones.rte/FactionFiles/UL2/Superweapon/Psyclones_Bombing.lua"

-- Define default tactical AI model
CF_FactionAIModels[factionid] = "CONSOLE HUNTERS"

-- Specify presets which are not affected by tactical AI unit management
-- AI will never ever give orders to units in this list
if CF_UnassignableUnits ~= nil then
	CF_UnassignableUnits[factionid] = {"Brain Seeker", "Dropship Seeker", "Seeker", "Long Fuse Seeker"}
end


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
CF_ActDescriptions[factionid][i] = "A light unit with basic psi-abilities. Nearby units amplify each-other's psi-abilities."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 2

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Psyclone Heavy"
CF_ActPresets[factionid][i] = "Psyclone Heavy"
CF_ActModules[factionid][i] = "Psyclones.rte"
CF_ActPrices[factionid][i] = 150
CF_ActDescriptions[factionid][i] = "A heavy unit with well developed psi-abilities and quick reflexes. Nearby units amplify each-other's psi-abilities."
CF_ActUnlockData[factionid][i] = 1750
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Sarcophagus"
CF_ActPresets[factionid][i] = "Sarcophagus"
CF_ActModules[factionid][i] = "Psyclones.rte"
CF_ActPrices[factionid][i] = 850
CF_ActDescriptions[factionid][i] = "Psi-power of this psyclone is so enormous that he must be contained in special sarcophagus. He can damage units, deflect incoming projectiles and move dropships away."
CF_ActUnlockData[factionid][i] = 3000
CF_ActClasses[factionid][i] = "ACrab";
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 8


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
CF_ItmDescriptions[factionid][i] = "An alien device of unknown origin. Increases psi power of nearby friendly actors by 20%"
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Smpl. #47 Psi Inhibitor"
CF_ItmPresets[factionid][i] = "Smpl. #47 Psi Inhibitor"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "An alien device of unknown origin. Decreases psi power of nearby hostile actors by 25%"
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-14 Wormhole Grenade"
CF_ItmPresets[factionid][i] = "XM-14 Wormhole Grenade"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "A real wormhole that fits in your pocket. UNSTABLE!!!"
CF_ItmUnlockData[factionid][i] = 800
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-45 Brain Seeker Pod"
CF_ItmPresets[factionid][i] = "XM-45 Brain Seeker Pod"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "An autonomous compact drone that will seek for enemy brain, revealing everything on it's way."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-47 Drop Ship Seeker Pod"
CF_ItmPresets[factionid][i] = "XM-47 Drop Ship Seeker Pod"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "An autonomous compact mine that will seek for incoming crafts and explode on approach."
CF_ItmUnlockData[factionid][i] = 1800
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-49 Seeker Pod"
CF_ItmPresets[factionid][i] = "XM-49 Seeker Pod"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "An autonomous compact drone that will seek for enemies and explode on approach."
CF_ItmUnlockData[factionid][i] = 1400
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-2 Pistol"
CF_ItmPresets[factionid][i] = "XM-2 Pistol"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 35
CF_ItmDescriptions[factionid][i] = "Compact fully automatic energy pistol with small ammo capacity but high rate of fire."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Smpl. #01 Psi Lightning Orb"
CF_ItmPresets[factionid][i] = "Smpl. #01 Psi Lightning Orb"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "An alien device of unknown origin. Compact, light and capable of delivering enough damage."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-10 Submachine Gun"
CF_ItmPresets[factionid][i] = "XM-10 Submachine Gun"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 85
CF_ItmDescriptions[factionid][i] = "Experimental energy based sub machine gun with limited ammo capacity but extreme rate of fire."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-11 Machine Gun"
CF_ItmPresets[factionid][i] = "XM-11 Machine Gun"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 120
CF_ItmDescriptions[factionid][i] = "Perspective energy based light machine gun developed as a replacement of standard assault rifle."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-92B Heavy Sniper"
CF_ItmPresets[factionid][i] = "XM-92B Heavy Sniper"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 250
CF_ItmDescriptions[factionid][i] = "Experimental heavy rapid-fire laser sniper with low ammo capacity"
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-75 Type D Machinegun"
CF_ItmPresets[factionid][i] = "XM-75 Type D Machinegun"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 200
CF_ItmDescriptions[factionid][i] = "Experimental machinegun capable of delivering short bursts of dense firepower."
CF_ItmUnlockData[factionid][i] = 1500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 8

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "XM-13 Wormhole Emitter"
CF_ItmPresets[factionid][i] = "XM-13 Wormhole Emitter"
CF_ItmModules[factionid][i] = "Psyclones.rte"
CF_ItmPrices[factionid][i] = 220
CF_ItmDescriptions[factionid][i] = "Experimental portable wormhole emitter made to cut through heavily fortified bunkers."
CF_ItmUnlockData[factionid][i] = 2750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9

-- This is important, UL2 don't support bombs, 
-- if you won't check for this UL2 won't load this file
if CF_BombNames ~= nil then
	local n = #CF_BombNames + 1
	CF_BombNames[n] = "XM-50 Seeker Bomb"
	CF_BombPresets[n] = "XM-50 Seeker Bomb"
	CF_BombModules[n] = "Psyclones.rte"
	CF_BombClasses[n] = "TDExplosive"
	CF_BombPrices[n] = 70
	CF_BombDescriptions[n] = " An autonomous, dropship deployable compact drone that will seek for enemies and explode on approach."
	CF_BombOwnerFactions[n] = {"Psyclones"}
	CF_BombUnlockData[n] = 1200

	local n = #CF_BombNames + 1
	CF_BombNames[n] = "XM-52 Dropship Seeker Bomb"
	CF_BombPresets[n] = "XM-52 Dropship Seeker Bomb"
	CF_BombModules[n] = "Psyclones.rte"
	CF_BombClasses[n] = "TDExplosive"
	CF_BombPrices[n] = 100
	CF_BombDescriptions[n] = "An autonomous, dropship deployable compact mine that will seek for incoming crafts and explode on approach."
	CF_BombOwnerFactions[n] = {"Psyclones"}
	CF_BombUnlockData[n] = 1600
end
