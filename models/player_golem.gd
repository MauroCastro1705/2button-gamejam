extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

func _ready() -> void:
	pass
	
func _start_walk():
	animation_player.play("Walk")
	
func _stop_walk():
	animation_player.stop()

func _shoot_anim():
	animation_player_2.play("shoot_1")
