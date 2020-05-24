function do_shield()
	local radius = 0
	local dist = 0
	local glownum =0
	local s;
	local pr;

	local rads = {}
	local shields = {}
	local active = {}
	local pressure = {}
	local n = 0
	
	for i = 1, #G_Active do
		if G_Active[i] and MovableMan:IsActor(G_Shields[i]) and G_Shields[i].Health > 0 and G_Shields[i].PresetName == "Sarcophagus" then
			n = #shields + 1
		
			shields[n] = G_Shields[i]
			active[n] = true
			rads[n] = G_ShieldRadius * G_Shields[i].Health / 100 - G_Pressure[i] / 10
			
			if rads[n] < 0 then
				rads[n] = 0
			end
			
			if G_Pressure[i] > 7 then
				for i = 1, 4 do
					local a = math.random(360) / (180 / 3.14)
					local pos = shields[n].Pos + Vector(math.cos(a) * rads[n], math.sin(a) * rads[n])
					if SceneMan:GetTerrMatter(pos.X, pos.Y) == 0 then
						Psyclones_AddEffect(pos, "Purple Glow 1")
					end
				end
			end

			pressure[n] = G_Pressure[i] - G_Pressure[i] * 0.050
			if pressure[n] < 0 then
				pressure[n] = 0
			end
			
			--CF_DrawString(tostring(math.ceil(G_Pressure[i])), shields[n].Pos + Vector(0,-50), 200, 200)
		else
			G_Active[i] = false;
		end
	end

	G_Shields = shields;
	G_Active = active;
	G_Pressure = pressure;
	
	for p in MovableMan.Particles do
		if p.HitsMOs and p.Vel.Magnitude >= G_MinVelocity then
			for i = 1, #G_Shields do
				s = G_Shields[i]
				pr = G_Pressure[i]
			
				if G_Active[i] then
					if G_Shields[i].Team ~= p.Team then
						dist = SceneMan:ShortestDistance(s.Pos , p.Pos,true).Magnitude
						
						radius = rads[i]
					
						if dist <= radius and dist > radius * 0.5 then
							pr = pr + (p.Mass * p.Vel.Magnitude)
						
							if math.random(2) == 1 then
								glownum = math.floor(p.Vel.Magnitude / 5)
							
								if glownum > 20 then
									glownum = 20
								end
								
								if glownum >= 1 then
									Psyclones_AddEffect(p.Pos, "Purple Glow "..tostring(glownum))
								end
							end
						
							p.Vel = p.Vel - Vector(p.Vel.X * 0.45, p.Vel.Y * 0.45)
						end
					end
				else
					G_Active[i] = false
				end
				
				G_Pressure[i] = pr
			end
		end
	end
end

