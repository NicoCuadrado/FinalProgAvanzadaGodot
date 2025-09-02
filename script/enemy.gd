class_name Enemy extends CharacterBody2D

var velocidad_movimiento := 150
var gravedad := 600
var danio_ataque := 10
var esta_atacando := false

@onready var player: Player = $"../Player"
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D

var rango_deteccion := 350  # en píxeles

func _physics_process(delta: float) -> void:
	# gravedad
	if !is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = max(velocity.y, 0)

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
# cuando el player entra en la zona de ataque
func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		ataque()
		
# cuando el player sale de la zona de ataque
func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Player:
		esta_atacando = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":# Replace with function body.
		if esta_atacando:
			ataque()
