function do_create_seeker(self)
	-- Find our owner actor
	self.ThisActor = self;
	
	self.Range = 40
	self.FuzeTime = 5000
	self.SeekRange = 700
	
	if self.PresetName == "Long Fuse Seeker" then
		self.FuzeTime = 18000
	end
	
	self.Fuze = Timer()
	self.emitTimer = Timer();
	
	if math.random(9) == 1 then
		self.BlowNow = true; -- :)
	end
end
