extends CharacterBody3D

@export_subgroup("Components")
@export var move_speed: float = 2.0
@export var turn_speed_deg: float = 180.0# degrees per second when held
@export var snap_turn_deg: float = 0.0# set (e.g. 45) to use discrete snap turns on tap; 0 = smooth turning
@export var canmove: bool = true
@onready var model: Node3D = $player_Golem
@onready var ring_shader: MeshInstance3D = $"ring shader"
@onready var ammo_label: Label3D = $player_Golem/ammo_label
@onready var ammo_timer: Timer = $ammo_timer

func _ready() -> void:
	ammo_label.hide()
	
func _physics_process(delta: float) -> void:
	handle_controls(delta)
	handle_combat()
	

func handle_controls(delta: float) -> void:
	# Only allow movement if the global camera mode is SIDE
	if Global.cam_mode != Global.CamMode.TRAVEL:
		return
	if canmove:
		ring_shader.hide()
		model._start_walk()
		
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
	if Global.cam_mode != Global.CamMode.COMBAT:
		return

	ring_shader.show()
	model._stop_walk()

	if Input.is_action_just_pressed("button_one"):
		if Global._player_ammo_A_shoot():
			model._shoot_anim()
			Global._handle_golem_damage(15)
		else:
			ammo_label_anim()
			
	if Input.is_action_just_pressed("button_two"):
		if Global._player_ammo_D_shoot():
			model._shoot_anim()
			Global._handle_golem_damage(10)
		else:
			ammo_label_anim()

func ammo_label_anim():
	ammo_label.show()
	ammo_timer.start()
	

func _on_ammo_timer_timeout() -> void:
	ammo_label.hide()
