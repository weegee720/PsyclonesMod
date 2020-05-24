local factionid = "Psyclones";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
CF_FactionNames[factionid] = "Psyclones"
CF_InfantryModules[factionid] = "Psyclones.rte";

CF_LightWeaponSets[factionid] = {"XM-2 Pistol", "Smpl. #01 Psi Lightning Orb", "XM-10 Submachine Gun"}
CF_HeavyWeaponSets[factionid] = {"XM-92B Heavy Sniper", "XM-75 Type D Machinegun", "XM-13 Wormhole Emitter"}
CF_ExplosiveSets[factionid] = {"XM-14 Wormhole Grenade"}
CF_ActorSets[factionid] = {"Psyclone Light" , "Psyclone Heavy"};

CF_Probabilities[factionid] = {0.75 , 0.30 , 0.25 , 0.25};

CF_ArmorCrabs[factionid] = nil
CF_ArmorHumans[factionid] = nil

print ("Load complete "..factionid)