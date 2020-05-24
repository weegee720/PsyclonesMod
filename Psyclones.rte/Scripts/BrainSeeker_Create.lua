function do_create_brainseeker(self)
	-- Find our owner actor
	--[[local found;
	for i=1,MovableMan:GetMOIDCount()-1 do
		local mo = MovableMan:GetMOFromID(i);
		if mo.ID == self.RootID  then
			found = mo;
			break;
		end
	end
	
	if found then
		-- Store actor for future use
		if found.ClassName == "ACrab" then
			self.ThisActor = ToACrab(found)
		else
			self.ThisActor = nil;
		end
	end--]]--
	self.ThisActor = self;
end
