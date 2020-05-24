function do_update_seeker(self)
	local boom = false;

	if MovableMan:IsActor(self.ThisActor) then
		if self.ThisActor.AIMode ~= Actor.AIMODE_GOTO then
			-- Find nearest enemy actor
			local brain = nil
			local nearestenemydist = 1000000
			
			for actor in MovableMan.Actors do
				if actor.Team ~= self.ThisActor.Team then
					if actor.Health > 0 then
						local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
						
						if d < nearestenemydist then
							brain = actor
							nearestenemydist = d;
						end
					end
				end
			end
			
			if brain ~= nil then
				if nearestenemydist > self.SeekRange then
					boom = true
				else
					self.ThisActor.AIMode = Actor.AIMODE_GOTO;			
					self.ThisActor:ClearAIWaypoints()
					self.ThisActor:AddAISceneWaypoint(brain.Pos)
					
					self.Target = brain
				end
			end
		end

		self.ThisActor:GetController():SetState(Controller.BODY_CROUCH, false)
		
		if self.ThisActor.Health > 0 then
			self.ThisActor.RotAngle = 0
		end
		
		-- Kill unit when reached brain
		if self.Target ~= nil and MovableMan:IsActor(self.Target) then
			local d = SceneMan:ShortestDistance(self.Target.Pos, self.ThisActor.Pos, true).Magnitude;
			
			if d  < self.Range or d > self.SeekRange then
				boom = true
			end
		else
			self.ThisActor.AIMode = Actor.AIMODE_SENTRY;
		end
		
		-- Check for any other actors
		for actor in MovableMan.Actors do
			if actor.Team ~= self.ThisActor.Team then
				if actor.Health > 0 then
					local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
					
					if d < self.Range then
						boom = true
					end
				end
			end
		end
		
		-- Do emission
		if self.Fuze then
			if self.Fuze:IsPastSimMS(500) then
				if self.emitTimer:IsPastSimMS(35) then
					self.emitTimer:Reset();

					local angle = math.pi * 2 * math.random()
					
					local pos = self.Pos + Vector(math.cos(angle) * 30, math.sin(angle) * 30);
					if SceneMan:GetTerrMatter(pos.X, pos.Y) == 0 then
						local damagePar = CreateMOPixel("Small Wormhole Emission Particle "..math.random(2), "Psyclones.rte");
						
						damagePar.Pos = pos;
						damagePar.Vel = Vector(-(math.cos(angle) * 30), -(math.sin(angle) * 30));
						damagePar.Team = self.Team;
						damagePar.IgnoresTeamHits = true;
						MovableMan:AddParticle(damagePar);
					end
				end
			end
		
			local pix = CreateMOPixel("Purple Glow ".. math.random(11), "Psyclones.rte");
			pix.Pos = self.ThisActor.Pos
			MovableMan:AddParticle(pix);
			
			if self.Fuze:IsPastSimMS(self.FuzeTime) or self.BlowNow then
				boom = true
			end
		end
		
		if boom then
			self.ThisActor.Health = 0
			
			for i = 1, 1 do 
				local pix = CreateMOSRotating("Terrain Eat Explosion", "Psyclones.rte");
				if pix then
					pix.Pos = self.ThisActor.Pos
					MovableMan:AddParticle(pix);
					pix:GibThis();
				end
			end
			
			self.ToDelete = true
		end
	end
end