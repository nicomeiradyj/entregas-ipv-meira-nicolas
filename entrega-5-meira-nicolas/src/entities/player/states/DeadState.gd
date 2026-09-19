extends PlayerState


func enter() -> void:
	character.died.emit()

	character.velocity.x = 0
	character.collision_layer = 0
	
	character._play_animation(&"die") 

func update(delta: float) -> void:
	character._handle_deacceleration(delta)
	character._apply_movement(delta)


func exit() -> void:
	return

func handle_input(_event: InputEvent) -> void:
	return


func handle_event(_event: StringName, _value = null) -> void:
	return

## Para este punto solo hay una animación reproduciendose
## por lo que podemos extraer el llamado a _remove desde la
## animación a esta función
func _on_animation_finished(_anim_name: StringName) -> void:
	character._remove()
