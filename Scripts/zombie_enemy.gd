extends CharacterBody2D

class_name Zombie

var ammo_pickup_scene = preload("res://Scenes/ammo_pickup.tscn")
var health_pickup_scene = preload("res://Scenes/health_pickup.tscn")



@onready var navigation_agent_2d = $NavigationAgent2D
@onready var vision_ray_cast_2d = $VisionRayCast2D as RayCast2D
@onready var state_machine = $StateMachine as StateMachine
@onready var health_system = $HealthSystem as HealthSystem


@export_group("Locomotion")
@export var rotation_speed: float = 2
@export var wandering_speed = 150
@export var navigation_target: Node2D
@export var chasing_speed = 200

@export_group("Scanning for player")
@export var angle_cone_of_vision = 90
@export var max_vision_distance = 250
@export var angle_between_rays = 30

@export_group("Attack")
@export_range(0.1, 1) var attack_speed: float = 1
@export_range(1, 10) var attack_damage: float = 3

@export_group("Pickups")
@export var chance_to_drop_pickup = .5
@export var ammo_to_health_pickup_ratio = .6

var current_speed 

func _ready():
	var navigation_map = get_tree().get_first_node_in_group("tilemap").get_navigation_map(0)
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), navigation_map)
	navigation_agent_2d.set_navigation_map(navigation_map)
	current_speed = wandering_speed
	
	health_system.died.connect(on_died)
	
func _process(delta):
	search_for_player_with_raycast()

func move_to_position(target_position: Vector2):
	var motion = position.direction_to(target_position) * current_speed
	navigation_agent_2d.set_velocity(motion)
	look_at(target_position)
	velocity = motion
	move_and_slide()

func search_for_player_with_raycast():
	if state_machine.state_name != "Idle" and state_machine.state_name != "Wandering":
		return
		
	var cast_count = int(angle_cone_of_vision / angle_between_rays) + 1
	
	for index in cast_count:
		var cast_vector = max_vision_distance* Vector2.UP.rotated(rad_to_deg(angle_between_rays) * (index - cast_count) / 2.0)
		vision_ray_cast_2d.target_position = cast_vector
		vision_ray_cast_2d.force_raycast_update()
		
		if vision_ray_cast_2d.is_colliding() && vision_ray_cast_2d.get_collider() is Player:
			state_machine.transition_to("Chase")

func take_damage(damage: int):
	health_system.take_damage(damage)

func on_died():
	try_to_drop_pickup.call_deferred()
	queue_free()

func try_to_drop_pickup():
	var current_pickup_drop_chance = randf()
	if current_pickup_drop_chance > chance_to_drop_pickup:
		if randf() < ammo_to_health_pickup_ratio:
			var ammo_pickup = ammo_pickup_scene.instantiate()
			get_tree().root.add_child(ammo_pickup)
			ammo_pickup.global_position = global_position
		else:
			var health_pickup = health_pickup_scene.instantiate()
			get_tree().root.add_child(health_pickup)
			health_pickup.global_position = global_position
