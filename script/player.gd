class_name Player extends CharacterBody2D

@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var h_box_container: HBoxContainer = $CanvasLayer/HBoxContainer

signal ataque_finalizado 

var velocidad_movimiento := 200
var fuerza_salto := -300
var gravedad := 600
var danio_ataque := 20
var esta_atacando := false
var esta_muerto := false


var saltos_maximos := 2
var saltos_actuales := 0

func _ready() -> void:
	health_component.death.connect(on_dead)
	update_vidas()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		ataque()

func _physics_process(delta: float) -> void:
	if esta_muerto:
		return
	
	# Gravedad
	if !is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = max(velocity.y, 0)
		saltos_actuales = 0  # ✅ Resetear saltos al tocar el piso

	# --- SALTO Y DOBLE SALTO ---
	if Input.is_action_just_pressed("ui_accept") and saltos_actuales < saltos_maximos:
		velocity.y = fuerza_salto
		saltos_actuales += 1
	
	if saltos_actuales == 1:
		sprite_animation.play("jump")  # animación de primer salto
	elif saltos_actuales == 2:
		sprite_animation.play("jump")  # animación de doble salto
	
	# Animación de caída si no está en el piso
	#if !is_on_floor() and velocity.y > 0:
	#	if sprite_animation.animation != "fall":
	#		sprite_animation.play("fall")

	# Movimiento lateral
	if !esta_atacando:
		var direccion_x := 0
		if Input.is_action_pressed("ui_left"):
			direccion_x = -1
		elif Input.is_action_pressed("ui_right"):
			direccion_x = 1

		velocity.x = direccion_x * velocidad_movimiento

		# Animaciones
		if direccion_x != 0:
			sprite_animation.play("run")
			sprite_animation.flip_h = direccion_x < 0
		else:
			if is_on_floor():
				sprite_animation.play("idle")

	move_and_slide()

func ataque():
	sprite_animation.play("attack")
	esta_atacando = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		esta_atacando = false
		ataque_finalizado.emit()

func update_vidas():
	for i in range(GameManager.max_vidas):
		var vida = h_box_container.get_child(i) as TextureRect
		if i < GameManager.vidas:
			vida.texture = load("res://art/Adventurer-1.5/Individual Sprites/adventurer-idle-03.png")
		else:
			vida.texture = load("res://art/Adventurer-1.5/Individual Sprites/adventurer-die-06.png")

func on_dead():
	esta_muerto = true
	GameManager.vidas -= 1
	update_vidas()

	if GameManager.vidas > 0:
		get_tree().reload_current_scene()
	else:
		
		sprite_animation.play("death")
		await sprite_animation.animation_finished
		var game_over_scene = preload("res://escenas/GameOver.tscn").instantiate()
		get_tree().current_scene.add_child(game_over_scene)
		get_tree().paused = true

func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.en_rango_de_ataque_player = true

func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Enemy:
		body.en_rango_de_ataque_player = false
