extends Area2D

class_name Bullet
var speed = 500
var move_direction: Vector2 = Vector2.ZERO
var damage

func _process(delta):
	global_position += move_direction * delta * speed

func _on_body_entered(body):
	if body is Zombie:
		body.take_damage(damage)	
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
