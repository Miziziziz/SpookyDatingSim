extends Label

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("continue"):
		get_tree().change_scene("res://MainScene.tscn")
