extends Marker2D

@export var turret_scene: PackedScene

func _ready():
	call_deferred("initialize")

func initialize() -> void:
	
	# esto es para la posicion del player y que nio se pongan las torretas arriba 
	var target: Node2D = get_node("/root/Main/Player")
	
	for i in 3:
		var turret_instance: Node2D = turret_scene.instantiate()
		
		var turret_pos: Vector2 = global_position + Vector2(
			randf_range(-150, 150), 
			randf_range(-150, 150)
		)
		
		turret_instance.initialize(self, turret_pos, self)
