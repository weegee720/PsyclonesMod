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
				local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
				
				if d < self.EffectiveDistance then
					local p = Psyclones_GetFullPower(actor, Psyclones_GetBasePower(actor))
					self.FullPower = self.FullPower + (p * 0.30)
				end
			else
			-- Search for enemies to find threat
				local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
				
				if d < self.EffectiveDistance and d < self.NearestEnemyDist then
					local eactorpos = self.Pos
					local vectortoactor = actor.Pos - eactorpos;
					local mo = SceneMan:CastMORay(eactorpos , vectortoactor , self.ThisActor.ID , self.ThisActor.Team , -1, false , 4);
					local thingie = MovableMan:GetMOFromID(mo);

					if thingie ~= nil then
						if thingie.ClassName == "AHuman" then
							self.Threat = ToAHuman(thingie)
							self.NearestEnemyDist = d;
						end
					end -- if
				end
			end
		end
		
		self.FullPower = math.floor(self.FullPower)

		-- Recalculate effective skills distance
		self.EffectiveDistance = self.FullPower * self.DistPerPower;
		
		-- Debug, draw selected target
		if MovableMan:IsActor(self.Threat) then
			self.Threat:FlashWhite(25)
		end
		
		-- If we have target then use some skills on it
		--if MovableMan:IsActor(self.Threat) and self.CoolDownTimer:IsPastSimMS(self.CoolDownInterval) then
			-- Push target
			if self.Energy >= 25 then
				--self.Energy = self.Energy - 25

				--local target = self.Threat.Pos
				local target = Vector(1800,300)
				local angle, d = Psyclones_GetAngle(self.Pos, target)
				local pos = self.Pos + Vector(math.cos(angle) * (d - 15), math.sin(angle) * (d - 15))

				local pix = CreateMOPixel("Purple Glow 1");
				pix.Pos = target
				MovableMan:AddParticle(pix);

				
				--[[local em = CreateAEmitter("Push")
				em.Pos = self.Threat.Pos;
				em.RotAngle = angle
				MovableMan:AddParticle(em);]]--
				
				local pix = CreateMOPixel("Purple Glow 1");
				pix.Pos = pos
				MovableMan:AddParticle(pix);
				
				CF_DrawString(tostring(angle), self.Pos + Vector(0,-150), 200, 200)
				CF_DrawString(tostring(math.floor(angle * (180 / 3.14))), self.Pos + Vector(0,-140), 200, 200)
				self.CoolDownTimer:Reset();
			end--]]--
			
			-- Change aiming
			--[[if self.Energy >= 25 then
				--self.Energy = self.Energy - 25
				
				self.Threat:SetAimAngle(self.Threat:GetAimAngle(true) + 75 * (180 / 3.14));
				self.CoolDownTimer:Reset();
			end]]--
			
		--end

		CF_DrawString(tostring(self.ThisActor:GetAimAngle(true)), self.Pos + Vector(0,-110), 200, 200)
		CF_DrawString(tostring(self.ThisActor:GetAimAngle(false)), self.Pos + Vector(0,-100), 200, 200)
		CF_DrawString(tostring(math.floor(self.ThisActor:GetAimAngle(true) * (180 / 3.14))), self.Pos + Vector(0,-90), 200, 200)
		CF_DrawString(tostring(math.floor(self.ThisActor:GetAimAngle(false) * (180 / 3.14))), self.Pos + Vector(0,-80), 200, 200)
		
		
		
		-- Update state
		if self.Timer:IsPastSimMS(250) then
			-- Add power
			if self.Energy < 100 then
				self.Energy = self.Energy + self.FullPower * 0.1
				
				if self.Energy > 100 then
					self.Energy = 100
				end
			end
			
			-- Heal if there's noone nearby and we have enough power
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
		
		if CF_DrawString ~= nil then
			CF_DrawString("E "..math.floor(self.Energy), self.Pos + Vector(0,-50), 200, 200)
			CF_DrawString("P "..self.FullPower, self.Pos + Vector(0,-40), 200, 200)
			CF_DrawString("G "..glownum, self.Pos + Vector(0,-30), 100, 200)
		end
	end
end