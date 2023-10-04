extends Marker2D

class_name ShootingSystem

signal shot(ammo_in_magazine: int)
signal gun_reload(ammo_in_magazine: int, ammo_left: int)
signal ammo_added(total_ammo: int)

@export var max_ammo = 40
@export var total_ammo = 40
@export var magazine_size = 10

@onready var bullet_scene = preload("res://Scenes/bullet.tscn")

var ammo_in_magazine = 0
var crosshair_texture = preload("res://Assets/crosshair_white-export.png")

func _ready():
	Input.set_custom_mouse_cursor(crosshair_texture)
	ammo_in_magazine = magazine_size

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()
	
func reload():
	if total_ammo <= 0:
		return
	
	var bullet_missing_in_magazine = magazine_size - ammo_in_magazine
	var reloaded_amount = bullet_missing_in_magazine if bullet_missing_in_magazine < total_ammo else total_ammo
	
	total_ammo -= reloaded_amount
	ammo_in_magazine += reloaded_amount
	gun_reload.emit(ammo_in_magazine, total_ammo)
	
func shoot():
	if ammo_in_magazine == 0:
		return
	
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.damage = owner.damage_per_bullet	
	get_tree().root.add_child(bullet)
	
	var move_direction = (get_global_mouse_position() - global_position).normalized()
	bullet.move_direction = move_direction
	bullet.global_position = global_position
	bullet.rotation = move_direction.angle()
	
	ammo_in_magazine -= 1
	shot.emit(ammo_in_magazine)

func on_ammo_pickup():
	var ammo_to_add = max_ammo - total_ammo if total_ammo + magazine_size > max_ammo else magazine_size
	total_ammo += ammo_to_add
	ammo_added.emit(total_ammo)
