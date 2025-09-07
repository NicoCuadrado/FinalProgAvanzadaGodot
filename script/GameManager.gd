extends Node

var max_vidas := 3
var vidas := max_vidas
var enemigos_restantes:= 3

var tiempo_transcurrido: float = 0.0  # en segundos
var contando_tiempo := true
var tiempo_final: float = 0.0


func reset():
	vidas = max_vidas

#funciones relacionadas al timer
func _process(delta: float) -> void:
	if contando_tiempo:
		tiempo_transcurrido += delta
		
func detener_tiempo():
	contando_tiempo = false
	tiempo_final = tiempo_transcurrido

func reiniciar():
	vidas = max_vidas
	tiempo_transcurrido = 0.0
	tiempo_final = 0.0
	contando_tiempo = true
