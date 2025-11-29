extends CharacterBody3D

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed := 250.0
@export var jump_strength := 7.0

var movement_velocity: Vector3

@onready var model := $Character
@onready var animation := $Character/AnimationPlayer


func _physics_process(delta: float) -> void:
	handle_controls(delta)

	velocity = velocity.lerp(movement_velocity, delta * 10.0)
	move_and_slide()

	if position.y < -10.0:
		get_tree().reload_current_scene()

	model.scale = model.scale.lerp(Vector3.ONE, delta * 10.0)


func handle_controls(delta: float) -> void:
	# Only allow movement if the global camera mode is SIDE
	if Global.cam_mode == Global.CamMode.SIDE:
		var input_dir := Vector3.ZERO

		var forward_input := Input.get_axis("move_forward", "move_back")
		input_dir.z = forward_input

		if input_dir.length() > 1.0:
			input_dir = input_dir.normalized()

		movement_velocity = input_dir * movement_speed * delta
	else:
		# Stop movement completely in other modes (like OTS)
		movement_velocity = Vector3.ZERO
