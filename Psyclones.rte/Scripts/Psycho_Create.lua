function do_create(self)
	-- Set up constants
	self.DistPerPower = 30
	self.CoolDownInterval = 4000
	self.PrintSkills = false;

	self.WeaponTeleportEnabled = true;
	self.DamageEnabled = true;
	self.DamageDistortEnabled = false;
	self.PushEnabled = true;
	self.ScreamEnabled = false; -- Too many weapon loosing abilities which may annoy human players
	self.StealEnabled = true;
	self.DistortEnabled = true;
	self.RegenEnabled = true;
	self.ShieldEnabled = false;

	self.WeaponTeleportCost = 1;
	self.DamageCost = 65;
	self.PushCost = 15;
	self.ScreamCost = 25;
	self.StealCost = 30;
	self.DistortCost = 25;
	self.RegenCost = 1;

	
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
			self.CoolDownInterval = 2500
			self.Energy = 100000;
			self.Scale = 0;
		end
		
		if self.ThisActor.PresetName == "Psyclone Mastermind" then
			self.Scale = 0;
		end
		
		
		if self.ThisActor.PresetName == "Sarcophagus" then
			self.CoolDownInterval = 4000
			self.Energy = 100000;

			-- Sarcophagus can only do damage and shield
			self.WeaponTeleportEnabled = false;
			self.DamageEnabled = true;
			self.DamageDistortEnabled = false;
			self.PushEnabled = false;
			self.ScreamEnabled = false;
			self.StealEnabled = false;
			self.DistortEnabled = false;
			self.RegenEnabled = false;
			self.ShieldEnabled = true;
		end
		
		
		if self.ShieldEnabled then
			-- Shield variables
			if G_Shields == nil then
				G_Shields = {}
			end
			if G_Active == nil then
				G_Active = {}
			end
			if G_Pressure == nil then
				G_Pressure = {}
			end
			if G_Timer == nil then
				G_Timer = Timer()
				G_ThisFrameTime = 0
			end
			
			G_ShieldRadius = 180
			G_MinVelocity = 10
			
			G_Shields[#G_Shields + 1] = self.ThisActor
			G_Active[#G_Shields] = true
			G_Pressure[#G_Shields] = 0
		end
	else 
		--print (self.ThisActor)
	end
end

function Psyclones_GetBasePower(actor)
	if actor.PresetName == "Psyclone Light" then
		return 5
	elseif actor.PresetName == "Psyclone Heavy" then
		return 9
	elseif actor.PresetName == "Psyclone Mastermind" then
		return 15
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
