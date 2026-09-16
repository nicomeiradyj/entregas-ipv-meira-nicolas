extends StaticBody2D

@onready var fire_position: Node2D = $FirePosition
@onready var fire_timer: Timer = $FireTimer
@onready var raycast: RayCast2D = $RayCast2D

@export var projectile_scene: PackedScene
@onready var body_anim: AnimatedSprite2D = $Body

var target: Node2D
var projectile_container: Node

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false


func _ready() -> void:
	fire_timer.timeout.connect(fire)
	body_anim.animation_finished.connect(_on_animation_finished)
	set_physics_process(false)
	_play_animation("Idle")

func initialize(turret_pos: Vector2, projectile_container: Node) -> void:
	global_position = turret_pos
	self.projectile_container = projectile_container


func fire() -> void:
	if target == null:
		return
	
	_play_animation("Attack")
	
	var proj_instance: Node = projectile_scene.instantiate()
	if projectile_container == null:
		projectile_container = get_parent()
	projectile_container.add_child(proj_instance)
	proj_instance.initialize(
		fire_position.global_position,
		fire_position.global_position.direction_to(target.global_position)
	)
	fire_timer.start()


func _physics_process(delta: float) -> void:
	raycast.set_target_position(raycast.to_local(target.global_position))
	if raycast.is_colliding() && raycast.get_collider() == target:
		if fire_timer.is_stopped():
			fire_timer.start()
	elif !fire_timer.is_stopped():
		fire_timer.stop()


## Esta función ya no llama directamente a remove, sino que inhabilita las
## colisiones con el mundo, pausa todo lo demás y ejecuta una animación de muerte
var is_dying: bool = false

func notify_hit() -> void:
	if is_dying:
		return
	is_dying = true
	
	set_physics_process(false)
	fire_timer.stop()
	
	body_anim.play("Die")
	
	await get_tree().create_timer(2.0).timeout # pàra que se deje de repetir la animacion de die, esta desactivada el bucle pero me sigue fallando
	queue_free()

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if target == null:
		target = body
		set_physics_process(true)


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		set_physics_process(false)
		_play_animation("Idle")


func _on_animation_finished() -> void:
	if body_anim.animation == "Attack":
		_play_animation("Idle")


## Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
## (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: String) -> void:
	if body_anim.sprite_frames.has_animation(animation):
		body_anim.play(animation)
