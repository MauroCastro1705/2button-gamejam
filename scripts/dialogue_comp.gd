extends Node
class_name dia_comp
@export var dialogue: Array[dialogue_string]
@export var after_effs: Array[Node]
var str_count: int = 0
var name_node: Label
var text_node: Label
var textb: ColorRect
var bg_node: NinePatchRect
var sprite_node: NinePatchRect
var plr: CharacterBody3D
var batya: dia_area
@export var disable: bool = false
@export var shape: CollisionShape3D
func set_plr(_plr):
	plr = _plr
	name_node = plr.get_node("textbox_root/textb/name")
	text_node = plr.get_node("textbox_root/textb/text")
	bg_node = plr.get_node("textbox_root/background")
	sprite_node = plr.get_node("textbox_root/sprite")
func show():
	plr.get_node("SpringArm3D").spring_length = -0.2
	plr.get_node("SpringArm3D").look_at(get_parent().global_position)
	plr.get_node("SpringArm3D").rotation_degrees.x = 0
	plr.get_node("SpringArm3D").rotation_degrees.z = 0
	plr.go_fpv()
	plr.get_node("textbox_root").show()
	name_node.text = dialogue[str_count].namee
	if dialogue[str_count].sprite != null:
		sprite_node.texture = dialogue[str_count].sprite
	if dialogue[str_count].background != null:
		bg_node.texture = dialogue[str_count].background
	name_node.text = dialogue[str_count].namee
	if dialogue[str_count].stop_movement:
		plr.canmove = false
		#plr.hide()
		#plr.get_node("%fps_cam").current = true
	else:
		plr.canmove = true
		#plr.get_node("%main_cam").current = true
		#plr.show()
	text_node.text = dialogue[str_count].text
	if after_effs[str_count] != null:
		after_effs[str_count].use(plr)
	str_count += 1
func hide():
	plr.go_thpv()
	#plr.show()
	#plr.get_node("%main_cam").current = true
	str_count = 0
	plr.get_node("textbox_root").hide()
	name_node.text = ""
	name_node.name = ""
	plr.canmove = true
	if disable:
		batya.can_int = false
		if batya.get_node("CollisionShape3D") != null:
			batya.get_node("CollisionShape3D").disabled = true
func check_what_to_do():
	if str_count < dialogue.size():
		show()
	else:
		hide()
