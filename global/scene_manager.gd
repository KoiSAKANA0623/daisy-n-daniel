class_name SceneManager extends Node

@onready var LoadedScene: Node2D = $LoadedScene

@onready var Player_S : player_char = $LoadedScene/Player
@onready var Camera_S : Camera2D = $LoadedScene/Camera

@onready var Transitions = $Transitions

var current_scene


func _init() -> void:
	Global.scene_manager = self



func _ready() -> void:
	current_scene = $LoadedScene/test ## CHANGE TO MAIN MENU / SPLASH SCREEN WHEN DONE TESTING!!!



func change_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_scene != null:
		if delete:
			current_scene.queue_free()
		elif keep_running:
			current_scene.visable = false
		else:
			remove_child(current_scene)
	var new = load(new_scene).instantiate()
	LoadedScene.add_child(new)
	current_scene = new



const SFX_DoorClose = preload("res://sound/misc/door_close.wav")
const SFX_DoorOpen = preload("res://sound/misc/door_open.wav")
func change_scene_doorway(new_scene: String, exit_location: Vector2, orientation: int) -> void:
	## Insert scene change
	Player_S.global_position.x = (exit_location.x * 16) + 8
	Player_S.global_position.y = (exit_location.y * 16) + 8


func movein_scene_doorway(exit_location: Vector2, orientation: int) -> void:
	Global.audio_manager.play_sound(1, SFX_DoorOpen, Player_S.global_position)
	transition_to(2)
	Global.scene_manager.Player_S.is_enabled = false
	await get_tree().create_timer(0.5).timeout
	Player_S.global_position.x = (exit_location.x * 16) + 8
	Player_S.global_position.y = (exit_location.y * 16) + 8
	Player_S.prev_x.resize(Player_S.PREVPOSAM*4)
	Player_S.prev_x.fill(Player_S.global_position.x)
	Player_S.prev_y.resize(Player_S.PREVPOSAM*4)
	Player_S.prev_y.fill(Player_S.global_position.y)
	Player_S.next_position = Player_S.global_position
	match orientation:
		1:
			Player_S.Anim.play("Down")
			Player_S.direction = Vector2.DOWN
		2:
			Player_S.Anim.play("Up")
			Player_S.direction = Vector2.UP
		3:
			Player_S.Anim.play("Left")
			Player_S.direction = Vector2.LEFT
		4:
			Player_S.Anim.play("Right")
			Player_S.direction = Vector2.RIGHT
	Player_S.Anim.stop()
	transition_to(3)
	Global.audio_manager.play_sound(1, SFX_DoorClose, Player_S.global_position)
	await get_tree().create_timer(0.2).timeout
	Global.scene_manager.Player_S.is_enabled = true
	Global.scene_manager.Player_S.can_move = true



func transition_to(type: int) -> void:
	match type:
		0:
			Transitions.Anim.play("FadeOut")
		1:
			Transitions.Anim.play("FadeIn")
		2:
			Transitions.Anim.play("MosaicFadeOut")
		3:
			Transitions.Anim.play("MosaicFadeIn")
