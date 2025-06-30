extends Camera2D

@export var Focus : Node2D


func _process(delta: float) -> void:
	if Focus is player_char:
		global_position.x = Focus.global_position.x
		global_position.y = Focus.global_position.y - 12.0
