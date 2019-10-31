extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "body_entered")

func body_entered(body):
	if "id" in body and body.id == "ghost" and body.is_in_fan:
		StateManager.set_ghost_flee()