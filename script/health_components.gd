class_name HealthComponent extends Node2D

@export var progress_bar:ProgressBar
@export var current_health := 100
@export var max_health := 100 

signal death

func _ready() -> void:
	update_health_bar()

func update_health_bar():
	if progress_bar: 
		progress_bar.value = current_health

func receive_damage(amount: int):
	current_health = clamp(current_health - amount, 0,max_health)
	update_health_bar()
	
	if current_health <= 0:
		on_dead()

func on_dead():
	death.emit()
