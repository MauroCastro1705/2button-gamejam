extends Control

@onready var walk_label: Label = $walk
@onready var mode_label: Label = $mode

func _ready() -> void:
	_update_ui()

func _process(_delta: float) -> void:
	_update_ui()

func _update_ui() -> void:
	var is_side := Global.cam_mode == Global.CamMode.SIDE

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
