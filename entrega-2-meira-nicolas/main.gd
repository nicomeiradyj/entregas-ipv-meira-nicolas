extends Node2D

var turret_scene: PackedScene = preload("res://entities/enemies/turret.tscn")


func _ready() -> void:
	$Player.set_projectile_container(self)
	#$Turret.set_values($Player, self) esto era para cuando solo tenia 1 torreta fija
	randomize()
	for i in range(3):
		spawn_turret()
		
func spawn_turret():
	var turret_instance = turret_scene.instantiate()
	var screen_width = get_viewport_rect().size.x #limite de la pantalla seria el size
	#posicion x aleatoria, dentro de la imagen del juego
	var random_x = randf_range(50, screen_width - 50)
	
	#posicion Y aleatoria, por arriba del jugador
	var random_y = randf_range(50, $Player.global_position.y - 50)
	
	#asignamos las posiciones aleatorias a la torreta
	turret_instance.global_position = Vector2(random_x, random_y)
	
	add_child(turret_instance)
	turret_instance.set_values($Player, self)		
	
	
 
