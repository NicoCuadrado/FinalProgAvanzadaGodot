class_name Win extends Control

func _ready():
	# Opcional: pausar el juego al mostrar el menú
	get_tree().paused = true
	# Habilitar la UI aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_reintentar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/MenuPrincipal.tscn")
