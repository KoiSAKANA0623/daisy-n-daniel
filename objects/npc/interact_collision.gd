@tool
extends Area2D
class_name Interact

signal player_interacted
signal finished

@export var NPC : Node2D
@export var sound : AudioStream

@export var widthC := 16
@export var heightC := 16

var dialog_item : Array[ DialogItem ]

@export var enabled := true


func _ready():
	for c in get_parent().get_children():
		if c is DialogItem:
			dialog_item.append( c )


func _process(delta: float) -> void:
	$CollisionShape_1.scale.x = widthC
	$CollisionShape_2.scale.y = heightC


func player_interact() -> void:
	player_interacted.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	DialogScene.finished.connect( _on_dialog_finished )
#	DialogScene.show_dialogue(dialog_item , sound)
	DialogScene.show_dialogue(dialog_item)


func _on_body_entered(body):
	if body is player_char:
		if enabled == false || dialog_item.size() == 0:
			return
		Global.interact_obj.connect(player_interact)     


func _on_body_exited(body):
	if body is player_char:
		Global.interact_obj.disconnect(player_interact)


func _on_dialog_finished() -> void:
	DialogScene.finished.disconnect( _on_dialog_finished )
	finished.emit()
