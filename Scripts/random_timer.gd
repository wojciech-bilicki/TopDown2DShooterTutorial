extends Timer

class_name RandomTimer

@export var min_time: float = 1
@export var max_time: float = 4

func setup():
	var random_wait_time = randf_range(min_time, max_time)
	wait_time = random_wait_time
	start()
