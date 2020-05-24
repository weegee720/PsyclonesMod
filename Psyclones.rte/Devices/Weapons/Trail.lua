
function Update(self)
	local Effect
	local Offset = self.Vel*(20*TimerMan.DeltaTimeSecs)	-- the effect will be created the next frame so move it one frame backwards towards the barrel
	
	-- smoke trail
	local trailLength = math.floor(Offset.Magnitude+0.5)
	for i = 1, trailLength, 6 do
		Effect = CreateMOPixel("XM Trail Glow " .. math.random(5), "Psyclones.rte")
		if Effect then
			Effect.Pos = self.Pos - Offset * (i/trailLength) + Vector(RangeRand(-1, 1), RangeRand(-1, 1))
			Effect.Vel = self.Vel * math.random();
			MovableMan:AddParticle(Effect)
		end
	end
end
