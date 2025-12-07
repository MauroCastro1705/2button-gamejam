extends Control

@onready var ammo_collected_hud: Control = $ammo_collected_hud
@onready var ammo_timer: Timer = %ammo_timer

@onready var combat_hud: Control = $CombatHud
@onready var wpn_1: Label = %wpn1
@onready var wpn_2: Label = %wpn2
@onready var ammo: VBoxContainer = $ammo
@onready var score: Label = %score
@onready var killed: Label = %killed
@onready var tutorial: Label = %tutorial
@onready var score_container: VBoxContainer = $score_container
@onready var score_texture: NinePatchRect = $score_texture
@onready var ammo_texture: NinePatchRect = $ammo_texture


func _ready() -> void:
	_update_ui()
	_update_ammo()
	Global.update_score.connect(_update_ui)
	Global.ammo_used.connect(_update_ammo)
	Global.ammo_pick.connect(_ammo_picked)
	ammo_collected_hud.hide()
	combat_hud.hide()
	ammo.hide()

func _process(_delta: float) -> void:
	_update_ui()

func _update_ui() -> void:
	var is_side := Global.cam_mode == Global.CamMode.TRAVEL
	if is_side:
		tutorial.text = "Steer with: A and D"
		combat_hud.hide()
		ammo.show()
		score_container.show()
		ammo_texture.show()
		score_texture.show()
	else:
		tutorial.text = " "
		combat_hud.show()
		ammo.hide()
		score_container.hide()
		ammo_texture.hide()
		score_texture.hide()
		
	score.text = "score: " + str(Global.score)
	killed.text = "Golems defeated: " + str(Global.golems_killed)
	
func _update_ammo():
	wpn_1.text = "wpn 1: " + str(Global.player_ammo_A)
	wpn_2.text = "wpn 2: " + str(Global.player_ammo_D)

func _ammo_picked():
	ammo_collected_hud.show()
	ammo_timer.start()
	_update_ammo()
	

func _on_timer_timeout() -> void:
	ammo_collected_hud.hide()
