extends Node3D

@export_group("Target & Camera")
@export var target: Node3D
@onready var camera: Camera3D = $Camera

@export_group("Offsets")
@export var travel_offset := Vector3(0, 3.0, 8.0)   # 3rd-person follow
@export var combat_offset := Vector3(0, 20.0, 20.0) # higher + farther = isometric

@export_group("Smoothing")
@export_range(0.0, 20.0, 0.1) var follow_speed := 8.0
@export var look_at_target := true
@export var ots_look_ahead := 10.0

var mode: Global.CamMode = Global.CamMode.TRAVEL

func _ready() -> void:
	if not is_instance_valid(target):
		push_warning("Camera target is not assigned in inspector")
	# aseguramos que esta cámara sea la activa
	camera.current = true
	
	_apply_instant()
	
	Global.combat_mode.connect(_camera_combat)
	Global.travel_mode.connect(_camera_travel)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return  # no hacemos nada si no hay target

	var t := target.global_transform
	var toffset := _get_current_offset()

	var desired_pos := t.origin \
		+ t.basis.x * toffset.x \
		+ t.basis.y * toffset.y \
		+ t.basis.z * toffset.z

	# Smooth follow
	var alpha := 1.0 - pow(0.001, follow_speed * delta)
	camera.global_position = camera.global_position.lerp(desired_pos, alpha)

	# Look-at behavior
	match mode:
		Global.CamMode.TRAVEL:
			if look_at_target:
				camera.look_at(t.origin, Vector3.UP)
		Global.CamMode.COMBAT:
			camera.look_at(t.origin, Vector3.UP)

func _get_current_offset() -> Vector3:
	match mode:
		Global.CamMode.TRAVEL:
			return travel_offset
		Global.CamMode.COMBAT:
			return combat_offset
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
	camera.look_at(t.origin, Vector3.UP)

# -------------------------
# CAMERA MODE SIGNALS
# -------------------------
func _camera_combat() -> void:
	mode = Global.CamMode.COMBAT
	camera.rotation_degrees = Vector3(45, 45, 0)
	_apply_instant()

func _camera_travel() -> void:
	mode = Global.CamMode.TRAVEL
	camera.rotation_degrees = Vector3.ZERO
	_apply_instant()
