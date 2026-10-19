@tool
extends PanelContainer

@onready var input: Label = %Input
@onready var action: Label = %Action

@export var action_input: String:
	set = _set_action_input
@export var action_name: String:
	set = _set_action_name


func _ready() -> void:
	input.text = action_input
	action.text = action_name


func _set_action_input(inp: String) -> void:
	action_input = inp
	if Engine.is_editor_hint() and has_node("%Input"):
		%Input.text = inp


func _set_action_name(nm: String) -> void:
	action_name = nm
	if Engine.is_editor_hint() and has_node("%Action"):
		%Action.text = nm
