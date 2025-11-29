extends CharacterBody3D

@export_subgroup("Components")
@export var view: Node3D  # Still here if needed for other things, not used for movement

@export_subgroup("Properties")
@export var movement_speed := 250.0
@export var jump_strength := 7.0

var movement_velocity: Vector3

@onready var model := $Character
@onready var animation := $Character/AnimationPlayer


func _physics_process(delta: float) -> void:
	handle_controls(delta)

	# Smooth velocity to make motion feel natural
	velocity = velocity.lerp(movement_velocity, delta * 10.0)
	move_and_slide()

	# Reset position if falling out of bounds
	if position.y < -10.0:
		get_tree().reload_current_scene()

	# Reset model scale (in case of jump squash/stretch)
	model.scale = model.scale.lerp(Vector3.ONE, delta * 10.0)


func handle_controls(delta: float) -> void:
	var input_dir := Vector3.ZERO

	# Move only along a single world axis (Z-axis)
	# "move_forward" moves -Z, "move_back" moves +Z
	var forward_input := Input.get_axis("move_forward", "move_back")
	input_dir.z = forward_input

	# Normalize input (just in case) and apply speed
	if input_dir.length() > 1.0:
		input_dir = input_dir.normalized()

	movement_velocity = input_dir * movement_speed * delta
