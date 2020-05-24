print ("Reloadin")

dofile("Psyclones.rte/Scripts/Psycho_Create.lua")
dofile("Psyclones.rte/Scripts/Psycho_Update.lua")

function Create(self)
	do_create(self)
end

function Update(self)
	do_update(self)
end
