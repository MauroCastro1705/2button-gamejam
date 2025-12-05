extends Control

@onready var player_life: ProgressBar = %player_life
@onready var enemy_life: ProgressBar = %enemy_life
@onready var ammo_1: Label = %"ammo 1"
@onready var ammo_2: Label = %"ammo 2"
@onready var player_life_value: Label = %player_life_value
@onready var enemy_life_value: Label = %enemy_life_value


var current_enemy_zone: Node = null  # reference to the active zone

func _ready() -> void:
	Global.ammo_used.connect(_update_ammo)
	set_bars()
	set_ammo()

func set_bars():
	player_life.max_value = Global.player_life
	player_life.value = Global.player_life

	if current_enemy_zone:
		enemy_life.max_value = current_enemy_zone.golem_life_local
		enemy_life.value = current_enemy_zone.golem_life_local
	else:
		enemy_life.max_value = 1
		enemy_life.value = 0

func _update_bars():
	player_life_value.text = str(Global.player_life)
	player_life.value = Global.player_life

	if current_enemy_zone:
		var life = max(current_enemy_zone.golem_life_local, 0)
		enemy_life_value.text = str(life)
		enemy_life.value = life
	else:
		enemy_life_value.text = "—"
		enemy_life.value = 0

func set_ammo():
	ammo_1.text = "ammo: " + str(Global.player_ammo_A)
	ammo_2.text = "ammo: " + str(Global.player_ammo_D)

func _update_ammo():
	set_ammo()


func set_enemy_zone(zone: Node):
	if current_enemy_zone and current_enemy_zone != zone:
		# Disconnect old zone if it was connected
		if current_enemy_zone.has_signal("local_golem_damaged"):
			current_enemy_zone.local_golem_damaged.disconnect(_update_bars)
	current_enemy_zone = zone

	# refresh HUD dynamically
	if current_enemy_zone.has_signal("local_golem_damaged"):
		current_enemy_zone.local_golem_damaged.connect(_update_bars)
	set_bars()
