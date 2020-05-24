function do_update_brainseeker(self)
	if MovableMan:IsActor(self.ThisActor) then
		if self.ThisActor.AIMode ~= Actor.AIMODE_GOTO then
			-- Find nearest enemy brain
			local brain = nil
			local nearestenemydist = 1000000
			
			for actor in MovableMan.Actors do
				if actor.Team ~= self.ThisActor.Team then
					if actor:IsInGroup("Brains") and actor.Health > 0 then
						local d = SceneMan:ShortestDistance(actor.Pos, self.ThisActor.Pos, true).Magnitude;
						
						if d < nearestenemydist then
							brain = actor
							nearestenemydist = d;
						end
					end
				end
			end
			
			if brain ~= nil then
				self.ThisActor.AIMode = Actor.AIMODE_GOTO;			
				self.ThisActor:ClearAIWaypoints()
				self.ThisActor:AddAIMOWaypoint(brain)
				--self.ThisActor:AddAISceneWaypoint(brain.Pos)
				
				self.Target = brain
			end
		end
		
		self.ThisActor:GetController():SetState(Controller.BODY_CROUCH, false)
		
		if self.ThisActor.Health > 0 then
			self.ThisActor.RotAngle = 0
		end
		
		-- Kill unit when reached brain
		if self.Target ~= nil then
			local d = SceneMan:ShortestDistance(self.Target.Pos, self.ThisActor.Pos, true).Magnitude;
			
			if d  < 100 then
				self.ThisActor.Health = 0
			end
			
			--self.Target:FlashWhite(50);
		end
	end
end