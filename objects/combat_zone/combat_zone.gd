extends Area3D

@onready var evil_golem: Node3D = $"evil-golem"


var _target: Node3D
const ROTATE_SPEED := 6.0          # higher = faster turn
const YAW_OFFSET := PI * 0.5       # 90°: use -PI*0.5 if turning the wrong way; use PI if it's facing backwards

func _ready() -> void:
	Global.golem_died.connect(_combat_ended)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_target = body
		_combat_starts()

func _on_body_exited(body: Node3D) -> void:
	if body == _target:
		_target = null

func _physics_process(delta: float) -> void:
	handle_combat()
	if not _target:
		return
	handle_rotation(delta)


func _combat_starts() -> void:
	print("combat begins")
	Global.emit_signal("combat_mode")

func _combat_ended():
	Global._update_player_score_golem()
	queue_free()

func handle_rotation(delta):
	# Direction toward target on XZ plane
	var dir := _target.global_position - evil_golem.global_position
	dir.y = 0.0
	if dir.length_squared() < 0.000001:
		return

	# Desired yaw (add offset to account for the mesh's real "front")
	var desired_yaw := atan2(dir.x, dir.z) + YAW_OFFSET

	# Smooth yaw-only rotation (no scaling drift)
	var t = clamp(ROTATE_SPEED * delta, 0.0, 1.0)
	var current_yaw := evil_golem.global_rotation.y
	evil_golem.global_rotation.y = lerp_angle(current_yaw, desired_yaw, t)	

func handle_combat():
	# Only allow combat if the global camera mode is combat
	if Global.cam_mode != Global.CamMode.COMBAT:
		return
		
	if Input.is_action_just_pressed("button_one"):
		Global._handle_golem_damage(15)
		
	if Input.is_action_just_pressed("button_two"):
		Global._handle_golem_damage(10)
