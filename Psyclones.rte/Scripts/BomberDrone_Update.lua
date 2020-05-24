function do_update_bomberdrone(self)
	-- Don't do anything when in edit mode
	if ActivityMan:GetActivity().ActivityState ~= Activity.RUNNING then
		return
	end

	if MovableMan:IsActor(self.ThisActor) then
		if not self.Active then
			if self.Timer:IsPastSimMS(self.ActivationDelay) then
				self.Active = true
				self.Timer:Reset()
			end
		else
			if self.Timer:IsPastSimMS(self.ShootDelay) then
				if self.Inventory then
					if SceneMan:FindAltitude(self.Pos, 0, 10) <= self.DeployAltitude then
						for i = 1, 2 do
							if self.ShootoutCounter <= #self.InventoryPresets then
								-- Shoot out ordnance
								
								if self.InventoryClasses[self.ShootoutCounter] == "TDExplosive" then
									local expl = CreateTDExplosive(self.InventoryPresets[self.ShootoutCounter])
									if expl then
										-- Shoot from the left
										if i == 1 then
											expl.Pos = self.ThisActor.Pos + Vector(-25, 0)
											expl.Vel = Vector(-self.CurrentVel, 0)
										end
										-- Shoot from the right
										if i == 2 then
											expl.Pos = self.ThisActor.Pos + Vector(25, 0)
											expl.Vel = Vector(self.CurrentVel, 0)
										end
										MovableMan:AddItem(expl)
									end
								end
								
								self.ShootoutCounter = self.ShootoutCounter + 1
								
								if self.ShootoutCounter >= #self.InventoryPresets then
									self.ThisActor.AIMode = Actor.AIMODE_RETURN;
								end
							end
						end
							
						self.CurentVel = self.CurrentVel - self.VelStep;
						if self.CurrentVel <= self.VelStep then
							self.CurrentVel = self.InitialVel
						end
					end
				end
			
				self.Timer:Reset();
			end

			-- Return to orbit
			if self.ShootoutCounter >= #self.InventoryPresets then
				self.ThisActor:GetController():SetState(Controller.MOVE_UP, true)
			end
		end
	end
end