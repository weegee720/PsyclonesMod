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
				if actor.Pos.X ~= self.ThisActor.Pos.X or actor.Pos.Y ~= self.ThisActor.Pos.Y then
					local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
					
					if d < self.EffectiveDistance then
						local p = Psyclones_GetFullPower(actor, Psyclones_GetBasePower(actor))
						self.FullPower = self.FullPower + (p * 0.30)
					end
				end
			else
				if not actor:IsInGroup("Brains") then
				-- Search for enemies to find threat
					local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
					
					if d < self.EffectiveDistance and d < self.NearestEnemyDist then
						local angle = Psyclones_GetAngle(self.Pos, actor.Pos)
						local pos = self.Pos + Vector(math.cos(-angle) * 10, math.sin(-angle) * 10)

						--[[local pix = CreateMOPixel("Purple Glow 1");
						pix.Pos = pos
						MovableMan:AddParticle(pix);]]--
						
						local eactorpos = pos
						local vectortoactor = actor.Pos - eactorpos;
						local moid = SceneMan:CastMORay(eactorpos , vectortoactor , self.ThisActor.ID , self.ThisActor.Team , -1, false , 1);
						local mo = MovableMan:GetMOFromID(moid);

						if mo ~= nil then
							if mo.ClassName == "AHuman" then
								self.Threat = ToAHuman(mo)
								self.NearestEnemyDist = d;
							end
						end -- if
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
			-- Check for applicable skill from closest to farthest
			-- Damage and gib
			if self.Energy >= 80 and self.NearestEnemyDist < self.EffectiveDistance * 0.4 and self.FullPower > 14 then
				self.Energy = self.Energy - 80
				
				local dam = self.FullPower * 7

				if self.PrintSkills then
					print ("Damage - "..tostring(math.ceil(self.FullPower)).." - "..tostring(math.ceil(dam)).." - "..self.Threat.PresetName)
				end
				
				if self.Threat.Health <= dam then
					local found = false
				
					-- Find head
					for i = 1 , MovableMan:GetMOIDCount() - 1 do
						local mo = MovableMan:GetMOFromID(i);
						if mo.RootID == self.Threat.ID  then
							-- Try to explode head or just gib otherwise
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
									break;
								end
							end
						end
					end
					
					if not found then
						self.Threat:GibThis();
					end
				else
					self.Threat.Health = self.Threat.Health - dam;
					self.DamageThreat = self.Threat;
				end
				
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
					
						newweap.Pos = weap.Pos;
						MovableMan:AddItem(newweap)
						
						local angle, d = Psyclones_GetAngle(self.Pos, weap.Pos)
						local vel = Vector(-math.cos(-angle) * (3 * self.FullPower), -math.sin(-angle) * (3 * self.FullPower))
						
						newweap.Vel = vel
						
						weap.ToDelete = true
						self.CoolDownTimer:Reset();
					end
				end
			end--]]--

			-- Push target
			if self.Energy >= 30 and self.NearestEnemyDist < self.EffectiveDistance * 0.8 then
				if self.PrintSkills then
					print ("Push - "..tostring(math.ceil(self.FullPower)).." - "..tostring(math.ceil(4 * self.FullPower)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - 30

				local target = self.Threat.Pos
				local angle, d = Psyclones_GetAngle(self.Pos, target)
				--local pos = self.Pos + Vector(math.cos(-angle) * (d - 15), math.sin(-angle) * (d - 15))

				--local pix = CreateMOPixel("Purple Glow 1");
				--pix.Pos = target
				--MovableMan:AddParticle(pix);
				
				-- Apply forces
				self.Threat:AddAbsImpulseForce(Vector(math.cos(-angle) * (4 * self.FullPower), math.sin(-angle) * (4 * self.FullPower)), Vector(0,0))
				
				--local pix = CreateMOPixel("Purple Glow 1");
				--pix.Pos = pos
				--MovableMan:AddParticle(pix);
				
				--CF_DrawString(tostring(angle), self.Pos + Vector(0,-160), 200, 200)
				--CF_DrawString(tostring(cosa), self.Pos + Vector(0,-150), 200, 200)
				--CF_DrawString(tostring(math.floor(angle * (180 / 3.14))), self.Pos + Vector(0,-140), 200, 200)
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
				self.CoolDownTimer:Reset();
			end--]]--
			
			-- Distort aiming
			if self.Energy >= 20 then
				if self.PrintSkills then
					print ("Distort - "..tostring(math.ceil(self.FullPower)).." - "..self.Threat.PresetName)
				end

				self.Energy = self.Energy - 20
				self.AimDistortThreat = self.Threat;
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
				if self.Energy >= 75 and self.ThisActor.Health < 100 then
					self.Energy = self.Energy - 10
					self.ThisActor.Health = self.ThisActor.Health + 1
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
		
		--if CF_DrawString ~= nil then
			--CF_DrawString("E "..math.floor(self.Energy), self.Pos + Vector(0,-50), 200, 200)
			--CF_DrawString("P "..self.FullPower, self.Pos + Vector(0,-40), 200, 200)
			--CF_DrawString("G "..glownum, self.Pos + Vector(0,-30), 100, 200)
		--end
	end
end