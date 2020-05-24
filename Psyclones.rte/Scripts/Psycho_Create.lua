function do_create(self)
	-- Set up constants
	self.DistPerPower = 500
	self.CoolDownInterval = 1000


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
	else 
		print (self.ThisActor)
	end
	
	self.Energy = 100;
	self.Timer = Timer();
	self.CoolDownTimer = Timer()
	
	
	-- Check angles
	--[[local em = CreateAEmitter("Test Emitter")
	em.Pos = Vector(3500,400);
	em.RotAngle = 45 / (180 / 3.14)
	MovableMan:AddParticle(em);]]--
end

function Psyclones_GetBasePower(actor)
	if actor.PresetName == "Psyclone Light" then
		return 2
	elseif actor.PresetName == "Psyclone Medium" then
		return 5
	elseif actor.PresetName == "Psyclone Heavy" then
		return 9
	elseif actor.PresetName == "Psyclone Mastermind" then
		return 20
	end
	
	return 0;
end

function Psyclones_GetFullPower(actor, basepower)
	return math.floor(basepower * (actor.Health / 100))
end

function Psyclones_GetAngle(from, to)
	local a = math.abs(to.X - from.X)
	local b = math.abs(to.Y - from.Y)
	local c = SceneMan:ShortestDistance(from, to, true).Magnitude;
	
	local cosa =  (b * b + c * c - a * a) / (2 * b * c)
	local angle = math.acos(cosa)

	if (from.X > to.X and from.Y > to.Y) then
		angle = angle + 3.14 -- 
	elseif (from.X < to.X and from.Y > to.Y) then
		angle = 3.14 - angle --
	elseif (from.X > to.X and from.Y < to.Y) then
		angle = 2 * 3.14 - angle
	end
	
	return angle, c
end


function Psyclones_GetAngle(from, to)
	local a = to.X - from.X
	local b = to.Y - from.Y
	local c = SceneMan:ShortestDistance(from, to, true).Magnitude;
	
	local cosa =  (b * b + c * c - a * a) / (2 * b * c)
	local angle = math.acos(cosa)
	
	if (from.X > to.X and from.Y > to.Y) then
		angle = angle + 3.14 -- 
	elseif (from.X < to.X and from.Y > to.Y) then
		angle = 3.14 - angle --
	elseif (from.X > to.X and from.Y < to.Y) then
		angle = 2 * 3.14 - angle
	end
	
	return angle, c
end
