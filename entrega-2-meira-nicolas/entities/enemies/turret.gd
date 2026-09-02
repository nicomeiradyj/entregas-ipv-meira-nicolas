extends Sprite2D

@export var projectile_scene: PackedScene

var projectile_container: Node2D

var player 

@onready var fire_position:Marker2D = $FirePosition

func set_values(new_player, new_container):
	player = new_player
	projectile_container = new_container
	$Timer.start()


func _on_timer_timeout() -> void:
	fire()
	
func fire():
	var projectile:Projectile = projectile_scene.instantiate()	
	projectile_container.add_child(projectile)
	projectile.set_starting_values($FirePosition.global_position, (player.global_position - $FirePosition.global_position).normalized())
	projectile.delete_requested.connect(_on_projectile_delete_requested)
	
func _on_projectile_delete_requested(projectile):
		projectile_container.remove_child(projectile)
		projectile.queue_free()
