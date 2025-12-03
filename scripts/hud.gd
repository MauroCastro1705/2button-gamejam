extends Control


@onready var tutorial: Label = $tutorial
@onready var score: Label = $score
@onready var combat_hud: Control = $CombatHud
@onready var walk_label: Label = $DEBUG/walk
@onready var mode_label: Label = $DEBUG/mode
@onready var wpn_1: Label = %wpn1
@onready var wpn_2: Label = %wpn2
@onready var ammo: VBoxContainer = $ammo


func _ready() -> void:
	_update_ui()
	_update_ammo()
	Global.update_score.connect(_update_ui)
	Global.ammo_used.connect(_update_ammo)
	combat_hud.hide()
	ammo.hide()

func _process(_delta: float) -> void:
	_update_ui()

func _update_ui() -> void:
	var is_side := Global.cam_mode == Global.CamMode.TRAVEL

	# WALK info
	if is_side:
		walk_label.text = "Walk: Yes"
		walk_label.add_theme_color_override("font_color", Color(0.6, 1.0, 0.6)) # greenish
	else:
		walk_label.text = "Walk: No"
		walk_label.add_theme_color_override("font_color", Color(1.0, 0.6, 0.6)) # reddish

	# MODE info
	if is_side:
		mode_label.text = "Mode: TRAVEL"
	else:
		mode_label.text = "Mode: COMBAT"
	
	if is_side:
		tutorial.text = "Steer with: A and D"
		combat_hud.hide()
		ammo.show()
	else:
		tutorial.text = "Attack with A and D"
		combat_hud.show()
		ammo.hide()
		
	score.text = "score: " + str(Global.score)
	
func _update_ammo():
	wpn_1.text = "wpn 1: " + str(Global.player_ammo_A)
	wpn_2.text = "wpn 2: " + str(Global.player_ammo_D)
