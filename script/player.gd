class_name Player extends CharacterBody2D

@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent

signal ataque_finalizado 

var velocidad_movimiento := 200
var fuerza_salto := -300   # valor negativo porque el eje Y crece hacia abajo en Godot
var gravedad := 600        # para que el personaje caiga
var danio_ataque := 50
var esta_atacando := false
var esta_muerto := false

func _ready() -> void:
	health_component.death.connect(on_dead)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				ataque()

func _physics_process(delta: float) -> void:
	if esta_muerto:
		return # esto no permite mas inputs si el jugador esta muerto
	
	# aplicar gravedad siempre
	if !is_on_floor():
		velocity.y += gravedad * delta
	else:
		# si está en el suelo y se presiona espacio → salto
		if Input.is_action_just_pressed("ui_accept"): # espacio por defecto en Godot
			velocity.y = fuerza_salto

	if !esta_atacando:
		var direccion_x := 0
		
		# movimiento lateral con A y D
		if Input.is_action_pressed("ui_left"):   # tecla A por defecto
			direccion_x = -1
		elif Input.is_action_pressed("ui_right"): # tecla D por defecto
			direccion_x = 1

		velocity.x = direccion_x * velocidad_movimiento
		
		# animaciones
		if direccion_x != 0:
			sprite_animation.play("run")
			sprite_animation.flip_h = direccion_x < 0
		else:
			if is_on_floor(): # que solo muestre idle si no está en el aire
				sprite_animation.play("idle")

	move_and_slide()

func ataque():
	sprite_animation.play("attack")
	esta_atacando = true
# aca termina la animacion de ataque 
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		esta_atacando = false
		ataque_finalizado.emit()

func on_dead():
	esta_muerto = true
	sprite_animation.play("death")
	await sprite_animation.animation_finished
	print("game Over")
	get_tree().paused = true

func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.en_rango_de_ataque_player = true


func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Enemy:
		body.en_rango_de_ataque_player = false
