extends Node

class_name HealthSystem

signal died
signal damage_taken(current_health: int)

@export var base_health = 15
var current_health

func _ready():
	current_health = base_health

func take_damage(damage: int):
	current_health -= damage
	damage_taken.emit(current_health)
	if current_health <= 0:
		died.emit()


