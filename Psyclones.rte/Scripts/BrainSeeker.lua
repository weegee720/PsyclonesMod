--print ("Reloadin")

dofile("Psyclones.rte/Scripts/BrainSeeker_Create.lua")
dofile("Psyclones.rte/Scripts/BrainSeeker_Update.lua")

function Create(self)
	do_create_brainseeker(self)
end

function Update(self)
	do_update_brainseeker(self)
end
