function Create(self)

end

function Update(self)

	if ToHDFirearm(self):IsReloading() then

		local smoke = CreateMOSParticle("XM Smoke " .. math.random(3), "Psyclones.rte");
		smoke.Pos = self.MuzzlePos;
		smoke.Vel = (self.Vel * math.random()) + Vector(math.random(),0):RadRotate(math.random()*(math.pi*2));
		MovableMan:AddParticle(smoke);
	end
end