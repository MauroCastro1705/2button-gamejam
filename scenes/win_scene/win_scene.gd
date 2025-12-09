extends Node3D

@onready var score: Label = %score

func _ready() -> void:
	score.text = "Final Score: " + str(Global.score)
