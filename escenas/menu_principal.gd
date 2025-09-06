extends Control

@export var game_scene_path: String = "res://escenas/nivel_1.tscn"

func _on_jugar_pressed() -> void:
	# Carga la escena principal del juego al hacer clic en "Jugar".
	get_tree().change_scene_to_file(game_scene_path)

func _on_salir_pressed() -> void:
	# Cierra el juego al hacer clic en "Salir".
	get_tree().quit()
