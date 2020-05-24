function do_update(self)
	if MovableMan:IsActor(self.ThisActor) then
		self.FullPower = Psyclones_GetFullPower(self.ThisActor, self.BasePower)
		
		-- Calculate effective skills distance
		self.EffectiveDistance = self.FullPower * self.DistPerPower;

		self.Threat = nil
		self.NearestEnemyDist = 1000000
		
		-- Search for nearby actors 
		for actor in MovableMan.Actors do
			-- Search for friends to amplify power
			if actor.Team == self.ThisActor.Team then
				if self.ThisActor.PresetName ~= "Psyclone Avatar" and actor.PresetName ~= "Psyclone Avatar" then
					if actor.Pos.X ~= self.ThisActor.Pos.X or actor.Pos.Y ~= self.ThisActor.Pos.Y then
						local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
						
						if d < self.EffectiveDistance then
							local p = Psyclones_GetFullPower(actor, Psyclones_GetBasePower(actor))
							self.FullPower = self.FullPower + (p * 0.30)
						end
					end
				end
			else
				if not actor:IsInGroup("Brains") and actor.Health > 0 then
				-- Search for enemies to find threat
					local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
					
					if d < self.EffectiveDistance and d < self.NearestEnemyDist then
						local angle = Psyclones_GetAngle(self.Pos, actor.Pos)
						local pos = self.Pos + Vector(math.cos(-angle) * 20, math.sin(-angle) * 20)

						--[[local pix = CreateMOPixel("Purple Glow 1");
						pix.Pos = pos
						MovableMan:AddParticle(pix);]]--
						
						local offsets = {Vector(0,-15), Vector(0,-7), Vector(0,0), Vector(0,7), Vector(0,15)}
						
						for i = 1, #offsets do
							local actorpos = pos
							local vectortoactor = actor.Pos + offsets[i] - actorpos;
							local moid = SceneMan:CastMORay(actorpos , vectortoactor , self.ThisActor.ID , self.ThisActor.Team , -1, false , 6);
							local mo = MovableMan:GetMOFromID(moid);
							
							--[[local pix = CreateMOPixel("Purple Glow 1");
							pix.Pos = actorpos
							MovableMan:AddParticle(pix);
							
							local pix = CreateMOPixel("Purple Glow 1");
							pix.Pos = actorpos + vectortoactor
							MovableMan:AddParticle(pix);]]--

							if mo ~= nil then
								--[[local pix = CreateMOPixel("Purple Glow 1");
								pix.Pos = mo.Pos
								MovableMan:AddParticle(pix);]]--
							
								if mo.ClassName == "AHuman" then
									self.Threat = ToAHuman(mo)
									self.NearestEnemyDist = d;
								else
									local mo = MovableMan:GetMOFromID(mo.RootID);
									if mo ~= nil then
										if mo.ClassName == "AHuman" then
											self.Threat = ToAHuman(mo)
											self.NearestEnemyDist = d;
										end
									end
								end
							end -- if
						end
					end
				end
			end
		end
		
		self.FullPower = math.floor(self.FullPower)

		-- Recalculate effective skills distance
		self.EffectiveDistance = self.FullPower * self.DistPerPower;
		
		-- Debug, draw selected target
		if MovableMan:IsActor(self.Threat) then
			--self.Threat:FlashWhite(25)
		end
		
		-- If we have target then use some skills on it
		if MovableMan:IsActor(self.Threat) and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
			local tosuccess = 1.0
		
			-- Calculate fail probability
			-- Try to find helmet and increase fail probability
			--[[for i = 1 , MovableMan:GetMOIDCount() - 1 do
				local mo = MovableMan:GetMOFromID(i);
				if mo.RootID == self.Threat.ID  then
					if string.find(mo.PresetName, "Helmet") or string.find(mo.PresetName, "helmet") then
						tosuccess = 0.65
						break;
					end
				end
			end -- Never used for now]]--
		
			-- Check for applicable skill from closest to farthest
			-- Damage and gib
			if self.Energy >= 50 and self.NearestEnemyDist < self.EffectiveDistance * 0.4 and self.FullPower > 10 then
				self.Energy = self.Energy - 50
				
				local dam = self.FullPower * 5
				
				-- Never kill a healthy actor from a single hit
				if dam > 99 then
					dam = 99
				end

				if self.PrintSkills then
					print ("Damage - "..tostring(math.ceil(self.FullPower)).." - "..tostring(math.ceil(dam)).." - "..self.Threat.PresetName)
				end
				
				if self.Threat.Health <= dam then
					local found = false
				
					-- Try to explode head or just gib otherwise
					for i = 1 , MovableMan:GetMOIDCount() - 1 do
						local mo = MovableMan:GetMOFromID(i);
						if mo.RootID == self.Threat.ID  then
							-- Find head
							if string.find(mo.PresetName, "Head") or string.find(mo.PresetName, "head") then
								local g = CreateTDExplosive("Head bomb")
								if g ~= nil then
									g.Pos = mo.Pos;
									g.Scale = 0
									g.HitsMOs = false;
									g.GetsHitByMOs = false;
									MovableMan:AddItem(g);
									g:GibThis();
									found = true
									Psyclones_AddPsyEffect(mo.Pos)
									break;
								end
							end
						end
					end
					
					if not found then
						Psyclones_AddPsyEffect(self.Threat.Pos)
						self.Threat:GibThis();
					end
				else
					self.Threat.Health = self.Threat.Health - dam;
					self.DamageThreat = self.Threat;
					self.Threat:AddAbsImpulseForce(Vector(0, -2), Vector(0,0))
					Psyclones_AddPsyEffect(self.Threat.Pos)
				end
				
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--

			-- Steal weapon
			if self.Energy >= 40 and self.NearestEnemyDist < self.EffectiveDistance * 0.6 then
				if self.PrintSkills then
					print ("Steal - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end

				local weap = self.Threat.EquippedItem;

				if weap ~= nil then
					local newweap = Psyclones_MakeItem(weap.PresetName, weap.ClassName)
					if newweap ~= nil then
						self.Energy = self.Energy - 40
					
						-- If enemy holds grenade then explode it
						if newweap.ClassName == "TDExplosive" then
							newweap:GibThis();
						else
							-- Pull wepon otherwise
							newweap.Pos = weap.Pos;
							MovableMan:AddItem(newweap)
							
							local angle, d = Psyclones_GetAngle(self.Pos, weap.Pos)
							local vel = Vector(-math.cos(-angle) * (3 * self.FullPower), -math.sin(-angle) * (3 * self.FullPower))
							
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
			if self.Energy >= 20 and self.NearestEnemyDist < self.EffectiveDistance * 0.8 then
				local pow = 2 * self.FullPower
			
				if pow > 15 then
					pow = 15
				end
			
				if self.PrintSkills then
					print ("Push - "..tostring(math.ceil(self.FullPower)).." - "..tostring(math.ceil(pow)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - 20

				local target = self.Threat.Pos
				local angle, d = Psyclones_GetAngle(self.Pos, target)
				--local pos = self.Pos + Vector(math.cos(-angle) * (d - 15), math.sin(-angle) * (d - 15))

				--local pix = CreateMOPixel("Purple Glow 1");
				--pix.Pos = target
				--MovableMan:AddParticle(pix);
				
				-- Apply forces
				self.Threat:AddAbsImpulseForce(Vector(math.cos(-angle) * (pow), math.sin(-angle) * (pow)), Vector(0,0))
				
				--local pix = CreateMOPixel("Purple Glow 1");
				--pix.Pos = pos
				--MovableMan:AddParticle(pix);
				
				--CF_DrawString(tostring(angle), self.Pos + Vector(0,-160), 200, 200)
				--CF_DrawString(tostring(cosa), self.Pos + Vector(0,-150), 200, 200)
				--CF_DrawString(tostring(math.floor(angle * (180 / 3.14))), self.Pos + Vector(0,-140), 200, 200)
				Psyclones_AddPsyEffect(self.Threat.Pos)
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--

			-- Scream to make actor drop it's items
			if self.Energy >= 35 and self.NearestEnemyDist < self.EffectiveDistance * 0.9 then
				if self.PrintSkills then
					print ("Scream - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - 35
				self.Threat:UnequipBGArm();
				self.Threat:DropAllInventory();
				
				local weap = self.Threat.EquippedItem;

				if weap ~= nil then
					local newweap = Psyclones_MakeItem(weap.PresetName, weap.ClassName)
					if newweap ~= nil then
						newweap.Pos = weap.Pos;
						MovableMan:AddItem(newweap)
						
						weap.ToDelete = true
					end
				end
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--
			
			-- Distort aiming
			if self.Energy >= 10 then
				if self.PrintSkills then
					print ("Distort - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - 10
				self.AimDistortThreat = self.Threat;
				Psyclones_AddPsyEffect(self.Pos)
				self.CoolDownTimer:Reset();
			end--]]--
		
		end
		
		if MovableMan:IsActor(self.AimDistortThreat) and not self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
			self.AimDistortThreat:GetController():SetState(Controller.AIM_UP, true)
			
			if self.AimDistortThreat:GetAimAngle(false) < 0.75 then
				self.AimDistortThreat:GetController():SetState(Controller.WEAPON_FIRE, true)
			end
		else
			self.AimDistortThreat = nil;
		end

		if MovableMan:IsActor(self.DamageThreat) and not self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
			self.DamageThreat:GetController():SetState(Controller.BODY_CROUCH, true)
			self.DamageThreat:GetController():SetState(Controller.AIM_DOWN, true)
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
				self.Energy = self.Energy + self.FullPower * 0.1
				
				if self.Energy > 100 then
					self.Energy = 100
				end
			end
			
			-- Heal if there's no one nearby and we have enough power
			if self.Threat == nil then
				if self.Energy >= 55 and self.ThisActor.Health < 100 and self.ThisActor.PresetName ~= "Psyclone Avatar" then
					self.Energy = self.Energy - 5
					self.ThisActor.Health = self.ThisActor.Health + 1
				end
			end
			
			-- Reduce health if it's avatar
			if self.ThisActor.PresetName == "Psyclone Avatar" then
				self.ThisActor.Health = self.ThisActor.Health - 1
				
				if self.ThisActor.Health < 1 then
					self.ThisActor:GibThis()
				end
			end
			
			self.Timer:Reset()
		end
		
		-- Draw power marker
		local glownum = math.ceil(self.FullPower * (self.Energy / 100))
		
		if glownum > 10 then
			glownum = 10
		end
		
		if glownum > 0 then
			local pix = CreateMOPixel("Purple Glow "..glownum);
			pix.Pos = self.Pos
			MovableMan:AddParticle(pix);
		end
		
		-- Spawn avatar if we're dying
		if self.ThisActor.Health <= 0 and self.ThisActor.PresetName ~= "Psyclone Avatar" then
			local a = CreateAHuman("Psyclone Avatar")
			a.Team = self.ThisActor.Team;
			a.Pos = self.ThisActor.Pos;
			a.AIMode = Actor.AIMODE_SENTRY;
			MovableMan:AddActor(a)
			
			self.ThisActor:GibThis();
		end
		
		if self.ThisActor.PresetName == "Psyclone Avatar" then
			for i = 1 , MovableMan:GetMOIDCount() - 1 do
				local mo = MovableMan:GetMOFromID(i);
				if mo ~= nil then
					if mo.RootID == self.ThisActor.ID  then
						Psyclones_AddEffect(mo.Pos, "Purple Glow "..tostring(1 + (math.random(2) * 3)))
					end
				end
			end
		end--]]--
		
		--if CF_DrawString ~= nil then
			--CF_DrawString("E "..math.floor(self.Energy), self.Pos + Vector(0,-50), 200, 200)
			--CF_DrawString("P "..self.FullPower, self.Pos + Vector(0,-40), 200, 200)
			--CF_DrawString("G "..glownum, self.Pos + Vector(0,-30), 100, 200)
		--end
	end
end