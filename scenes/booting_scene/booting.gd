extends Control


@onready var terminal: RichTextLabel = $Terminal

const NEXT_SCENE := "res://scenes/tutorial_scene/tutorial.tscn" 

var boot_lines: Array[String] = [
	"MB-CORE BOOTLOADER v4.9",
	"(C) 2087 BURDEN DEFENSE INDUSTRIES",
	"",
	"Initializing MECHA BURDEN / Unit ID: MB-07...",
	"Biometal Shell.......... OK",
	"Neural Sync Port......... READY",
	"Pilot Link Interface..... AWAITING SIGNAL",
	"",
	"Running structural integrity scan...",
	"  Frame Joints........... OK",
	"  Servo Actuators........ OK",
	"  Hydraulics............. OK",
	"  Plating................ OK",
	"",
	"Energy Systems Online:",
	"  Fusion Core............ STABLE (98%)",
	"  Backup Cells........... CHARGED",
	"  Overflow Conduits...... STANDBY",
	"",
	"Activating Defense Protocols...",
	"  Threat Database........ LOADED",
	"  Targeting Suite........ CALIBRATED",
	"  Auto-Turrets........... IDLE",
	"",
	"Urban Zone: NEW SAKURA CITY",
	"Status: UNDER THREAT",
	"Deploying MECHA BURDEN...",
	"",
	"Boot sequence complete.",
	"Awaiting pilot command.",
	"...."
]

var chars_per_second: float = 120.0
var line_delay: float = 0.05  # pausa entre líneas

func _ready() -> void:
	# Dejar la pantalla limpia y en verde
	terminal.clear()
	terminal.bbcode_enabled = false
	terminal.modulate = Color(0, 1, 0)
	terminal.scroll_active = false
	terminal.scroll_following = true

	# Arranca la corrutina del boot
	_start_boot()


func _start_boot() -> void:
	# Llamamos a una función async
	_print_boot_lines()


func _print_boot_lines() -> void:
	for line in boot_lines:
		await _type_line(line)
		terminal.append_text("\n")
		await get_tree().create_timer(line_delay).timeout

	# Pequeña pausa final
	await get_tree().create_timer(0.8).timeout

	# Opcional. hacer un pequeño flash antes de cambiar de escena
	modulate = Color(1, 1, 1)
	await get_tree().process_frame
	modulate = Color(1, 1, 1)

	# Cambiar a la siguiente escena
	get_tree().change_scene_to_file(NEXT_SCENE)


func _type_line(text: String) -> void:
	if text.is_empty():
		return

	var delay := 1.0 / chars_per_second

	for ch in text:
		terminal.append_text(String(ch))
		await get_tree().create_timer(delay).timeout
