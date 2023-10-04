extends CanvasLayer

class_name PlayerUI

@onready var life_bar = $MarginContainer/LifeBar
@onready var ammo_container = %AmmoContainer
@onready var ammo_left_label = %AmmoLeftLabel
@onready var key_icon = %KeyIcon
@onready var extract_counter_label = $MarginContainer/ExtractCounterLabel
@onready var game_over_label = %GameOverLabel
@onready var game_over_container = $GameOverContainer

var bullet_texture = preload("res://Assets/bullet_icon.png")


func set_life_bar_max_value(max_value: int):
	life_bar.max_value = max_value

func update_life_bar_value(life: int):
	life_bar.value = life

func set_max_ammo(max_ammo: int):
	for i in max_ammo:
		var ammo_texture_rect = TextureRect.new()
		ammo_texture_rect.texture = bullet_texture
		ammo_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		ammo_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		ammo_container.add_child(ammo_texture_rect)

func set_ammo_left(ammo_left: int):
	ammo_left_label.text = " /%d" % ammo_left

func bullet_shot(bullet_number: int):
	var bullet_count = ammo_container.get_child_count()
	var bullet_texture_rect = ammo_container.get_child(bullet_count - 1 - bullet_number)
	bullet_texture_rect.modulate = Color(Color.WHITE, .5)


func gun_reloaded(ammo_in_magazine: int, total_ammo_left: int):
	var bullet_count = ammo_container.get_child_count()
	
	for i in ammo_in_magazine:
		var bullet_texture_rect = ammo_container.get_child(bullet_count - 1 - i)
		bullet_texture_rect.modulate = Color(Color.WHITE)
	
	set_ammo_left(total_ammo_left)

func on_key_pickup():
	key_icon.show()
	
func update_extract_timer(time_left: float):
	if extract_counter_label.hidden:
		extract_counter_label.show()
	extract_counter_label.text = "%.2f" % time_left

func hide_extract_countdown():
	extract_counter_label.hide()

func on_game_over(is_game_lost: bool):
	if is_game_lost:
		game_over_label.text = "YOU HAVE DIED!!!"
	game_over_container.show()


func _on_play_again_button_pressed():
	get_tree().reload_current_scene()
