extends Control

@onready var player_life: ProgressBar = %player_life
@onready var enemy_life: ProgressBar = %enemy_life
@onready var ammo_1: Label = %"ammo 1"
@onready var ammo_2: Label = %"ammo 2"
@onready var player_life_value: Label = %player_life_value
@onready var enemy_life_value: Label = %enemy_life_value


func _ready() -> void:
	Global.golem_damaged.connect(_update_bars)
	Global.ammo_used.connect(_update_ammo)
	set_bars()
	set_ammo()
	
	
func set_bars():
	player_life.max_value = Global.player_life
	enemy_life.max_value = Global.golem_life

func _update_bars():
	player_life_value.text = str(Global.player_life)
	enemy_life_value.text =  str(Global.golem_life)
	player_life.value = Global.player_life
	enemy_life.value = Global.golem_life
	
func set_ammo():
	ammo_1.text = "ammo: " + str(Global.player_ammo_A)
	ammo_2.text = "ammo: " + str(Global.player_ammo_D)

func _update_ammo():
	set_ammo()
