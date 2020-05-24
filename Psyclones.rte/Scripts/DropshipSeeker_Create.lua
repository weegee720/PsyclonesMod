function do_create_drophsipseeker(self)
	-- Find our owner actor
	self.ThisActor = self;
	
	self.Range = 400
	self.ImpactRange = 80
	self.IsTriggered = false;
	self.emitTimer = Timer();
	self.ResetTimer = Timer()
	
	if math.random(9) == 1 then
		self.BlowNow = true; -- :)
	end
end
