function Create(self)

self.hit = 0;

local curdist = 35
   for i = 1,MovableMan:GetMOIDCount()-1 do
   	gun = MovableMan:GetMOFromID(i);
    if (gun.PresetName == "Psi Lightning Orb") and gun.ClassName == "HDFirearm" and (gun.Pos-self.Pos).Magnitude < curdist then
   	actor = MovableMan:GetMOFromID(gun.RootID);
     if MovableMan:IsActor(actor) then
	self.parent = ToActor(actor);
	self.checkVect = self.parent:GetAimAngle(true); 
	self.parentgun = ToHDFirearm(gun);

	self.Pos = self.parent.Pos;

	self.Team = self.parent.Team;
	self.IgnoresTeamHits = true;
     end
    end
   end


end

function Update(self)

if self.parent:IsDead() or not MovableMan:IsActor(self.parent) then
	local soundfx = CreateAEmitter("Lightning Impact");
	soundfx.Pos = self.Pos;
	MovableMan:AddParticle(soundfx);
	self.ToDelete = true;
else


local activate = math.random(0,1)
if activate == 0 then
	self.Vel = self.Vel * 1.02;
else
	--Get a target.  Go for the closest actor within 85 pixels.
	if MovableMan:IsActor(self.zapman) == false then
	    local curdist = 45;
	    for actor in MovableMan.Actors do
		local avgx = actor.Pos.X - self.Pos.X;
		local avgy = actor.Pos.Y - self.Pos.Y;
		local dist = math.sqrt(avgx ^ 2 + avgy ^ 2);
		if dist < curdist and actor.ID ~= self.parent.ID and actor.Team ~= self.parent.Team then
		    curdist = dist;
		    self.zapman = actor;
		end
	    end
	end

	--If the target still exists...
	if MovableMan:IsActor(self.zapman) then
	    --The direction from the center of the missile to the target.
	    local targetdir = math.atan2(-(self.zapman.Pos.Y-self.Pos.Y),(self.zapman.Pos.X-self.Pos.X));
		local avgx = self.zapman.Pos.X - self.Pos.X;
		local avgy = self.zapman.Pos.Y - self.Pos.Y;
		local dist = math.sqrt(avgx ^ 2 + avgy ^ 2);
		curdist = dist;

	if self.hit > 0 then
		self.ToDelete = true;
	end

	if curdist < 15 then

			local soundfx = CreateAEmitter("Lightning Impact");
			soundfx.Pos = self.Pos;
			MovableMan:AddParticle(soundfx);

				local chain = CreateMOPixel("Gauss Lightning Particle");
				chain.Pos = self.zapman.Pos;
				chain.Vel = self.Vel;

				ToActor(self.zapman).Health = ToActor(self.zapman).Health - 3

				chain.Team = self.Team;
				chain.IgnoresTeamHits = true;

				MovableMan:AddParticle(chain);


				local chain = CreateMOPixel("Gauss Lightning Static Particle");
				local curda = curdist
				local curdb = 12
				chain.Pos = self.Pos;
				chain.Vel = Vector(curda,curdb):RadRotate(targetdir);

				chain.Team = self.Team;
				chain.IgnoresTeamHits = true;

				MovableMan:AddParticle(chain);

				local chain = CreateMOPixel("Gauss Lightning Static Particle");
				local curda = curdist
				local curdb = -12
				chain.Pos = self.Pos;
				chain.Vel = Vector(curda,curdb):RadRotate(targetdir);
				chain.Team = self.Team;
				chain.IgnoresTeamHits = true;
				MovableMan:AddParticle(chain);

				local curda = curdist*1.35
				local curdb = curdist*0.35

				local lightfx = CreateMOPixel("Gauss Lightning Particle");
				lightfx.Vel = self.Vel * 0.28;
				lightfx.Pos = self.Pos;
				lightfx.Team = self.Team;
				lightfx.IgnoresTeamHits = true;
				MovableMan:AddParticle(lightfx);

				self.Vel = Vector(curda,curdb):RadRotate(targetdir);

				self.ToDelete = true;

				self.hit = self.hit + 1;
			
		elseif curdist >= 15 and curdist < 24 then
	      --Zap to
			local rand1 = 17
			local rand2 = 5
			self.Vel = Vector(rand1,rand2):RadRotate(targetdir);

				local chain3 = CreateMOPixel("Gauss Lightning Trail");
				chain3.Pos = self.Pos
				chain3.Vel = self.Vel;
				chain3.Team = self.Team;
				chain3.IgnoresTeamHits = true;
				MovableMan:AddParticle(chain3);

		elseif curdist >= 24 and curdist <= 35 then
	      --Zap to
			local curda = 21
			local rand2 = math.random(-7,7)
			self.Vel = Vector(curda,rand2):RadRotate(targetdir);

				local chain3 = CreateMOPixel("Gauss Lightning Trail");
				chain3.Pos = self.Pos
				chain3.Vel = self.Vel;
				chain3.Team = self.Team;
				chain3.IgnoresTeamHits = true;
				MovableMan:AddParticle(chain3);

		elseif curdist > 35 and curdist < 40 then
	      --Zap to
			local rand1 = math.random(23,38)
			local rand2 = math.random(-11,11)
			self.Vel = Vector(rand1,rand2):RadRotate(targetdir);

				local chain3 = CreateMOPixel("Gauss Lightning Trail");
				chain3.Pos = self.Pos
				chain3.Vel = self.Vel;
				chain3.Team = self.Team;
				chain3.IgnoresTeamHits = true;
				MovableMan:AddParticle(chain3);

		elseif curdist >= 40 then
		--Make lightning track target, but still wiggle around
			local rand1 = math.random(25,41)
			local rand2 = math.random(-13,13)
			self.Vel = Vector(rand1,rand2):RadRotate(targetdir);

				local chain3 = CreateMOPixel("Gauss Lightning Trail");
				chain3.Pos = self.Pos
				chain3.Vel = self.Vel;
				chain3.Team = self.Team;
				chain3.IgnoresTeamHits = true;
				MovableMan:AddParticle(chain3);

		end
	else
	    --If there's no target, randomly fly around
		local rand1 = math.random(46,87)
		local rand2 = math.random(-17,17)
	    self.Vel = Vector(rand1,rand2):RadRotate(self.checkVect);

				local chain3 = CreateMOPixel("Gauss Lightning Trail");
				chain3.Pos = self.Pos
				chain3.Vel = self.Vel;
				chain3.Team = self.Team;
				chain3.IgnoresTeamHits = true;
				MovableMan:AddParticle(chain3);
	end


end
end

end