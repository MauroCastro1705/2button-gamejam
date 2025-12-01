extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

const MAIN_MENU = "res://scenes/menu/main_menu.tscn"

func _ready() -> void:
	animation_player.play("fade_in")
	timer.start()
	
	

func _on_timer_timeout() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(MAIN_MENU)

	
