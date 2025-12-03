extends Control

const PLAY_SCENE := preload("res://scenes/main.tscn")
const CREDITS = preload("res://scenes/credits/credits.tscn")

const CREDITS_SCENE_PATH := ""
@onready var buttons_vbox: VBoxContainer = %buttons
@onready var selector: Label = $selector

var buttons: Array[Button] = []
var index := 0

func _ready() -> void:
	# Collect buttons in display order
	for child in buttons_vbox.get_children():
		if child is Button:
			buttons.append(child)
	
	for b in buttons:
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.focus_mode = Control.FOCUS_ALL

	await get_tree().process_frame# Place selector on first button after layout settles
	_update_selection()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("button_one"):
		_cycle_next()
	elif event.is_action_pressed("button_two"):
		_activate_current()

func _cycle_next() -> void:
	if buttons.is_empty():
		return
	index = (index + 1) % buttons.size()
	_update_selection()

func _update_selection() -> void:
	if buttons.is_empty():
		return
	var b := buttons[index]

	b.grab_focus()
	_position_selector(b)

func _position_selector(b: Button) -> void:
	# Get the global rect of the button
	var rect := b.get_global_rect()

	var local_topleft := rect.position - get_global_rect().position
	selector.size = selector.get_minimum_size()
	var x := local_topleft.x - selector.size.x - 12.0
	var y := local_topleft.y + (rect.size.y - selector.size.y) * 0.5
	selector.position = Vector2(x, y)

func _activate_current() -> void:
	if buttons.is_empty():
		return

	match buttons[index].name:
		"BtnPlay":
			get_tree().change_scene_to_packed(PLAY_SCENE)
		"BtnCredits":
			get_tree().change_scene_to_packed(CREDITS)
		"BtnExit":
			get_tree().quit()


func _goto_scene_safe(path: String) -> void:
	if path.is_empty():
		push_error("PLAY_SCENE_PATH is empty.")
		return

	# 1) Verify the resource actually exists in the PCK (helps catch export issues)
	if not ResourceLoader.exists(path):
		push_error("Scene NOT found in export: %s" % path)
		return

	# 2) Preload it so the exporter *must* include it; also catches load errors early
	var packed := load(path)
	if packed == null:
		push_error("Failed to load PackedScene: %s" % path)
		return

	# 3) Change scene via PackedScene (recommended in Godot 4)
	var err := get_tree().change_scene_to_packed(packed)
	if err != OK:
		push_error("change_scene_to_packed error code: %s" % str(err))
