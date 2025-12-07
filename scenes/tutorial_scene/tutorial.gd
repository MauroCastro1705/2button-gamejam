extends Node2D

const NEXT_SCENE := "res://scenes/new_main_scene.tscn" 
@onready var deploy_bar: ProgressBar = %DeployBar
const HOLD_ACTION := "button_one"
const HOLD_TIME := 5.0

var hold_time: float = 0.0
var scene_changing: bool = false


func _ready() -> void:
	deploy_bar.value = 0
	if deploy_bar.max_value <= 0:
		deploy_bar.max_value = 100


func _process(delta: float) -> void:
	if scene_changing:
		return

	if Input.is_action_pressed(HOLD_ACTION):
		hold_time += delta
	else:
		if hold_time > 0.0:
			hold_time = 0.0

	var progress = clamp(hold_time / HOLD_TIME, 0.0, 1.0)
	deploy_bar.value = progress * deploy_bar.max_value

	if hold_time >= HOLD_TIME:
		scene_changing = true
		next_scene()



func next_scene():
	get_tree().change_scene_to_file(NEXT_SCENE)
