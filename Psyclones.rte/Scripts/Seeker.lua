--print ("Reloadin")

dofile("Psyclones.rte/Scripts/Seeker_Create.lua")
dofile("Psyclones.rte/Scripts/Seeker_Update.lua")

function Create(self)
	do_create_seeker(self)
end

function Update(self)
	do_update_seeker(self)
end
