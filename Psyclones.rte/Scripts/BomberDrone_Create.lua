function do_create_bomberdrone(self)
	-- Set up constants
	self.ShootDelay = 450
	self.ShootoutCounter = 1
	self.InitialVel = 16
	self.VelStep = 4
	self.CurrentVel = self.InitialVel
	self.Active = false;
	self.ActivationDelay = 750;
	self.AltPerBomb = 50
	self.MinAlt = 250
	self.DeployAltitude = 10000;
	
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
		if found.ClassName == "ACRocket" then
			self.ThisActor = ToACRocket(found)
		else
			self.ThisActor = nil;
		end
	end

	self.Timer = Timer();
	
	if self.ThisActor then
		-- Get bomber inventory
		self.InventoryPresets, self.InventoryClasses = Psyclones_GetRocketInventory(self.ThisActor)
		
		if self.InventoryPresets then
			self.DeployAltitude = self.MinAlt + math.ceil(#self.InventoryPresets / 2) * self.AltPerBomb
		end
	end
end
-----------------------------------------------------------------------------------------
-- Get table with inventory of actor, inventory cleared as a result
-----------------------------------------------------------------------------------------
function Psyclones_GetRocketInventory(actor)
	--print("GetInventory")
	local inventory = {}
	local classes = {}

	if MovableMan:IsActor(actor) then
		if not actor:IsInventoryEmpty() then
			local enough = false;
			while not enough do
				local weap = nil;
			
				weap = actor:SwapNextInventory(weap, true);
				
				if weap == nil then
					enough = true;
				else
					inventory[#inventory + 1] = weap.PresetName;
					classes[#classes + 1] = weap.ClassName;
				end
			end
		end
	end
	
	return inventory, classes;
end
