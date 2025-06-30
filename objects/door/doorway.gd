extends Node2D

@export var new_scene : String

## In tiles.
@export var exit_location := Vector2(0, 0)

## 1 = Down, 2 = Up, 3 = Left, 4 = Right
@export_range(1, 4) var orientation := 1

@onready var DLabel = $Label

var can_enter := false



func _process(delta: float) -> void:
	if can_enter:
		if Global.scene_manager.Player_S.next_position == Global.scene_manager.Player_S.global_position:
			can_enter = false
			if new_scene:
				Global.scene_manager.change_scene_doorway(new_scene, exit_location, orientation)
				return
			else:
				Global.scene_manager.movein_scene_doorway(exit_location, orientation)
				return



func _on_door_entered(body: Node2D) -> void:
	if body is player_char:
		can_enter = true
