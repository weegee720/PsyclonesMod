function do_update_drophsipseeker(self)
	local boom = false;

	if MovableMan:IsActor(self.ThisActor) then
		if self.ThisActor.AIMode ~= Actor.AIMODE_SENTRY then
			self.ThisActor.AIMode = Actor.AIMODE_SENTRY
		end
		if not self.IsTriggered then
			self.ThisActor:GetController():SetState(Controller.BODY_CROUCH, true)
			self.ThisActor:GetController():SetState(Controller.MOVE_LEFT, false)
			self.ThisActor:GetController():SetState(Controller.MOVE_RIGHT, false)
			self.ThisActor:GetController():SetState(Controller.MOVE_UP, false)
			self.ThisActor:GetController():SetState(Controller.MOVE_DOWN, false)
			self.ThisActor:GetController():SetState(Controller.BODY_JUMP, false)
			self.ThisActor.Vel = Vector(self.ThisActor.Vel.X / 2, self.ThisActor.Vel.Y / 1.55)
		end
		
		if self.ThisActor.Health > 0 then
			self.ThisActor.RotAngle = 0
		end
		
		-- Check for any other actors
		for actor in MovableMan.Actors do
			if actor.Team ~= self.ThisActor.Team and actor.ClassName == "ACDropShip" or actor.ClassName == "ACRocket" then
				local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
				
				if d < self.ImpactRange and self.IsTriggered then
					boom = true
				end
				
				-- Find dropships in range
				if not self.IsTriggered and d < self.Range then
					-- Check visibility
					local visible = false;
					local threat = nil
					
					local angle = Psyclones_GetAngle(self.ThisActor.Pos, actor.Pos)
					local pos = self.Pos + Vector(math.cos(-angle) * 20, math.sin(-angle) * 20)

					-- To improve enemy visibility cast rays across the whole craft from left to right
					local offsets = {Vector(-20,0), Vector(0,-7), Vector(0,0), Vector(0,7), Vector(20,0)}
					
					for i = 1, #offsets do
						local actorpos = pos
						local vectortoactor = actor.Pos + offsets[i] - actorpos;
						local moid = SceneMan:CastMORay(actorpos , vectortoactor , self.ThisActor.ID , self.ThisActor.Team , -1, false , 4);
						local mo = MovableMan:GetMOFromID(moid);
						
						if mo ~= nil then
							if mo.ClassName == "ACDropShip" or mo.ClassName == "ACRocket" then
								threat = mo
							else
								local mo = MovableMan:GetMOFromID(mo.RootID);
								if mo ~= nil then
									if mo.ClassName == "ACDropShip" or mo.ClassName == "ACRocket" then
										self.Threat = mo
									end
								end
							end
						end -- if
					end -- for
					
					if threat ~= nil then
						self.IsTriggered = true;
						
						--self.ThisActor.Vel = Vector(math.cos(angle) * self.Impulse, math.sin(angle) * self.Impulse), Vector(0,0)
						self.ThisActor.Vel = Vector(math.cos(-angle) * d / 10, math.sin(-angle) * d / 10)
						Psyclones_AddPsyEffect(self.ThisActor.Pos)
						self.ResetTimer:Reset();
						break;
					end
				end
			end
		end
		
		if self.IsTriggered then
			if self.ResetTimer:IsPastSimMS(1000) then
				self.IsTriggered = false;
			end
		end

		
		-- Do emission
		if self.IsTriggered then
			if self.emitTimer:IsPastSimMS(35) then
				self.emitTimer:Reset();

				local angle = math.pi * 2 * math.random()
				
				local pos = self.Pos + Vector(math.cos(angle) * 30, math.sin(angle) * 30);
				if SceneMan:GetTerrMatter(pos.X, pos.Y) == 0 then
					local damagePar = CreateMOPixel("Small Wormhole Emission Particle "..math.random(2));
					
					damagePar.Pos = pos;
					damagePar.Vel = Vector(-(math.cos(angle) * 30), -(math.sin(angle) * 30));
					damagePar.Team = self.Team;
					damagePar.IgnoresTeamHits = true;
					MovableMan:AddParticle(damagePar);
				end
			end
		
			local pix = CreateMOPixel("Purple Glow ".. math.random(11));
			pix.Pos = self.ThisActor.Pos
			MovableMan:AddParticle(pix);
		end
		
		if boom then
			self.ThisActor.Health = 0
			
			for i = 1, 1 do 
				local pix = CreateMOSRotating("Terrain Eat Explosion");
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