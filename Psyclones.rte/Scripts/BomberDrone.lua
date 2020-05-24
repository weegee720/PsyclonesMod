--print ("Reloadin")

dofile("Psyclones.rte/Scripts/BomberDrone_Create.lua")
dofile("Psyclones.rte/Scripts/BomberDrone_Update.lua")

function Create(self)
	do_create_bomberdrone(self)
end

function Update(self)
	do_update_bomberdrone(self)
end
