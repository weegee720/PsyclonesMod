function Update(self)
	local found;
	for i=1 , MovableMan:GetMOIDCount()-1 do
		local mo = MovableMan:GetMOFromID(i);
		if mo.ID == self.RootID  then
			found = mo;
			break;
		end
	end
	
	if not found then
		--print (self)
		self.ToDelete = true
	end--]]---
end