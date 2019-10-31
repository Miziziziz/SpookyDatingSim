extends Node

var ate_garlic = false
enum Bro {VAMPIRE, GHOST, SKELETON}
var person_following = Bro.VAMPIRE

var vampire = null
var ghost = null
var skeleton = null
var dog = null

func set_vampire_following():
	person_following = Bro.VAMPIRE

func set_skeleton_following():
	person_following = Bro.SKELETON
	skeleton.set_pursue_state()
	skeleton.talk_when_near = true

func set_ghost_following():
	ghost.set_pursue_state()
	person_following = Bro.GHOST
	ghost.talk_when_near = true

func dog_chase_skeleton():
	skeleton.set_flee_state()
	dog.player = skeleton
	dog.set_pursue_state()
	set_ghost_following()

func garlic_chase_vampire():
	set_skeleton_following()

func ate_garlic():
	ate_garlic = true

func set_vampire_flee():
	vampire.set_flee_state()
	set_skeleton_following()

func set_ghost_flee():
	ghost.set_flee_state()
	person_following = null

func vampire_following():
	return person_following == Bro.VAMPIRE

func skeleton_following():
	return person_following == Bro.SKELETON

func ghost_following():
	return person_following == Bro.GHOST

func set_complete():
	print("game won")