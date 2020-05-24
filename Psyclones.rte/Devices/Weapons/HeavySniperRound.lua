function Create(self)
	local Effect
	local Offset = self.Vel*(20*TimerMan.DeltaTimeSecs)	-- the effect will be created the next frame so move it one frame backwards towards the barrel
	
	-- bullets
	for i = 1, 13 do
		if i > 3 then
			Effect = CreateMOPixel("XM-92B Heavy Sniper Particle No Glow", "Psyclones.rte")
		else
			Effect = CreateMOPixel("XM-92B Heavy Sniper Particle", "Psyclones.rte")
		end
		if Effect then
			Effect.Vel = self.Vel
			Effect.Pos = self.Pos + Offset * 0.25	-- place the MOPixels in front of the MOSRotating
			Effect.Team = self.Team
			Effect.IgnoresTeamHits = true
			MovableMan:AddParticle(Effect)
		end
	end
end

function Update(self)
	local Effect
	local Offset = self.Vel*(20*TimerMan.DeltaTimeSecs)	-- the effect will be created the next frame so move it one frame backwards towards the barrel
	
	-- smoke trail
	local trailLength = math.floor(Offset.Magnitude + 0.5)
	for i = 1, 100, 7 do
		Effect = CreateMOPixel("Green glow trail", "Psyclones.rte")
		if Effect then
			Effect.Pos = self.Pos - Offset * (i/trailLength)
			Effect.Vel = self.Vel
			MovableMan:AddParticle(Effect)
		end
	end
end
