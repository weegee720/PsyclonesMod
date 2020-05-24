function Create(self)
	self.fireTimer = Timer();
	self.chargeCounter = 0;

	self.maxCharge = 16;
end

function Update(self)
	if self:IsActivated() then
		if self.fireTimer:IsPastSimMS(100) then
			self.chargeCounter = self.chargeCounter + 1
			self.fireTimer:Reset();
		end
	else
		if self.fireTimer:IsPastSimMS(100) and self.chargeCounter > 0 then
			self.chargeCounter = self.chargeCounter - 4
			if self.chargeCounter < 0 then
				self.chargeCounter = 0
			end
			self.fireTimer:Reset();
		end
	end
	
	if self.chargeCounter > 0 then
		local actor = MovableMan:GetMOFromID(self.RootID);
		if MovableMan:IsActor(actor) then
			for i = 1 , MovableMan:GetMOIDCount() - 1 do
				local mo = MovableMan:GetMOFromID(i);
				if mo ~= nil then
					if mo.RootID == actor.ID  then
						if math.random(self.maxCharge) < self.chargeCounter then
							local glownum = math.random(self.chargeCounter)
							local pix = CreateMOPixel("Purple Glow "..tostring(glownum));
							pix.Pos = mo.Pos
							MovableMan:AddParticle(pix);
						end
					end
				end
			end
		end
	end
	
	if self.chargeCounter >= self.maxCharge then
		if self.HFlipped == false then
			self.reverseNum = 1;
		else
			self.reverseNum = -1;
		end

		local actor = MovableMan:GetMOFromID(self.RootID);

		local damagePar = CreateAEmitter("Wormhole Shot");
		damagePar.Pos = self.MuzzlePos + Vector(self.reverseNum,0):RadRotate(self.RotAngle);
		damagePar.Vel = Vector(5*self.reverseNum,0):RadRotate(self.RotAngle);
		damagePar:SetWhichMOToNotHit(MovableMan:GetMOFromID(self.RootID),-1);

		if MovableMan:IsActor(actor) then
			damagePar.Team = ToActor(actor).Team;
			damagePar.IgnoresTeamHits = true;
		end

		MovableMan:AddParticle(damagePar);

		local soundfx = CreateAEmitter("Dummy Laser Cannon Sound Fire");
		soundfx.Pos = self.MuzzlePos;
		MovableMan:AddParticle(soundfx);

		self.chargeCounter = 0;
	end
end

function Destroy(self)
end