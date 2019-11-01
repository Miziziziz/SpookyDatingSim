extends KinematicBody

func interact():
	if StateManager.vampire_following() or StateManager.skeleton_following():
		ConvoManager.display_dialog("ghost_little_bro_pet")
	else:
		ConvoManager.display_dialog("ghost_little_bro")