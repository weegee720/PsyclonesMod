function Update(self)
	if self.Fuze then
		if self.Fuze:IsPastSimMS(500) then
			if self.emitTimer:IsPastSimMS(25) then
				self.emitTimer:Reset();

				local angle = math.pi * 2 * math.random()
				
				local pos = self.Pos + Vector(math.cos(angle) * 60, math.sin(angle) * 60);
				if SceneMan:GetTerrMatter(pos.X, pos.Y) == 0 then
					local damagePar = CreateMOPixel("Wormhole Emission Particle "..math.random(2));
					
					damagePar.Pos = pos;
					damagePar.Vel = Vector(-(math.cos(angle) * 60), -(math.sin(angle) * 60));
					damagePar.Team = self.Team;
					damagePar.IgnoresTeamHits = true;
					MovableMan:AddParticle(damagePar);
				end
			end
		end
	
		local pix = CreateMOPixel("Purple Glow ".. math.random(21));
		pix.Pos = self.Pos
		MovableMan:AddParticle(pix);
		
		if self.Fuze:IsPastSimMS(4000) or self.BlowNow then
			for i = 1, 2 do 
				local pix = CreateMOSRotating("Terrain Eat Explosion");
				if pix then
					pix.Pos = self.Pos
					MovableMan:AddParticle(pix);
					pix:GibThis();
				end
			end
			
			self:GibThis()
		end
	elseif self:IsActivated() then
		self.Fuze = Timer()
		self.emitTimer = Timer();		
		
		if math.random(10) == 1 then
			self.BlowNow = true; -- :)
		end
	end
end