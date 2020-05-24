function do_update(self)
	if MovableMan:IsActor(self.ThisActor) then
		-- Draw power marker
		local power = Psyclones_GetFullPower(self.ThisActor, self.BasePower)
		local glownum = math.ceil(power / 2)
		
		if glownum > 0 and glownum < 6 then
			--local pix = CreateMOPixel("Purple Glow 0"..glownum);
			local pix = CreateMOPixel("Purple Glow 05");
			pix.Pos = self.Pos
			MovableMan:AddParticle(pix);
		end
	end
end