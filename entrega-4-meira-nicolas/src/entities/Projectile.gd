
## Al proyectil le cambiamos el tipo a Node2D para desacoplar
## funciones tales como gráficos, para que pueda manejarlo de
## manera independiente con su propia implementación
extends Node2D

@onready var lifetime_timer: Timer = $LifetimeTimer
@onready var hitbox: Area2D = $Hitbox
@onready var anim = $AnimatedSprite2D
@export var VELOCITY: float = 800.0

var direction: Vector2

@export var is_enemy_bullet: bool = false

func initialize(spawn_position: Vector2, direction: Vector2) -> void:
	self.direction = direction
	global_position = spawn_position
	rotation = direction.angle()
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout)
	lifetime_timer.start()
	
	## Ahora definimos que la implementación de proyectiles usará un AnimationPlayer
	## que contendrá 3 animaciones claves: fire_start, fire_loop y hit.
	## Acá lo que hacemos es definir que iniciará con "fire_start" para darle
	## un arranque, y encolamos a "fire_loop" para que se reproduzca solo.
	
	## Un factor importante es que cada escena que herede de esta debe implementar
	## su propia variación de la animación, seleccionando el nodo de AnimationPlayer
	## y volviendo únicos a la escena sus sub-recursos, para que no se mezclen con los otros
	## hermanos, ya que las animaciones califican como "Resources" y son únicos, y,
	## por lo tanto, compartidos.


func _physics_process(delta: float) -> void:
	position += direction * VELOCITY * delta


func _on_lifetime_timer_timeout() -> void:
	remove()


func remove() -> void:
	hitbox.collision_mask = 0
	set_physics_process(false)

	anim.play("hit")
	await anim.animation_finished 

	_remove()


## Esta función se llamaría desde "hit" al terminar la animación
func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if not is_enemy_bullet and body.name == "Player":
		return
		
	if is_enemy_bullet and "Turret" in body.name:
		return
		
	if body.has_method("notify_hit"):
		body.notify_hit()
		
	queue_free()
