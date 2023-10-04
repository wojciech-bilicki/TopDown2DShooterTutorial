extends Area2D

@onready var random_timer = $RandomTimer as RandomTimer

var player 

func _process(delta):
	if !random_timer.is_stopped():
		player.update_extract_timer(random_timer.time_left)

func _on_body_entered(body):
	if (body as Player).has_key:
		player = body
		random_timer.setup()


func _on_body_exited(body):
	random_timer.stop()
	(body as Player).hide_extract_countdown()
	player = null


func _on_random_timer_timeout():
	random_timer.stop()
	player.extract()
