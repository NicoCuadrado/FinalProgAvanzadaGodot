class_name Win extends Control

func _ready():
	GameManager.detener_tiempo()
	#pausar el juego al mostrar el menú
	get_tree().paused = true
	# Habilitar la UI aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# mostrar el tiempo final
	var segundos = int(GameManager.tiempo_final) % 60
	var minutos = int(GameManager.tiempo_final) / 60
	$CanvasLayer/CenterContainer/Control/VBoxContainer/TimeLabel.text = "Tiempo: %02d:%02d" % [minutos, segundos]

func _on_reintentar_pressed():
	get_tree().paused = false
	GameManager.reset()
	GameManager.reiniciar()
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/MenuPrincipal.tscn")
