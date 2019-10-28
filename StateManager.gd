extends Node

var ate_garlic = false
enum Bro {VAMPIRE, GHOST, SKELETON}
var person_following = Bro.VAMPIRE

func set_vampire_following():
	person_following = Bro.VAMPIRE

func set_skeleton_following():
	person_following = Bro.SKELETON

func set_ghost_following():
	person_following = Bro.GHOST

func dog_chase_skeleton():
	set_ghost_following()

func garlic_chase_vampire():
	set_skeleton_following()