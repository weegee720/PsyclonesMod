local factionid = "Psyclones";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid
CF_FactionNames[factionid] = "Psyclones"
CF_InfantryModules[factionid] = "Psyclones.rte";

CF_LightWeaponSets[factionid] = {"XM-2 Pistol"}
CF_HeavyWeaponSets[factionid] = {"XM-10 Submachine Gun"}
CF_ExplosiveSets[factionid] = nil
CF_ActorSets[factionid] = {"Psyclone Light" , "Psyclone Medium" , "Psyclone Heavy"};

CF_Probabilities[factionid] = {0.75 , 0.30 , -1 , -1};

CF_ArmorCrabs[factionid] = nil
CF_ArmorHumans[factionid] = nil

print ("Load complete "..factionid)