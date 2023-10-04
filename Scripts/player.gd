extends CharacterBody2D

class_name Player

@export var speed = 300
@export var rotation_speed = 5

var movement_direction: Vector2 = Vector2.ZERO
var angle

func _physics_process(delta):
	velocity = movement_direction * speed
	move_and_slide()
	
	if angle:
		global_rotation = lerp_angle(global_rotation, angle, delta * rotation_speed)

func _input(event):
	if Input.is_action_pressed("move_backwards"):
		movement_direction = Vector2.DOWN
	elif Input.is_action_pressed("move_forward"):
		movement_direction = Vector2.UP
	elif Input.is_action_pressed("move_left"):
		movement_direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		movement_direction = Vector2.RIGHT
	else:
		movement_direction = Vector2.ZERO
	
	angle = (get_global_mouse_position() - global_position).angle()

func take_damage(damage: int):
	print(damage)
