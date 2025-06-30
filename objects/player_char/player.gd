extends CharacterBody2D
class_name player_char

@onready var UpRay = $MoveCheckRays/Up_Ray
@onready var DownRay = $MoveCheckRays/Down_Ray
@onready var LeftRay = $MoveCheckRays/Left_Ray
@onready var RightRay = $MoveCheckRays/Right_Ray

@export var PlayerSprite: Node2D
var Anim: AnimationPlayer

@export var is_enabled := true

@export var follow_1: Node2D
@export var follow_2: Node2D
@export var follow_3: Node2D

var direction := Vector2.ZERO
var next_position := Vector2.ZERO
var is_move := false
var can_move := true

var prev_x : Array
var prev_y : Array
var prev_anim : Array

var step_walked := 0.0
const WALKSPEED := 1.25
const PREVPOSAM := 16



func _ready():
	next_position = global_position

	Anim = PlayerSprite.get_node("Anim")

	prev_x.resize(PREVPOSAM*4)
	prev_x.fill(global_position.x)
	prev_y.resize(PREVPOSAM*4)
	prev_y.fill(global_position.y)
	prev_anim.resize(PREVPOSAM*4)
	prev_anim.fill(Anim.current_animation)

	if follow_1 != null:
		follow_1.global_position.x = prev_x[0]
		follow_1.global_position.y = prev_y[0]-4
	if follow_2 != null:
		follow_2.global_position.x = prev_x[0]
		follow_2.global_position.y = prev_y[0]-4
	if follow_3 != null:
		follow_3.global_position.x = prev_x[0]
		follow_3.global_position.y = prev_y[0]-4



func _unhandled_input(event):
	if event.is_action_pressed("Interact") && !is_move:
		if DownRay.is_colliding() && direction == Vector2.DOWN:
			Global.interact_obj.emit()
		elif UpRay.is_colliding() && direction == Vector2.UP:
			Global.interact_obj.emit()
		elif LeftRay.is_colliding() && direction == Vector2.LEFT:
			Global.interact_obj.emit()
		elif RightRay.is_colliding() && direction == Vector2.RIGHT:
			Global.interact_obj.emit()



func _physics_process(delta):
	if !is_enabled:
		is_move = false
		next_position = global_position
		return

	followers(direction)
	walk_next_tile(direction)

	if !is_move && can_move:
		if Input.is_action_pressed("Down"):
			if !DownRay.is_colliding():
				next_position = global_position + Vector2(0, 16)
				is_move = true
			direction = Vector2.DOWN
		elif Input.is_action_pressed("Up"):
			if !UpRay.is_colliding():
				next_position = global_position + Vector2(0, -16)
				is_move = true
			direction = Vector2.UP
		elif Input.is_action_pressed("Left"):
			if !LeftRay.is_colliding():
				next_position = global_position + Vector2(-16, 0)
				is_move = true
			direction = Vector2.LEFT
		elif Input.is_action_pressed("Right"):
			if !RightRay.is_colliding():
				next_position = global_position + Vector2(16, 0)
				is_move = true
			direction = Vector2.RIGHT

	animation()



func walk_next_tile(direc) -> void:
	if is_move:
		match direc:
			Vector2.DOWN:
				global_position.y += WALKSPEED
			Vector2.UP:
				global_position.y -= WALKSPEED
			Vector2.LEFT:
				global_position.x -= WALKSPEED
			Vector2.RIGHT:
				global_position.x += WALKSPEED
		step_walked += WALKSPEED

		if step_walked >= 16.0:
			is_move = false
			step_walked = 0.0
			global_position = next_position



func _on_door_check_entered(area: Area2D) -> void:
	if area.is_in_group("Doorway"):
		can_move = false



func animation() -> void:
	if is_move:
		Anim.speed_scale = 1.1
		match direction:
			Vector2.DOWN: Anim.play("Down")
			Vector2.UP: Anim.play("Up")
			Vector2.LEFT: Anim.play("Left")
			Vector2.RIGHT: Anim.play("Right")
	else:
		Anim.speed_scale = 1.0
		match direction:
			Vector2.DOWN: Anim.play("Down")
			Vector2.UP: Anim.play("Up")
			Vector2.LEFT: Anim.play("Left")
			Vector2.RIGHT: Anim.play("Right")
		Anim.stop()



## Follower related code.



func followers(input_dir) -> void:
	if input_dir && is_move:
		prev_x.push_front(global_position.x)
		prev_x.resize(PREVPOSAM*4)
		prev_y.push_front(global_position.y)
		prev_y.resize(PREVPOSAM*4)
		prev_anim.push_front(Anim.current_animation)
		prev_anim.resize(PREVPOSAM*4)

	if follow_1 != null:
		follow_1.global_position.x = prev_x[PREVPOSAM]
		follow_1.global_position.y = prev_y[PREVPOSAM]
		if !Anim.is_playing():
			follow_1.get_node("Anim").speed_scale = 1.0
			follow_1.get_node("Anim").stop()
		else:
			follow_1.get_node("Anim").speed_scale = 1.1
			follow_1.get_node("Anim").play(prev_anim[PREVPOSAM])

	if follow_2 != null:
		follow_2.global_position.x = prev_x[(PREVPOSAM*2)]
		follow_2.global_position.y = prev_y[(PREVPOSAM*2)]
		if !Anim.is_playing():
			follow_2.get_node("Anim").speed_scale = 1.0
			follow_2.get_node("Anim").stop()
		else:
			follow_2.get_node("Anim").speed_scale = 1.1
			follow_2.get_node("Anim").play(prev_anim[PREVPOSAM*2])

	if follow_3 != null:
		follow_3.global_position.x = prev_x[(PREVPOSAM*3)]
		follow_3.global_position.y = prev_y[(PREVPOSAM*3)]
