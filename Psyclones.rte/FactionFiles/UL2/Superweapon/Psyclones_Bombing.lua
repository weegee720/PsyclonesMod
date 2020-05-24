-- Psyclones first drop seeker drones on the enemy LZs and then drop dropship seekers to destroy
-- incoming dropships

function UnmappedLands2:FireSuperWeapon(active, ownerteam, enemyteam)
	-- Init superweapon variables
	if self.SuperWeaponInitialized == false then
		self.SuperWeaponTimer = Timer();
		self.SuperWeaponTimer:Reset()
		
		self.SeekerCount = 8;
		self.DropShipSeekerCount = 0;
	end

	-- Activate gunship
	if active then
		--print ("SEEKERS AWAY!!!")
		
		for i = 1, #self.AtkLZ do
			local drone = CreateACRocket("XB-13 Bomber Drone", "Psyclones.rte");
			if drone ~= nil then
				lz = self.AtkLZ[i]:GetCenterPoint().X
			
				drone.Pos = Vector(lz,0)
				--drone.AIMode = Actor.AIMODE_DELIVER;
				if ownerteam == CF_CPUTeam then
					--drone:SetControllerMode(Controller.CIM_DISABLED, -1);
				end
				drone.Team = ownerteam;
				
				for j = 1, self.SeekerCount do
					local bomb = CreateTDExplosive("XM-50 Seeker Bomb","Psyclones.rte")
					if bomb then
						drone:AddInventoryItem(bomb)
					end
				end

				for j = 1, self.DropShipSeekerCount do
					local bomb = CreateTDExplosive("XM-52 Dropship Seeker Bomb","Psyclones.rte")
					if bomb then
						drone:AddInventoryItem(bomb)
					end
				end
				
				MovableMan:AddActor(drone);
			else
				print ("Err: Can't create bomber drone")
			end
		end
	end
end