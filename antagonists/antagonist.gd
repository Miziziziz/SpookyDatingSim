extends KinematicBody

export var id = ""
var player = null
var flee_point = Vector3() #TODO

enum State {STILL, PURSUE, FLEE}
var state = State.STILL

var move_speed = 3
var pursue_distance = 1.5

var path = []
onready var nav = get_parent()

export var talk_when_near = false
var is_in_fan = false
var fan = null
var fan_force = 2

func _ready():
	StateManager[id] = self
	player = get_tree().get_nodes_in_group("player")[0]
	flee_point = get_tree().get_nodes_in_group("flee_point")[0].global_transform.origin
	if id == "vampire":
		state = State.PURSUE

func interact():
	ConvoManager.display_dialog(id)

func _physics_process(delta):
	if state == State.STILL:
		return
	
	if is_in_fan:
		var dir_from_fan = (global_transform.origin - fan.global_transform.origin).normalized()
		move_and_collide(dir_from_fan * fan_force * delta)
		global_transform.origin.y = 0
		return
	
	if state == State.PURSUE:
		var our_pos = global_transform.origin
		var player_pos = player.global_transform.origin
		
		rotation.y = atan2(player_pos.x - our_pos.x, player_pos.z - our_pos.z)
		
		path = nav.get_simple_path(our_pos, player_pos)
		path.remove(0)
		var dir_to_player = player_pos - our_pos
		var dis_to_player = dir_to_player.length()
		dir_to_player = dir_to_player.normalized()
		if dis_to_player < pursue_distance:
			if talk_when_near:
				talk_when_near = false
				ConvoManager.display_dialog(id)
			move_and_collide(-dir_to_player*(1.0 - dis_to_player / pursue_distance) * move_speed * delta)
			global_transform.origin.y = 0
			return
	
	if path.size() > 0:
		var path_point = path[0]
		var our_pos = global_transform.origin
		path_point.y = 0
		var dir = path_point - our_pos
		var dis = dir.length()
		dir = dir.normalized()
		if dis < 0.1:
			path.remove(0)
		move_and_collide(dir * move_speed * delta)
		if state == State.FLEE:
			var player_pos = player.global_transform.origin
			rotation.y = atan2(path_point.x - our_pos.x, path_point.z - our_pos.z)
	else:
		if state == State.FLEE:
			pass
	global_transform.origin.y = 0
	

func set_pursue_state():
	state = State.PURSUE

func set_flee_state():
	state = State.FLEE
	path = nav.get_simple_path(global_transform.origin, flee_point)
