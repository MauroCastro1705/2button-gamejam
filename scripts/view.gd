extends Node3D

@export_group("Target & Camera")
@export var target: Node3D
@onready var camera: Camera3D = $Camera

@export_group("Offsets")
@export var side_offset := Vector3(8.0, 3.0, 0.0)    # right of player, a bit above
@export var ots_offset  := Vector3(0.0, 2.0, -4.0)   # behind player, a bit above

@export_group("Smoothing")
@export_range(0.0, 20.0, 0.1) var follow_speed := 8.0  # higher = snappier
@export var look_at_target := true

enum CamMode { SIDE, OTS }
var mode: CamMode = CamMode.SIDE

func _ready() -> void:
	_apply_instant()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_toggle"):
		mode = CamMode.OTS if mode == CamMode.SIDE else CamMode.SIDE
		# If you want instant snapping on toggle, uncomment the next line:
		# _apply_instant()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	var toffset := _get_current_offset()
	var t := target.global_transform

	# Desired world position using target's local axes so OTS stays behind facing direction.
	var desired_pos := t.origin \
		+ t.basis.x * toffset.x \
		+ t.basis.y * toffset.y \
		+ t.basis.z * toffset.z

	# Smooth follow (exponential-ish).
	var alpha := 1.0 - pow(0.001, follow_speed * delta)
	camera.global_position = camera.global_position.lerp(desired_pos, alpha)

	if look_at_target:
		camera.look_at(t.origin, Vector3.UP)

func _get_current_offset() -> Vector3:
	match mode:
		CamMode.SIDE:
			return side_offset
		CamMode.OTS:
			return ots_offset
		_:
			return Vector3.ZERO  # Fallback to satisfy analyzer and avoid runtime issues

func _apply_instant() -> void:
	if not is_instance_valid(target):
		return
	var toffset := _get_current_offset()
	var t := target.global_transform
	var pos := t.origin \
		+ t.basis.x * toffset.x \
		+ t.basis.y * toffset.y \
		+ t.basis.z * toffset.z
	camera.global_position = pos
	if look_at_target:
		camera.look_at(t.origin, Vector3.UP)
