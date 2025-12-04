extends Area3D

@onready var evil_golem: Node3D = $enemy_Golem
@onready var ring_shader: MeshInstance3D = %"ring shader"
@onready var light_hit: GPUParticles3D = $LightHit
@onready var heavy_hit: GPUParticles3D = $heavyHit



var golem_life_local:int
var _target: Node3D
var _connected_to_damage := false
signal local_golem_damaged
const ROTATE_SPEED := 6.0
const YAW_OFFSET := PI * 0.5

func _ready() -> void:
	golem_life_local = Global.golem_life
	ring_shader.hide()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_target = body
		_combat_starts()
		ring_shader.show()

func _on_body_exited(body: Node3D) -> void:
	if body == _target:
		_target = null
		_combat_ended(false) # left zone, not killed

func _physics_process(delta: float) -> void:
	if not _target:
		return
	handle_rotation(delta)

func _combat_starts() -> void:
	ring_shader.show()
	await get_tree().process_frame
	if not _connected_to_damage:
		Global.golem_damage.connect(_on_golem_damage)
		_connected_to_damage = true
	# Find the HUD and tell it which zone is active
	var hud = get_tree().get_first_node_in_group("HUD")
	if hud:
		hud.set_enemy_zone(self)

	Global.emit_signal("combat_mode")

func _combat_ended(killed: bool) -> void:
	if _connected_to_damage:
		if Global.golem_damage.is_connected(_on_golem_damage):
			Global.golem_damage.disconnect(_on_golem_damage)
		_connected_to_damage = false
	if killed:
		Global._update_player_score_golem()
		ring_shader.hide()
	#heavy_hit.emitting = true
	#await heavy_hit.finished
	queue_free()  # remove this zone (and its enemy)

func _on_golem_damage(amount:int) -> void:
	golem_life_local -= amount
	#light_hit.emitting = true
	emit_signal("local_golem_damaged")  # tell the UI to refresh
	if golem_life_local <= 0:
		_combat_ended(true)
		Global.golem_died.emit()

func handle_rotation(delta: float) -> void:
	ring_shader.show()
	var dir := _target.global_position - evil_golem.global_position
	dir.y = 0.0
	if dir.length_squared() < 0.000001:
		return
	var desired_yaw := atan2(dir.x, dir.z) + YAW_OFFSET
	var t = clamp(ROTATE_SPEED * delta, 0.0, 1.0)
	var current_yaw := evil_golem.global_rotation.y
	evil_golem.global_rotation.y = lerp_angle(current_yaw, desired_yaw, t)
