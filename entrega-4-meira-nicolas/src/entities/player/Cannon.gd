extends Node2D

@onready var weapon_tip: Node2D = $WeaponTip
@export var projectile_scene: PackedScene

var projectile_container: Node

func process_input() -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("fire_cannon"):
		fire()

func fire() -> void:
	var projectile_instance: Node = projectile_scene.instantiate()
	
	get_tree().current_scene.add_child(projectile_instance)
	
	var aim_direction = global_position.direction_to(get_global_mouse_position())
	
	projectile_instance.initialize(
		weapon_tip.global_position,
		aim_direction
	)
