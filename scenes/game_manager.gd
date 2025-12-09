extends Node3D
@onready var game_timer: Timer = $game_timer
const WIN_SCENE = preload("res://scenes/win_scene/win_scene.tscn")


func _ready() -> void:
	Global.golem_died.connect(_check_status)
	
	
func _check_status():
	if Global.golems_killed >= 3:
		print("game finished")
		game_timer.start()
		
func _on_game_timer_timeout() -> void:
	get_tree().change_scene_to_packed(WIN_SCENE)
