function do_create(self)
	-- Set up constants
	self.DistPerPower = 40
	self.CoolDownInterval = 2000
	self.PrintSkills = false;

	self.WeaponTeleportEnabled = true;
	self.DamageEnabled = true;
	self.PushEnabled = true;
	self.ScreamEnabled = true;
	self.StealEnabled = true;
	self.DistortEnabled = true;
	self.RegenEnabled = true;

	self.WeaponTeleportCost = 15;
	self.DamageCost = 45;
	self.PushCost = 15;
	self.ScreamCost = 25;
	self.StealCost = 30;
	self.DistortCost = 10;
	self.RegenCost = 3;
	
	-- Find our owner actor
	local found;
	for i=1 , MovableMan:GetMOIDCount() - 1 do
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
		elseif found.ClassName == "ACrab" then
			self.ThisActor = ToACrab(found)
		else
			self.ThisActor = nil;
		end
	end

	self.Energy = 100;
	self.Timer = Timer();
	self.CoolDownTimer = Timer()
	
	if self.ThisActor then
		-- Calculate actor base power
		self.BasePower = Psyclones_GetBasePower(self.ThisActor);
		--print(self.BasePower)
		
		if self.ThisActor.PresetName == "Psyclone Avatar" then
			self.CoolDownInterval = 1500
			self.Energy = 100000;
			self.Scale = 0;
		end
		
		if self.ThisActor.PresetName == "Psyclone Mastermind" then
			self.Scale = 0;
		end
		
		
		if self.ThisActor.PresetName == "Sarcophagus" then
			self.CoolDownInterval = 750
			self.Energy = 100000;

			-- Sarcophagus can only do damage
			self.WeaponTeleportEnabled = false;
			self.PushEnabled = false;
			self.ScreamEnabled = false;
			self.StealEnabled = false;
			self.DistortEnabled = false;
			self.RegenEnabled = false;
		end
	else 
		--print (self.ThisActor)
	end
end

function Psyclones_GetBasePower(actor)
	if actor.PresetName == "Psyclone Light" then
		return 4
	elseif actor.PresetName == "Psyclone Heavy" then
		return 8
	elseif actor.PresetName == "Psyclone Mastermind" then
		return 20
	elseif actor.PresetName == "Sarcophagus" then
		return 20
	elseif actor.PresetName == "Psyclone Avatar" then
		return 30
	end
	
	return 0;
end

function Psyclones_GetFullPower(actor, basepower)
	return math.floor(basepower * (actor.Health / 100))
end

function Psyclones_AddEffect(pos, preset)
	local pix = CreateMOPixel(preset);
	pix.Pos = pos
	MovableMan:AddParticle(pix);
end

function Psyclones_AddPsyEffect(pos)
	local pix = CreateMOPixel("Huge Glow");
	pix.Pos = pos
	MovableMan:AddParticle(pix);
end

function Psyclones_MakeItem(item, class)
	if class == "HeldDevice" then
		return CreateHeldDevice(item)
	elseif class == "HDFirearm" then
		return CreateHDFirearm(item)
	elseif class == "TDExplosive" then
		return CreateTDExplosive(item)
	elseif class == "ThrownDevice" then
		return CreateThrownDevice(item)
	end
	
	return nil;
end

function Psyclones_GetAngle(from, to)
	local b = to.X - from.X
	local a = to.Y - from.Y
	local c = SceneMan:ShortestDistance(from, to, true).Magnitude;
	
	local cosa =  (b * b + c * c - a * a) / (2 * b * c)
	local angle = math.acos(cosa)
	
	if (from.X > to.X and from.Y > to.Y) then
		angle = angle
	elseif (from.X < to.X and from.Y > to.Y) then
		angle = angle --
	elseif (from.X < to.X and from.Y < to.Y) then
		angle = -angle
	elseif (from.X > to.X and from.Y < to.Y) then
		angle =  2 * 3.14 - angle --
	end
	
	return angle, c, cosa
end
