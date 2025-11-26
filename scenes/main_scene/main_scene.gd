extends Node2D


var escena_elegida_local


#import de assets
const N1_AULA = preload("res://assets/nivel_1/aula.jpeg")
const N1_CHICO_1 = preload("res://assets/nivel_1/chico1.png")
const N1_CHICO_2 = preload("res://assets/nivel_1/chico2.png")
#nivel 2
const N2_AULA = preload("res://assets/nivel_2/aula2.jpeg")
const N2_CHICO_1 = preload("res://assets/nivel_2/sprite3 sad small.png")
const N2_CHICO_2 = preload("res://assets/nivel_2/chico2.png")
#nivel3
const N3_CANCHA = preload("res://assets/nivel_3/cancha.jpeg")
const N3_CHICO_1 = preload("res://assets/nivel_3/chico1.png")
const N3_CHICO_2 = preload("res://assets/nivel_3/chico2.png")

@onready var pause_menu: Control = $Pause_menu

@onready var question_label: Label = $pregunta/pregunta
@onready var pregunta_rect: NinePatchRect = $pregunta/pregunta_rect
@onready var label_respuestas: Label = $contador_respuestas/respuestas
@onready var respuestas_azul: Label = $contador_respuestas/respuestas_azul
@onready var respuestas_verde: Label = $contador_respuestas/respuestas_verde
@onready var respuestas_rojo: Label = $contador_respuestas/respuestas_rojo
@onready var respuestas_amarillo: Label = $contador_respuestas/respuestas_amarillo

#fondo negro
@onready var fondo_negro: ColorRect = $comienzo_juego/negro


#opcion 1
@onready var azul_button_1: Button = $opcion1/Button
@onready var label_1: Label = $opcion1/Label
#opcion 2
@onready var verde_button_2: Button = $opcion2/Button2
@onready var label_2: Label = $opcion2/Label2
#opcion 3
@onready var rojo_button_3: Button = $opcion3/Button3
@onready var label_3: Label = $opcion3/Label
#opcion 4
@onready var amarillo_button_4: Button = $opcion4/Button4
@onready var label_4: Label = $opcion4/Label
#markers de dialogos
@onready var sprite_1: Sprite2D = $"personajes/personaje 1/Sprite_1"
@onready var pj_1: Marker2D = %Marker1

@onready var sprite_2: Sprite2D = $"personajes/personaje 2/Sprite_2"
@onready var pj_2: Marker2D = %Marker2

@onready var fondo: Sprite2D = $Fondo


signal dialogo_finalizado

#setup
var opciones = []
var current_id := "inicio" 

func _ready():
	pause_menu.visible = false
	_esconder_textos()
	reset_contadores()
	_fundido_a_negro()
	_set_values()
	fondo_negro.modulate = Color(0,0,0,1)
	set_process_input(true)	# Atajo: ESC para volver
	

func set_assets_nivel_1():
	fondo.texture = N1_AULA
	sprite_1.texture = N1_CHICO_1
	sprite_2.texture = N1_CHICO_2

func set_assets_nivel_2():
	fondo.texture = N2_AULA
	sprite_1.texture = N2_CHICO_1
	sprite_2.texture = N2_CHICO_2
	
func set_assets_nivel_3():
	fondo.texture = N3_CANCHA
	sprite_1.texture = N3_CHICO_1
	sprite_2.texture = N3_CHICO_2

#funcion que retorna la base de datos con los dialogos
func get_escena_elegida_node_data():
	var node = escena_elegida_local.RESPUESTAS.get(current_id, null)
	return node

func _set_values():
	Global.respuestas = 0
	opciones = [
			{"button": azul_button_1,     "label": label_1, "key": "racional"},
			{"button": verde_button_2,    "label": label_2, "key": "empatica"},
			{"button": rojo_button_3,     "label": label_3, "key": "impulsiva"},
			{"button": amarillo_button_4, "label": label_4, "key": "valiente"},
		]
		
func _fundido_a_negro():
	fondo_negro.visible = true
	
	var fundido_negro := create_tween()
	fundido_negro.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Animar alfa desde 1.0 (opaco) hasta 0.0 (transparente)
	fundido_negro.tween_property(
		fondo_negro, "modulate:a", 0.0, 2)
	fundido_negro.tween_callback(Callable(fondo_negro, "hide"))
	await fundido_negro.finished
	_iniciar_dialogos()
	
func _iniciar_dialogos():
	_mostrar_textos()
	cargar_dialogo_desde_database()
	#Dialogos.primer_dialogo(pj_1, pj_2)#ejecutamos dialogo creado
	#Dialogic.timeline_ended.connect(_termino_dialogo)

