extends Sprite2D

@onready var fire_position: Node2D = $FirePosition
@onready var fire_timer: Timer = $FireTimer

@export var projectile_scene: PackedScene

var target: Node2D
var projectile_container: Node

func initialize(container: Node, turret_pos: Vector2, new_projectile_container: Node) -> void:
	container.add_child(self)
	global_position = turret_pos
	projectile_container = new_projectile_container
	
	fire_timer.timeout.connect(fire_at_player)

func fire_at_player() -> void:
	if target == null:
		return
		
	var proj_instance = projectile_scene.instantiate()
	proj_instance.initialize(
		projectile_container,
		fire_position.global_position,
		fire_position.global_position.direction_to(target.global_position)
	)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if target == null:
		target = body
		fire_timer.start()


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		fire_timer.stop()
		
