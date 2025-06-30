extends Node
class_name YSortNode

@export var parent : Node2D


#func _ready() -> void:
#	pass


func _process(delta: float) -> void:
	parent.z_index = int(parent.global_position.y/8)
