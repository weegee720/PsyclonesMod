function Update(self)
	if self.Fuze then
		if self.Fuze:IsPastSimMS(3000) then
			local Payload = CreateACrab("Brain Seeker", "Psyclones.rte")
			if Payload then
				Payload.Pos = self.Pos
				Payload.Team = self.IgnoresWhichTeam
				MovableMan:AddActor(Payload)
			end
			
			self:GibThis()
		end
	elseif self:IsActivated() then
		self.Fuze = Timer()
	end
end