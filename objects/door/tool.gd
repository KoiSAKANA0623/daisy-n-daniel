@tool
extends Node


@onready var DLabel = $"../Label"


func _ready() -> void:
	var parent = get_parent()
	if Engine.is_editor_hint():
		DLabel.visible = true
	else:
		DLabel.visible = false



func _process(delta: float) -> void:
	var parent = get_parent()
	if parent.new_scene:
		DLabel.text = parent.new_scene
	else:
		DLabel.text = "Default to Same Scene!"
