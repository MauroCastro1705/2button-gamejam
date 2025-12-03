extends CharacterBody3D

@export_subgroup("Components")
@export var move_speed: float = 2.0
@export var turn_speed_deg: float = 180.0# degrees per second when held
@export var snap_turn_deg: float = 0.0# set (e.g. 45) to use discrete snap turns on tap; 0 = smooth turning
@export var canmove: bool = true
@onready var model: Node3D = $player_Golem

func _physics_process(delta: float) -> void:
	handle_controls(delta)
	handle_combat()
	

func handle_controls(delta: float) -> void:
	# Only allow movement if the global camera mode is SIDE
	if Global.cam_mode != Global.CamMode.TRAVEL:
		return
	if canmove:
	# --- Turning ---
	## Two modes: smooth (hold to rotate) or snap (press to rotate by fixed angle)
		if snap_turn_deg > 0.0:
			if Input.is_action_just_pressed("button_two"):
				rotate_y(-deg_to_rad(snap_turn_deg))  # left
			if Input.is_action_just_pressed("button_one"):
				rotate_y( deg_to_rad(snap_turn_deg))  # right
		else:
			var turn_dir := int(Input.is_action_pressed("button_one")) - int(Input.is_action_pressed("button_two"))
			if turn_dir != 0:
				rotate_y(deg_to_rad(turn_speed_deg) * turn_dir * delta)

		var forward := -transform.basis.z
		forward.y = 0.0
		forward = forward.normalized()

		var target_vel := forward * move_speed
		velocity.x = target_vel.x
		velocity.z = target_vel.z
		move_and_slide()

func handle_combat():
	# Only allow combat if the global camera mode is combat
	if Global.cam_mode != Global.CamMode.COMBAT:
		return
		
	if Input.is_action_just_pressed("button_one"):
		Global._player_ammo_A_shoot()
		Global._handle_golem_damage(15)
		
	if Input.is_action_just_pressed("button_two"):
		Global._player_ammo_D_shoot()
		Global._handle_golem_damage(10)
