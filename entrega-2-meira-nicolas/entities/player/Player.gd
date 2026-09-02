extends Sprite2D

# las variables para el drag
var ACCELERATION = 1200
var H_SPEED_LIMIT = 400
var FRICTION_WEIGHT = 0.05

@onready var cannon:Sprite2D = $Cannon

var projectile_container: Node2D
var velocity: Vector2 = Vector2.ZERO 

func set_projectile_container(container:Node2D):
	cannon.projectile_container = container
	projectile_container = container

func _physics_process(delta):
	var direction_optimized:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	var mouse_position:Vector2 = get_global_mouse_position()
	var origen:Vector2 = global_position
	var direction_vector:Vector2 = mouse_position - origen
	
	cannon.look_at(mouse_position)
	
	if Input.is_action_just_pressed("fire"):
		cannon.fire()
	
	if direction_optimized != 0:
		#clamp funciona como una barrera
		velocity.x = clamp(velocity.x + (direction_optimized * ACCELERATION * delta), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		# lerp es inhterpolacion lineal, y va frenando cuando dejo de moverme
		velocity.x = lerp(velocity.x, 0.0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0.0
	
	position.x += velocity.x * delta
