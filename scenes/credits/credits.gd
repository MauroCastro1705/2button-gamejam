extends Node2D
const MAIN_MENU := "res://scenes/menu/main_menu.tscn"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("button_one"):
		go_back()

func go_back():
	get_tree().change_scene_to_file(MAIN_MENU)
