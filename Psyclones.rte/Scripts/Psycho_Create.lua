function do_create(self)
	-- Find our owner actor
	local found;
	for i=1,MovableMan:GetMOIDCount()-1 do
		local mo = MovableMan:GetMOFromID(i);
		if mo.ID == self.RootID  then
			found = mo;
			break;
		end
	end
	
	if found then
		-- Store actor for future use
		if found.ClassName == "AHuman" then
			self.ThisActor = ToAHuman(found)
		else
			self.ThisActor = nil;
		end
	end
	
	if self.ThisActor then
		-- Calculate actor base power
		self.BasePower = Psyclones_GetBasePower(self.ThisActor);
		print(self.BasePower)
	end
end

function Psyclones_GetBasePower(actor)
	if actor.PresetName == "Psyclone Light" then
		return 2
	elseif actor.PresetName == "Psyclone Medium" then
		return 5
	elseif actor.PresetName == "Psyclone Heavy" then
		return 7
	elseif actor.PresetName == "Psyclone Mastermind" then
		return 9
	end
	
	return 0;
end

function Psyclones_GetFullPower(actor, basepower)
	return math.floor(basepower * (actor.Health / 100))
end