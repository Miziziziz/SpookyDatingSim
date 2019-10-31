extends KinematicBody

const ray_length = 1000000

var path = PoolVector3Array()
var move_speed = 3
var thing_to_interact_with = null
var interact_range = 1.2

onready var anim = $Graphics/AnimationPlayer
onready var cam = get_node("../InterpolatedCamera")
onready var nav = get_parent().get_parent()

func _physics_process(delta):
	var dir = Vector3()
	if thing_to_interact_with:
		var dis = thing_to_interact_with.global_transform.origin.distance_to(global_transform.origin)
		if dis < interact_range:
			path = PoolVector3Array()
			thing_to_interact_with.interact()
			thing_to_interact_with = null
	if len(path) > 0:
		play_anim("bounce")
		var our_pos = global_transform.origin
		dir = (path[0] - our_pos)
		dir.y = 0
		var dis = dir.length()
		dir = dir.normalized()
		if dis < 0.1:
			path.remove(0)
		move_and_collide(dir * move_speed * delta)
		dir.y = 0
		$Graphics.rotation.y = atan2(dir.x, dir.z)
	else:
		play_anim("still")
	global_transform.origin.y = 0

func play_anim(anim_name):
	if anim.current_animation != anim_name:
		anim.play(anim_name, 0.1)

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("click") and !ConvoManager.dialog_being_shown:
		var thing_under_mouse = get_thing_under_mouse()
		if thing_under_mouse and thing_under_mouse.has_method("interact"):
			var goal_pos = thing_under_mouse.global_transform.origin
			goal_pos.y = 0
			path = nav.get_simple_path(global_transform.origin, goal_pos)
			path.remove(0)
			thing_to_interact_with = thing_under_mouse
		else:
			path = nav.get_simple_path(global_transform.origin, get_point_under_mouse())
			path.remove(0)
			thing_to_interact_with = null
			
func get_thing_under_mouse():
	var m_pos = get_viewport().get_mouse_position()
	var from = cam.project_ray_origin(m_pos)
	var to = from + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to)
	if result:
		return result.collider
	return null

func get_point_under_mouse():
	var m_pos = get_viewport().get_mouse_position()
	var from = cam.project_ray_origin(m_pos)
	var to = from + cam.project_ray_normal(m_pos) * ray_length
	
	var n = Vector3(0, 1, 0) #ground plane normal
	var p = Vector3(0, 0.0, 0) #base of plane to intersect,
	#ray plane intersection equation
	var t_d_n = to.dot(n)
	var t = (p - from).dot(n) / t_d_n
	return t * to + from

func move_to_point():
	pass