func cargar_dialogo_desde_database() -> void:
	var node = get_escena_elegida_node_data() #usamos funcion para traer data de dialogos
	question_label.text = str(node.get("pregunta", ""))
	var es_final := bool(node.get("final", false))
	var opts: Array = node.get("opciones", [])

	for i in range(opciones.size()):
		_cargar_opciones_en_botones(i, opts, es_final)
	_update_respuestas()


func _cargar_opciones_en_botones(i: int, opts: Array, es_final: bool) -> void:
	var btn: Button = opciones[i]["button"]
	var lab: Label  = opciones[i]["label"]

	var txt := _texto_de_opcion(i, es_final, opts)  # devuelve String
	lab.text = txt
	btn.visible = (txt != "")
	btn.disabled = not btn.visible# re-habilita si corresponde

	_limpiar_conexiones_previas(btn)
	_reconectar_opciones_si_visible(btn, i)

func _texto_de_opcion(i: int, es_final: bool, opts: Array) -> String:
	if es_final:
		return _texto_final(i)
	return _texto_normal(i, opts)

func _texto_final(i: int) -> String:
	return "Continuar" if i == 0 else ""

func _texto_normal(i: int, opts: Array) -> String:
	return str(opts[i]) if (i >= 0 and i < opts.size()) else ""

func _limpiar_conexiones_previas(btn: Button) -> void:
	for c in btn.get_signal_connection_list("pressed"):
		btn.disconnect("pressed", c["callable"])
	
func _reconectar_opciones_si_visible(btn: Button, i: int) -> void:
	if not btn.visible:
		return
	var the_call := Callable(self, "_on_option_selected").bind(i)
	if btn.pressed.is_connected(the_call):
		btn.pressed.disconnect(the_call)
	btn.pressed.connect(the_call)

	
func _update_respuestas():
	label_respuestas.text = "respuestas: " + str(Global.respuestas)
	respuestas_azul.text = "respuestas: " + str(get_contador("racional"))
	respuestas_verde.text = "respuestas: " + str(get_contador("empatica"))
	respuestas_rojo.text = "respuestas: " + str(get_contador("impulsiva"))
	respuestas_amarillo.text = "respuestas: " + str(get_contador("valiente"))

func _on_option_selected(index: int) -> void:
	if index >= 0 and index < opciones.size():
		var key = opciones[index].get("key", "")
		if key != "":
			Global.contadores[key] += 1
			print("Botón fue presionado")

	Global.respuestas += 1
	_navegar_dialogos(index)


func _navegar_dialogos(index: int) -> void:
	var node = get_escena_elegida_node_data()
	var next_list: Array = node.get("next", [])
	var next_id := ""
	if index >= 0 and index < next_list.size():
		next_id = str(next_list[index])

	# Sin destino => fin
	if next_id == "":
		_desactivar_opciones()
		_finalizar_dialogo()
		return

	#  Con destino
	var next_node = get_escena_elegida_node_data()
	if next_node == null:
		push_warning("next_id inválido: %s" % next_id)
		_desactivar_opciones()
		_finalizar_dialogo()
		return

	current_id = next_id
	cargar_dialogo_desde_database()

	if bool(next_node.get("final", false)):
		_finalizar_dialogo()

func _finalizar_dialogo() -> void:
	emit_signal("dialogo_finalizado")
	_desactivar_opciones()
	_esconder_textos()


func _desactivar_opciones() -> void:
	for opcion in opciones:
		var b: Button = opcion["button"]
		b.disabled = true

func _esconder_textos() -> void:
	var nodes = [label_1, label_2, label_3, label_4,question_label]
	for node in nodes:
		node.hide()

#func _termino_dialogo():
#	_mostrar_textos()

func _mostrar_textos():
	var label_nodes = [label_1, label_2, label_3, label_4]
	var question_nodes =[question_label]
	
	for question in question_nodes:
		question.show()
		question.modulate.a = 0.0
		question.scale = Vector2(0.9, 0.9)
		
		var question_tween = create_tween() #para la pregunta
		question_tween.parallel().tween_property(question, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		question_tween.parallel().tween_property(question, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		await question_tween.finished
		
	for label in label_nodes:
		label.show()
		label.modulate.a = 0.0
		label.scale = Vector2(0.7, 0.7)  # arranca más chico
		
		var label_tween = create_tween() #para los labels
		label_tween.parallel().tween_property(label, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		label_tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
func get_contador(color: String) -> int:
	return Global.contadores.get(color, 0)

func reset_contadores() -> void:
	for k in Global.contadores.keys():
		Global.contadores[k] = 0
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		mostrar_pause_menu()
		
func mostrar_pause_menu():
	pause_menu.visible = true
