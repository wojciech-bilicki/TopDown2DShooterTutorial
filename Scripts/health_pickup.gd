extends Area2D

const HEALTH_AMOUNT_RESTORED = 3

func _on_body_entered(body):
	get_tree().get_first_node_in_group("pickup_player").play()
	(body as Player).on_health_pickup(HEALTH_AMOUNT_RESTORED)
	queue_free()
