extends StaticBody

onready var anim = $AnimationPlayer

func interact():
	if anim.is_playing():
		anim.stop(false)
	else:
		anim.play()

func _ready():
	$FanHead/FanPush.connect("body_entered", self, "body_entered")
	$FanHead/FanPush.connect("body_exited", self, "body_exited")

func body_entered(body):
	if "id" in body and body.id == "ghost":
		body.is_in_fan = true
		body.fan = self

func body_exited(body):
	if "id" in body and body.id == "ghost":
		body.is_in_fan = false