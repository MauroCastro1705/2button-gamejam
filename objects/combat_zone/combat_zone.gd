extends Area3D
@onready var evil_golem: Node3D = $"evil-golem"
var _target: Node3D
const ROTATE_SPEED := 6.0   # higher = faster turn

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_target = body
		_combat_starts()

func _physics_process(delta: float) -> void:
	if _target:
		var from := evil_golem.global_transform
		var to := _desired_look_transform(from, _target)
		var t = clamp(ROTATE_SPEED * delta, 0.0, 1.0)
		evil_golem.global_transform = from.interpolate_with(to, t)

func _desired_look_transform(from: Transform3D, target: Node3D) -> Transform3D:
	var tp := target.global_position
	tp.y = from.origin.y
	var dir := (tp - from.origin).normalized()
	var baasis := Basis.looking_at(dir, Vector3.UP)
	return Transform3D(baasis, from.origin)

func _combat_starts():
	print("combat begins")
	Global.emit_signal("combat_mode")
