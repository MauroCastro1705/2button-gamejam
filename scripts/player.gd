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
	model.scale = model.scale.lerp(Vector3.ONE, delta * 10.0)
func handle_controls(delta: float) -> void:
	# Only allow movement if the global camera mode is SIDE
	if Global.cam_mode == Global.CamMode.SIDE:
		var input_dir = Input.get_vector("1", "2", "4", "3")
		input_dir.y = -1
		var direction = (transform.basis * Vector3(-input_dir.x, 0, input_dir.y))
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
		move_and_slide()
		if Input.is_action_pressed("button_one"):
			rotation_degrees.y += 1
		if Input.is_action_pressed("button_two"):
			rotation_degrees.y -= 1
