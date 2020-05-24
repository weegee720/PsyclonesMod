function Create(self)

	for i=1, 9 do
		fx1 = CreateMOSParticle("XM Smoke " .. math.random(3), "Psyclones.rte");
		fx1.Pos = self.Pos;
		fx1.Vel = (self.Vel * math.random()) + Vector(math.random()*6,0):RadRotate(math.random()*(math.pi*2));
		MovableMan:AddParticle(fx1);
	
		fx2 = CreateMOPixel("XM Trail Glow " .. math.random(5), "Psyclones.rte");
		fx2.Pos = self.Pos;
		fx2.Vel = (self.Vel * math.random()) + Vector(math.random()*23,0):RadRotate(math.random()*(math.pi*2));
		MovableMan:AddParticle(fx2);
	end

	self.ToDelete = true;
end