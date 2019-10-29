extends Node

var ate_garlic = false
enum Bro {VAMPIRE, GHOST, SKELETON}
var person_following = Bro.VAMPIRE

var vampire = null
var ghost = null
var skeleton = null

func set_vampire_following():
	person_following = Bro.VAMPIRE

func set_skeleton_following():
	person_following = Bro.SKELETON
	skeleton.set_pursue_state()
	ConvoManager.show()
	ConvoManager.display_dialog("skeleton")

func set_ghost_following():
	person_following = Bro.GHOST

func dog_chase_skeleton():
	set_ghost_following()

func garlic_chase_vampire():
	set_skeleton_following()

func ate_garlic():
	ate_garlic = true

func set_vampire_flee():
	vampire.set_flee_state()
	set_skeleton_following()