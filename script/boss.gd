class_name Boss extends CharacterBody2D

var velocidad_movimiento := 150
var gravedad := 600
var danio_ataque := 8
var esta_atacando := false
var en_rango_de_ataque_player = false
var esta_muerto := false

@onready var player: Player = $"../Player"
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent

var rango_deteccion := 350  # en píxeles

func _ready() -> void:
	
	health_component.death.connect(on_dead)
	if player:
		player.ataque_finalizado.connect(verificar_danio_recibido)

func _physics_process(delta: float) -> void:
	# gravedad
	if !is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = max(velocity.y, 0)
	
	if esta_muerto:
		velocity.x = 0
		return
	
	
	if !esta_atacando and player:
		var distancia = global_position.distance_to(player.global_position)

		if distancia <= rango_deteccion:
			# perseguir
			var dx = player.global_position.x - global_position.x
			if abs(dx) > 5:
				var direccion_x = sign(dx)
				velocity.x = direccion_x * velocidad_movimiento
				sprite_animation.play("run")
				sprite_animation.flip_h = direccion_x < 0
			else:
				velocity.x = 0
				sprite_animation.play("idle")
		else:
			# fuera de rango → quieto
			velocity.x = 0
			sprite_animation.play("idle")

	move_and_slide()

func ataque():
	sprite_animation.play("attack")
	esta_atacando = true
	
func verificar_danio_recibido():
	if en_rango_de_ataque_player:
		health_component.receive_damage(player.danio_ataque)
		
func on_dead():
	#reproduce la animacion de muerte
	esta_muerto = true
	sprite_animation.play("death")
	await sprite_animation.animation_finished
	
	var win_screen = preload("res://escenas/Win.tscn").instantiate()
	get_tree().current_scene.add_child(win_screen)
	
	queue_free()
	
# cuando el player entra en la zona de ataque
func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		ataque()
		en_rango_de_ataque_player = true
# cuando el player sale de la zona de ataque
func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Player:
		esta_atacando = false
		en_rango_de_ataque_player = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":# Replace with function body.
		player.health_component.receive_damage(danio_ataque)
		if esta_atacando:
			ataque()
