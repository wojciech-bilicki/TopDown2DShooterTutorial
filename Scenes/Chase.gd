extends State


const DISTANCE_TO_STOP_CHASING = 250
const CHANCE_TO_STOP_CHASING = .5

@onready var navigation_agent_2d = $"../../NavigationAgent2D" as NavigationAgent2D
@onready var sprite_2d = $"../../Sprite2D" as Sprite2D
@onready var random_target_chase_update_timer = $RandomTargetChaseUpdateTimer as RandomTimer
@onready var sounds = $"../../Sounds"

var texture_chase = preload("res://Assets/zombie_walking.png")
var texture_default = preload("res://Assets/zombie_standing.png")

func enter(msg = {}) -> void:
	if owner.is_queued_for_deletion():
		return 
		
	var random_stream_player = sounds.get_children().pick_random()
	random_stream_player.play()
		
	sprite_2d.texture = texture_chase
	owner.current_speed = owner.chasing_speed
	start_chasing()
	
func physics_update(delta: float):
	if navigation_agent_2d.is_navigation_finished():
		if try_to_stop_chasing():
			return
		set_next_chasing_target_point()
	
	var next_position = navigation_agent_2d.get_next_path_position()
	(owner as Zombie).move_to_position(next_position)

func try_to_stop_chasing() -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return true
	var player_position = player.global_position
	var distance_to_player = (owner as Zombie).global_position.distance_to(player_position)
	if distance_to_player > DISTANCE_TO_STOP_CHASING && randf() > CHANCE_TO_STOP_CHASING:
		stop_chasing()
		return true
	return false
			
func stop_chasing():
	var new_state = ["Idle", "Wandering"].pick_random()
	state_machine.transition_to(new_state)		

func exit(): 
	random_target_chase_update_timer.stop()
	sprite_2d.texture = texture_default
	owner.current_speed = owner.wandering_speed

func _on_random_target_chase_update_timer_timeout():
	if try_to_stop_chasing():
		return
	start_chasing()

func start_chasing(): 
	set_next_chasing_target_point()
	random_target_chase_update_timer.setup()

func set_next_chasing_target_point():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var player_position = player.global_position
	var navigation_point = NavigationServer2D.map_get_closest_point(navigation_agent_2d.get_navigation_map(), player_position)
	navigation_agent_2d.target_position = navigation_point	


func _on_attack_area_body_entered(body):
	state_machine.transition_to("Attack")
