extends Node3D

@export_group("Target & Camera")
@export var target: Node3D
@onready var camera: Camera3D = $Camera

@export_group("Offsets")
@export var side_offset := Vector3(8.0, 3.0, 0.0)   # right of player, a bit above
@export var ots_offset  := Vector3(0.0, 2.0, 6.0)   # +Z puts us BEHIND when using target's basis

@export_group("Smoothing")
@export_range(0.0, 20.0, 0.1) var follow_speed := 8.0
@export var look_at_target := true                 # used for SIDE; OTS overrides to look forward
@export var ots_look_ahead := 10.0                 # how far ahead to look in OTS


var mode: Global.CamMode = Global.CamMode.SIDE #in global for reference in other scripts

func _ready() -> void:
	_apply_instant()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_toggle"):
		# Toggle local mode
		mode = Global.CamMode.OTS if mode == Global.CamMode.SIDE else Global.CamMode.SIDE

		# Also update the global state
		Global.cam_mode = mode

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	var t := target.global_transform
	var toffset := _get_current_offset()

	# Build desired position in the target's LOCAL space (x: right, y: up, z: forward)
	var desired_pos := t.origin \
		+ t.basis.x * toffset.x \
		+ t.basis.y * toffset.y \
		+ t.basis.z * toffset.z

	# Smooth follow
	var alpha := 1.0 - pow(0.001, follow_speed * delta)
	camera.global_position = camera.global_position.lerp(desired_pos, alpha)

	# Aim behavior: SIDE looks at target; OTS looks forward with the player
	if mode == Global.CamMode.OTS:
		var forward := -t.basis.z.normalized()
		camera.look_at(camera.global_position + forward * ots_look_ahead, Vector3.UP)
	elif look_at_target:
		camera.look_at(t.origin, Vector3.UP)

func _get_current_offset() -> Vector3:
	match mode:
		Global.CamMode.SIDE:
			return side_offset
		Global.CamMode.OTS:
			return ots_offset
		_:
			return Vector3.ZERO

func _apply_instant() -> void:
	if not is_instance_valid(target):
		return
	var t := target.global_transform
	var toffset := _get_current_offset()
	var pos := t.origin \
		+ t.basis.x * toffset.x \
		+ t.basis.y * toffset.y \
		+ t.basis.z * toffset.z
	camera.global_position = pos

	# Same aiming logic as in _physics_process
	if mode == Global.CamMode.OTS:
		var forward := -t.basis.z.normalized()
		camera.look_at(camera.global_position + forward * ots_look_ahead, Vector3.UP)
	elif look_at_target:
		camera.look_at(t.origin, Vector3.UP)
