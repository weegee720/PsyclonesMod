function Create(self)
	self.alliedTeam = -1;
	
	local brain = nil
	local nearestenemydist = 150
	
	for actor in MovableMan.Actors do
		if actor.ClassName == "ACRocket" or actor.ClassName == "ACDropShip" then
			local d = SceneMan:ShortestDistance(actor.Pos, self.Pos, true).Magnitude;
			
			if d < nearestenemydist then
				brain = actor
				nearestenemydist = d;
			end
		end
	end
	
	if brain ~= nil then
		self.alliedTeam = brain.Team;
	end
end

function Update(self)
	--print (self.alliedTeam)
	if self.ID ~= self.RootID then
		local actor = MovableMan:GetMOFromID(self.RootID);
		if MovableMan:IsActor(actor) then
			self.alliedTeam = ToActor(actor).Team;
			--print (self.alliedTeam)
		end
	end

	if SceneMan:FindAltitude(self.Pos, 0, 10) < 50 then
		local Payload = CreateACrab("Dropship Seeker", "Psyclones.rte")
		if Payload then
			Payload.Pos = self.Pos
			--Payload.Team = self.IgnoresWhichTeam
			
			-- Sometimes targeting system glitches
			if math.random(20) == 1 then
				Payload.Team = -1
			else
				Payload.Team = self.alliedTeam
			end
			MovableMan:AddActor(Payload)
		end
		
		self.ToDelete = true
	end
end