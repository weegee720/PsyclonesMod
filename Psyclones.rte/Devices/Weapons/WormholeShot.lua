function Create(self)
	self.lifeTimer = Timer();
	self.emitTimer = Timer();

	self.InitialVel = Vector(self.Vel.X, self.Vel.Y);
end

function Update(self)
	if self.lifeTimer:IsPastSimMS(500) then
		if self.emitTimer:IsPastSimMS(25) then
			self.emitTimer:Reset();

			local angle = math.pi * 2 * math.random()
			
			local pos = self.Pos + Vector(math.cos(angle) * 90, math.sin(angle) * 90);
			if SceneMan:GetTerrMatter(pos.X, pos.Y) == 0 then
				local damagePar = CreateMOPixel("Wormhole Emission Particle "..math.random(2));
				
				damagePar.Pos = pos;
				damagePar.Vel = Vector(-(math.cos(angle) * 90), -(math.sin(angle) * 90));
				damagePar.Team = self.Team;
				damagePar.IgnoresTeamHits = true;
				MovableMan:AddParticle(damagePar);
			end
		end
	end

	local pix = CreateMOPixel("Purple Glow ".. math.random(21));
	pix.Pos = self.Pos - (self.Vel * 3)
	MovableMan:AddParticle(pix);

	--[[if self.lifeTimer:IsPastSimMS(1000) then
		local pix = CreateMOPixel("Purple Glow ".. math.random(15));
		pix.Pos = self.Pos - (self.Vel * 4)
		MovableMan:AddParticle(pix);
	end

	if self.lifeTimer:IsPastSimMS(1500) then
		local pix = CreateMOPixel("Purple Glow ".. math.random(10));
		pix.Pos = self.Pos - (self.Vel * 5)
		MovableMan:AddParticle(pix);
	end

	if self.lifeTimer:IsPastSimMS(2000) then
		local pix = CreateMOPixel("Purple Glow ".. math.random(7));
		pix.Pos = self.Pos - (self.Vel * 6)
		MovableMan:AddParticle(pix);
	end

	if self.lifeTimer:IsPastSimMS(2500) then
		local pix = CreateMOPixel("Purple Glow ".. math.random(5));
		pix.Pos = self.Pos - (self.Vel * 7)
		MovableMan:AddParticle(pix);
	end

	if self.lifeTimer:IsPastSimMS(3000) then
		local pix = CreateMOPixel("Purple Glow ".. math.random(3));
		pix.Pos = self.Pos - (self.Vel * 8)
		MovableMan:AddParticle(pix);
	end--]]--
	
	if self.lifeTimer:IsPastSimMS(5500) then
		for i = -1, 1 do
			local pix = CreateMOSRotating("Terrain Eat Explosion");
			pix.Pos = self.Pos + (self.Vel * (i * 4))
			MovableMan:AddParticle(pix);
			pix:GibThis();
		end
		self:GibThis();
	end
end