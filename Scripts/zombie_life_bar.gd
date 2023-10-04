extends ProgressBar

class_name ZombieLifeBar

@onready var health_system = $"../HealthSystem" as HealthSystem

func _ready():
	max_value = health_system.base_health
	health_system.damage_taken.connect(on_damage_taken)
	value = max_value
	
func on_damage_taken(current_health):
	value = current_health