function do_update(self)
	-- Don't do anything when in edit mode
	if ActivityMan:GetActivity().ActivityState ~= Activity.RUNNING then
		return
	end
	
	if G_Shields ~= nil then
		-- Timers are updated on every sim update
		-- so to find out if it's first run during this sim update we just
		-- get current timer value
		if G_ThisFrameTime ~= G_Timer.ElapsedSimTimeMS then
			G_ThisFrameTime = G_Timer.ElapsedSimTimeMS;
			do_shield()
			--print ("Do "..G_Timer.ElapsedSimTimeMS)
		else
			--print ("Skip "..G_Timer.ElapsedSimTimeMS)
		end
	end

	if MovableMan:IsActor(self.ThisActor) then
		local gibthisactor = false
		local gibthreat = false;
	
		self.FullPower = Psyclones_GetFullPower(self.ThisActor, self.BasePower)
		
		-- Calculate effective skills distance
		self.EffectiveDistance = self.FullPower * self.DistPerPower;

		self.Threat = nil
		local nearestenemydist = 1000000
		local catalysts = 0
		local inhibitors = 0
		local dreadnoughtnearby = false;
		
		-- Search for nearby actors 
		for actor in MovableMan.Actors do
			-- Search for friends to amplify power
			if actor.Team == self.ThisActor.Team then
				if self.ThisActor.PresetName ~= "Psyclone Avatar" and actor.PresetName ~= "Psyclone Avatar" and self.ThisActor.ID ~= actor.ID then
					if actor.Pos.X ~= self.ThisActor.Pos.X or actor.Pos.Y ~= self.ThisActor.Pos.Y then
						local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
						
						if d < self.EffectiveDistance then
							local p = Psyclones_GetFullPower(actor, Psyclones_GetBasePower(actor))
							self.FullPower = self.FullPower + (p * 0.25)
							
							if actor:HasObject("Smpl. #29 Psi Catalyst") then
								catalysts = catalysts + 1
							end
							
							if actor.PresetName == "Sarcophagus" then
								dreadnoughtnearby = true
							end
						end
					end
				end
			else
				if not actor:IsInGroup("Brains") and actor.Health > 0 and actor.ClassName ~= "ADoor" and actor.ClassName ~= "Actor" then
					-- Search for enemies to find threat
					local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
					
					-- Find only nearest enemies
					if d < self.EffectiveDistance and d < nearestenemydist then
						-- Search for targets only if we have enough power and not recharging
						if self.Energy >= 15 and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
							local angle = Psyclones_GetAngle(self.Pos, actor.Pos)
							local pos = self.Pos + Vector(math.cos(-angle) * 20, math.sin(-angle) * 20)

							-- To improve enemy visibility cast rays across the whole enemy figure
							local offsets = {Vector(0,-15), Vector(0,-7), Vector(0,0), Vector(0,7), Vector(0,15)}
							
							for i = 1, #offsets do
								local actorpos = pos
								local vectortoactor = actor.Pos + offsets[i] - actorpos;
								local moid = SceneMan:CastMORay(actorpos , vectortoactor , self.ThisActor.ID , self.ThisActor.Team , -1, false , 4);
								local mo = MovableMan:GetMOFromID(moid);
								
								if mo ~= nil then
									if mo.ClassName == "AHuman" then
										self.Threat = ToAHuman(mo)
										nearestenemydist = d;
									else
										local mo = MovableMan:GetMOFromID(mo.RootID);
										if mo ~= nil then
											if mo.ClassName == "AHuman" then
												self.Threat = ToAHuman(mo)
												nearestenemydist = d;
											end
										end
									end
								end -- if
							end -- for
							
							-- Disrupt crafts in range, no visibiliity needed
							if self.ThisActor.PresetName == "Sarcophagus" then
								if actor.ClassName == "ACDropShip" or actor.ClassName == "ACRocket" then
									if actor.Pos.X < self.ThisActor.Pos.X then
										actor:GetController():SetState(Controller.MOVE_LEFT, true)
										actor:GetController():SetState(Controller.MOVE_RIGHT, false)
										actor.Vel = actor.Vel + Vector(-0.25, 0)
									else
										actor:GetController():SetState(Controller.MOVE_RIGHT, true)
										actor:GetController():SetState(Controller.MOVE_LEFT, false)
										actor.Vel = actor.Vel + Vector(0.25, 0)
									end
									
									Psyclones_AddEffect(actor.Pos, "Purple Glow 10")
								end
							end
						end
						
						if actor:HasObject("Smpl. #47 Psi Inhibitor") then
							inhibitors = inhibitors + 1
						end
					end --if d <
				end -- if not brain
			end -- else
		end
		
		-- Each friendly catalyst adds 100% of psi power
		self.FullPower = self.FullPower + self.FullPower * (catalysts * 1.0)
		-- Each enemy inhibitor removes 200% of psi power
		self.FullPower = self.FullPower - self.FullPower * (inhibitors * 2.0)
		
		if self.FullPower < 0 then
			self.FullPower = 0
		end
		
		self.FullPower = math.ceil(self.FullPower)

		-- Recalculate effective skills distance
		self.EffectiveDistance = self.FullPower * self.DistPerPower;
		
		-- Debug, draw selected target
		if self.PrintSkills and MovableMan:IsActor(self.Threat) then
			self.Threat:FlashWhite(25)
		end

		-- Check for applicable skill from closest to farthest
		-- Teleport closest weapon
		--print (self.Energy >= self.WeaponTeleportCost and self.WeaponTeleportEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) and self.ThisActor.EquippedItem == nil)
		
		if self.Energy >= self.WeaponTeleportCost and self.WeaponTeleportEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) and self.ThisActor.EquippedItem == nil then
			local nearestitmdist = 1000000
			local nearestitem = nil

			-- Find nearest weapon
			for itm in MovableMan.Items do
				if itm.ClassName == "HDFirearm" and itm.GetsHitByMOs ~= false then
					local d = SceneMan:ShortestDistance(itm.Pos, self.ThisActor.Pos, true).Magnitude;
					if d < 100 + self.EffectiveDistance and d < nearestitmdist then
						nearestitem = itm
						nearestenemydist = d;
					end --if d <
				end
			end
				
			-- Teleport weapon
			if nearestitem ~= nil then
				if self.PrintSkills then
					print ("Teleport - "..tostring(math.ceil(self.FullPower)))
				end
			
				self.Energy = self.Energy - self.WeaponTeleportCost
				Psyclones_AddPsyEffect(self.Pos)
				Psyclones_AddPsyEffect(nearestitem.Pos)
				
				local newitem = CreateHDFirearm(nearestitem:GetModuleAndPresetName())
				if newitem ~= nil then
					self.ThisActor:AddInventoryItem(newitem)
					nearestitem.ToDelete = true
					-- This item will be teleported only on the next sim update, we need to move it far away to avoid grabbing by other psyclones
					nearestitem.Pos = Vector(0,25000)
				end--]]--
				--self.ThisActor:AddInventoryItem(nearestitem)
				self.CoolDownTimer:Reset();
			end
		end

		
		-- If we have target then use some skills on it
		if MovableMan:IsActor(self.Threat) then
			-- Damage and gib
			if self.Energy >= self.DamageCost and nearestenemydist < self.EffectiveDistance * 0.3 and self.FullPower > 10 and self.DamageEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval)then
				self.Energy = self.Energy - self.DamageCost

				if self.PrintSkills then
					print ("Damage - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end
				
				for i = 1, self.FullPower / 4 do
					local pix = CreateMOPixel("Hit particle", "Psyclones.rte");
					pix.Pos = self.Threat.Pos + Vector(-2 + math.random(4), -2 + math.random(4))
					pix.Vel = Vector(-2 + math.random(4), -2 + math.random(4))
					MovableMan:AddParticle(pix); 
				end
				
				Psyclones_AddPsyEffect(self.Threat.Pos)
				self.DamageThreat = self.Threat;
				self.Threat:AddAbsImpulseForce(Vector(0, -6), Vector(0,0))
				
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--

			-- Steal weapon
			if self.Energy >= self.StealCost and nearestenemydist < self.EffectiveDistance * 0.6 and self.StealEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
				local weap = self.Threat.EquippedItem;

				if weap ~= nil then
					local newweap = Psyclones_MakeItem(weap:GetModuleAndPresetName(), weap.ClassName)
					if newweap ~= nil then
						if self.PrintSkills then
							print ("Steal - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
						end

						self.Energy = self.Energy - self.StealCost
					
						-- If enemy holds grenade then explode it
						if newweap.ClassName == "TDExplosive" then
							newweap:GibThis();
						else
							-- Pull wepon otherwise
							newweap.Pos = weap.Pos;
							MovableMan:AddItem(newweap)
							
							local angle, d = Psyclones_GetAngle(self.Pos, weap.Pos)
							local vel = Vector(-math.cos(-angle) * (2 * self.FullPower), -math.sin(-angle) * (2 * self.FullPower))
							
							newweap.Vel = vel
							
							Psyclones_AddPsyEffect(weap.Pos)
							weap.ToDelete = true
						end
						
						Psyclones_AddPsyEffect(self.Pos)
						self.CoolDownTimer:Reset();
					end
				end
			end--]]--

			-- Push target
			if self.Energy >= self.PushCost and nearestenemydist < self.EffectiveDistance * 0.8 and self.PushEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
				local pow = 2.5 * self.FullPower
			
				if self.PrintSkills then
					print ("Push - "..tostring(math.ceil(self.FullPower)).." - "..tostring(math.ceil(pow)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - self.PushCost

				local target = self.Threat.Pos
				local angle, d = Psyclones_GetAngle(self.Pos, target)
				
				-- Apply forces
				self.Threat:AddAbsImpulseForce(Vector(math.cos(-angle) * pow, math.sin(-angle) * pow), Vector(0,0))
				
				Psyclones_AddPsyEffect(self.Threat.Pos)
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--

			-- Scream to make actor drop it's items
			if self.Energy >= self.ScreamCost and nearestenemydist < self.EffectiveDistance * 0.9 and self.ScreamEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
				if self.PrintSkills then
					print ("Scream - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - self.ScreamCost
				self.Threat:UnequipBGArm();
				self.Threat:DropAllInventory();
				
				local weap = self.Threat.EquippedItem;

				if weap ~= nil then
					local newweap = Psyclones_MakeItem(weap:GetModuleAndPresetName(), weap.ClassName)
					if newweap ~= nil then
						newweap.Pos = Vector(weap.Pos.X, weap.Pos.Y);
						MovableMan:AddItem(newweap)
						
						weap.ToDelete = true
					end
				end
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--
			
			-- Distort aiming
			if self.Energy >= self.DistortCost and self.DistortEnabled and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
				if self.PrintSkills then
					print ("Distort - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - self.DistortCost
				self.AimDistortThreat = self.Threat;
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--
		end
		
		-- Do distortion
		if MovableMan:IsActor(self.AimDistortThreat) and not self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval / 4) then
			self.AimDistortThreat:GetController():SetState(Controller.AIM_UP, true)
			
			if self.AimDistortThreat:GetAimAngle(false) < 0.75 then
				self.AimDistortThreat:GetController():SetState(Controller.WEAPON_FIRE, true)
			end
		else
			self.AimDistortThreat = nil;
		end

		-- Do distortion after damage
		if MovableMan:IsActor(self.DamageThreat) and not self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval / 4) then
			if self.DamageDistortEnabled then
				self.DamageThreat:GetController():SetState(Controller.BODY_CROUCH, true)
				self.DamageThreat:GetController():SetState(Controller.AIM_DOWN, true)
			end
		else
			self.DamageThreat = nil;
		end

		--CF_DrawString(tostring(self.ThisActor:GetAimAngle(true)), self.Pos + Vector(0,-110), 200, 200)
		--CF_DrawString(tostring(math.cos(self.ThisActor:GetAimAngle(false))), self.Pos + Vector(0,-100), 200, 200)
		--CF_DrawString(tostring(math.floor(self.ThisActor:GetAimAngle(true) * (180 / 3.14))), self.Pos + Vector(0,-90), 200, 200)
		
		-- Update state
		if self.Timer:IsPastSimMS(250) then
			-- Add power
			if self.Energy < 100 then
				if dreadnoughtnearby then
					self.Energy = self.Energy + self.FullPower
				else
					self.Energy = self.Energy + self.FullPower * 0.1
				end
				
				if self.Energy > 100 then
					self.Energy = 100
				end
			end
			
			-- Heal if there's no one nearby and we have enough power
			if self.Threat == nil and self.RegenEnabled then
				if self.Energy >= 35 and self.ThisActor.Health < 100 and self.ThisActor.PresetName ~= "Psyclone Avatar" then
					self.Energy = self.Energy - self.RegenCost
					self.ThisActor.Health = self.ThisActor.Health + 1
				end
			end
			
			-- Reduce health if it's avatar
			if self.ThisActor.PresetName == "Psyclone Avatar" then
				self.ThisActor.Health = self.ThisActor.Health - math.random(3)
				
				if self.ThisActor.Health < 1 then
					gibthisactor = true					
				end
			end
			
			self.Timer:Reset()
		end
		
		-- Don't let dreadnought fall
		if self.ThisActor.PresetName == "Sarcophagus" then
			if self.ThisActor.Health > 0 then
				self.ThisActor.RotAngle = 0
			end
		end
		
		-- Draw power marker
		local glownum = math.ceil(self.FullPower * (self.Energy / 100))
		
		if glownum > 10 then
			glownum = 10
		end
		
		if glownum > 0 then
			local pix = CreateMOPixel("Purple Glow "..glownum, "Psyclones.rte");
			pix.Pos = self.Pos
			MovableMan:AddParticle(pix);
		end
		
		-- Spawn avatar if we're dying
		if math.random() < 1.1 and self.ThisActor.Health <= 0 and self.ThisActor.PresetName ~= "Psyclone Avatar" and self.ThisActor.PresetName ~= "Sarcophagus" then
			local a = CreateAHuman("Psyclone Avatar", "Psyclones.rte")
			if a then
				a.Team = self.ThisActor.Team;
				a.Pos = self.ThisActor.Pos;
				a.AIMode = self.ThisActor.AIMode;
				if a.AIMode == Actor.AIMODE_GOTO then
					local wp = self.ThisActor:GetLastAIWaypoint()
					a:AddAISceneWaypoint(wp)
				end
				
				-- Find nearest weapon to give it to avatar on spawn
				local nearestitmdist = 1000000
				local nearestitem = nil

				-- Find nearest weapon
				for itm in MovableMan.Items do
					if itm.ClassName == "HDFirearm" and itm.GetsHitByMOs ~= false then
						local d = SceneMan:ShortestDistance(itm.Pos, self.ThisActor.Pos, true).Magnitude;
						if d < 150 and d < nearestitmdist then
							nearestitem = itm
							nearestenemydist = d;
						end --if d <
					end
				end
					
				-- Teleport weapon
				if nearestitem ~= nil then
					Psyclones_AddPsyEffect(a.Pos)
					Psyclones_AddPsyEffect(nearestitem.Pos)
					
					local newitem = CreateHDFirearm(nearestitem:GetModuleAndPresetName())
					if newitem ~= nil then
						a:AddInventoryItem(newitem)
						nearestitem.ToDelete = true
						-- This item will be teleported only on the next sim update, we need to move it far away to avoid grabbing by other psyclones
						nearestitem.Pos = Vector(0,25000)
					end--]]--
				end

				MovableMan:AddActor(a)
				
				local eff = CreateMOSRotating("Avatar effect", "Psyclones.rte")
				if eff ~= nil then
					eff.Pos = a.Pos
					MovableMan:AddParticle(eff)
					eff:GibThis()
				end
				
				-- Switch to avatar if it was player controlled
				if self.ThisActor:IsPlayerControlled() then
					local player = self.ThisActor:GetController().Player
					if player > -1 then
						local activity = ToGameActivity(ActivityMan:GetActivity())
						activity:SwitchToActor(a, player, activity:GetTeamOfPlayer(player));
					end
				end
				
				gibthisactor = true
				self.ThisActor.ToDelete = true;
			end
		end
		
		if self.ThisActor.PresetName == "Psyclone Avatar" then
			for i = 1 , MovableMan:GetMOIDCount() - 1 do
				local mo = MovableMan:GetMOFromID(i);
				if mo ~= nil and math.random() < 0.35 then
					if mo.RootID == self.ThisActor.ID  then
						local glownum = math.floor(math.random(2) * self.FullPower / 6)
					
						if glownum > 10 then
							glownum = 10
						end
						
						if glownum >= 1 then
							Psyclones_AddEffect(mo.Pos, "Purple Glow "..tostring(glownum))
						end
					end
				end
			end
		end--]]--
		
		if CF_DrawString ~= nil and self.PrintSkills then
			CF_DrawString("E "..math.floor(self.Energy), self.Pos + Vector(0,-50), 200, 200)
			CF_DrawString("P "..self.FullPower, self.Pos + Vector(0,-40), 200, 200)
		end
		
		if gibthisactor then
			--self.ThisActor:GibThis();
			self.ThisActor.Health = 0
			self.ThisActor = nil
		end
		
		if gibthreat then
			--self.Threat:GibThis();
			self.Threat.Health = 0
			self.Threat = nil
		end
	end
end