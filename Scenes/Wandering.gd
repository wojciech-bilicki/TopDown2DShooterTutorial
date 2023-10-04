extends State

@onready var navigation_agent_2d = $"../../NavigationAgent2D"
var wandering_radius = 500

var random_position_in_radius

func enter(msg = {}) -> void:
	move_to_next_random_location()
	
func move_to_next_random_location():
	random_position_in_radius = get_random_position_in_radius(wandering_radius)
	navigation_agent_2d.target_position = random_position_in_radius

func physics_update(delta):
	if navigation_agent_2d.target_position != Vector2.ZERO && (navigation_agent_2d.is_navigation_finished() || !navigation_agent_2d.is_target_reachable()):
		state_machine.transition_to("Idle")
		return
	else: 
		var next_position = navigation_agent_2d.get_next_path_position()
		(owner as Zombie).move_to_position(next_position)

func get_random_position_in_radius(wandering_radius: float) -> Vector2:
	var global_position = owner.global_position
	var random_angle = randf() * 360.0
	var random_point = Vector2.from_angle(random_angle) * randf_range(1.0, wandering_radius) + global_position
	var navigation_point = NavigationServer2D.map_get_closest_point(navigation_agent_2d.get_navigation_map(), random_point)
	return navigation_point
