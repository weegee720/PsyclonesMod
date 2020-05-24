--print ("Reloadin")

dofile("Psyclones.rte/Scripts/DropshipSeeker_Create.lua")
dofile("Psyclones.rte/Scripts/DropshipSeeker_Update.lua")

function Create(self)
	do_create_drophsipseeker(self)
end

function Update(self)
	do_update_drophsipseeker(self)
end
