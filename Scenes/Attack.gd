extends State

@onready var sprite_2d = $"../../Sprite2D"
@onready var sounds = $"../../Sounds"


var attack_speed 
var attack_damage 
var time_elapsed: float = 0
var time_between_attacks 

func _ready():
	attack_damage = (owner as Zombie).attack_damage
	time_between_attacks = 0.3 + 1 / (owner as Zombie).attack_speed

func enter(msg = {}):
	attack()

func physics_update(delta):
	time_elapsed += delta
	if time_elapsed >= time_between_attacks:
		attack()
		time_elapsed = 0

func attack():
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("take_damage"):
		player.take_damage(attack_damage)
		
		var random_stream_player = sounds.get_children().pick_random()
		random_stream_player.play()
		
		var attack_tween = get_tree().create_tween()
		attack_tween.tween_property(sprite_2d, "modulate", Color(115, 0,0, 1), .3)
		attack_tween.chain().tween_property(sprite_2d, "modulate", Color.WHITE, .3)

func exit():
	time_elapsed = 0


func _on_attack_area_body_exited(body):
	if body is Player:
		state_machine.transition_to("Chase")
