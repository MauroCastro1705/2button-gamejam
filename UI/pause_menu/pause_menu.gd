extends Control
const MAIN_MENU_SCENE := "res://scenes/menu/menu.tscn"
@onready var pause_menu: Control = $"."

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_volver_pressed() -> void:
	pause_menu.visible = false
