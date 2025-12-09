extends CharacterBody3D

@export_subgroup("Components")
@export var move_speed: float = 2.0
@export var turn_speed_deg: float = 180.0# degrees per second when held
@export var snap_turn_deg: float = 0.0# set (e.g. 45) to use discrete snap turns on tap; 0 = smooth turning
@export var canmove: bool = true
@onready var model: Node3D = $player_Golem
@onready var ring_shader: MeshInstance3D = $"ring shader"
@onready var ammo_label: Label3D = $player_Golem/ammo_label
@onready var ammo_timer: Timer = $ammo_timer

func _ready() -> void:
	ammo_label.hide()
	ring_shader.hide()
	
