extends Camera3D
# Replacement for Godot 3's InterpolatedCamera: eases toward the target node's transform.

@export var target: NodePath
@export var speed := 1.0

@onready var _target_node: Node3D = get_node_or_null(target)

func _process(delta):
	if _target_node == null:
		return
	var w = clampf(delta * speed, 0.0, 1.0)
	global_transform = global_transform.interpolate_with(_target_node.global_transform, w)
