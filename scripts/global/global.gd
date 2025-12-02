extends Node

signal combat_mode
signal travel_mode
signal update_score

enum CamMode { SIDE, OTS }
var cam_mode: CamMode = CamMode.SIDE

var score:int

func _ready() -> void:
	combat_mode.connect(_change_to_combat)
	travel_mode.connect(_change_to_travel_mode)
	update_score.connect(_update_player_score)
	score = 0
	
	
func _change_to_combat():
	cam_mode = CamMode.OTS
	print("changed to combat mode")
	
func _change_to_travel_mode():
	cam_mode = CamMode.SIDE
	print("_change_to_travel_mode")

func _update_player_score():
	print("score +1")
	score += 1
