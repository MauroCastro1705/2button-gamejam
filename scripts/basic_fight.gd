extends Area3D
class_name fight
@export var dia: dia_comp
var can_int: bool = false
func _ready() -> void:
	connect("body_entered", plr_enter)
	connect("body_exited", plr_exit)
func plr_enter(body):
	print("AFAFAWFWAGFFF")
	if body.is_in_group("player"):
		can_int = true
		dia.set_plr(body)
		dia.batya = self
		dia.check_what_to_do()
func plr_exit(body):
	if body.is_in_group("player"):
		can_int = false
		dia.hide()
		dia.plr = null
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("button_two") and can_int:
		dia.check_what_to_do()
