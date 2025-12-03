extends Node

signal combat_mode
signal travel_mode
signal update_score
signal golem_damaged
signal ammo_used
signal golem_died

enum CamMode { TRAVEL, COMBAT }
var cam_mode: CamMode = CamMode.TRAVEL
var golem_life:int = 30
var player_life:int = 50
var player_ammo_A:int = 4
var player_ammo_D:int = 2

var score:int

func _ready() -> void:
	combat_mode.connect(_change_to_combat)
	travel_mode.connect(_change_to_travel_mode)
	update_score.connect(_update_player_score)
	golem_died.connect(_end_combat_mode)
	
	score = 0
	
	
func _change_to_combat():
	cam_mode = CamMode.COMBAT
	print("changed to combat mode")

func _end_combat_mode():
	emit_signal("travel_mode")
	_change_to_travel_mode()

func _change_to_travel_mode():
	cam_mode = CamMode.TRAVEL
	print("_change_to_travel_mode")

func _update_player_score():
	print("score +1")
	score += 1

func _update_player_score_golem():
	score += 10

func _handle_golem_damage(value:int):
	if golem_life < 1 :
		return
	else:
		golem_life -= value
		print("golem life: " + str(golem_life))
		emit_signal("golem_damaged")
	if golem_life == 0:
		emit_signal("golem_died")





func _player_ammo_A_shoot():
	if player_ammo_A <= 0 :
		return
	else:
		player_ammo_A -= 1
		emit_signal("ammo_used")
	
func _player_ammo_D_shoot():
	if player_ammo_D <= 0 :
		return
	else:
		player_ammo_D -= 1
		emit_signal("ammo_used")
