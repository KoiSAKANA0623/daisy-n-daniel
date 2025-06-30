extends CanvasLayer
class_name DialogueScene

signal finished
signal letter_add( letter: String)

@onready var dialogueUI = $DialogUI
@onready var TextBox = $DialogUI/MainBox/Text
@onready var TimerT = $Timer
@onready var Arrow = $DialogUI/Arrow
@onready var ChArrow = $DialogUI/ChoiceBox/ChoiceArrow
@onready var Voiceblip = $Text_Sound
@onready var Clearblip = $ClearTXT_Sound
@onready var ChoiceOptions = $DialogUI/Choice
@onready var ChoiceBox = $DialogUI/ChoiceBox

var text_speed := 1.0/60.0

var text_in_progress := false

var wait_for_choice := false

var text_length := 0
var is_active := false
var plain_text : String

var dialog_items : Array[ DialogItem ]
var dialog_item_index := 0

var text_sound : AudioStream


func _ready():
	TimerT.timeout.connect( _on_timer_timeout )
	hide_dialogue()


func _unhandled_input(event):
	if is_active == false:
		return
	if event.is_action_pressed("Interact"):
		if text_in_progress == true:
			TextBox.visible_characters = text_length
			TimerT.stop()
			text_in_progress = false
			Arrow.visible = true
			return
		elif wait_for_choice == true:
			return

		dialog_item_index += 1
		Clearblip.play()
		if dialog_item_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialogue()



func _process(delta: float) -> void:
	if get_viewport().gui_get_focus_owner():
		ChArrow.global_position.y = get_viewport().gui_get_focus_owner().global_position.y + 8



#func show_dialogue(_items: Array[ DialogItem ], sound: AudioStream) -> void:
func show_dialogue(_items: Array[ DialogItem ]) -> void:
	is_active = true
	dialogueUI.visible = true
	dialogueUI.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_items = _items
	dialog_item_index = 0
	Arrow.visible = false
	get_tree().paused = true
#	text_sound = sound
	TextBox.visible_characters = 0
	await get_tree().process_frame
	if dialog_items.size() == 0:
		hide_dialogue()
	else:
		start_dialog()


func hide_dialogue() -> void:
	is_active = false
	dialogueUI.visible = false
	ChoiceOptions.visible = false
	ChoiceBox.visible = false
	dialogueUI.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()


func start_dialog() -> void:
	wait_for_choice = false
	var _d : DialogItem = dialog_items[ dialog_item_index ]

	if _d is DialogText:
		set_dialog_text( _d as DialogText )
	elif _d is DialogChoice:
		set_dialog_choice( _d as DialogChoice )



func set_dialog_text( _d : DialogText ) -> void:
	TextBox.text = _d.text
	TextBox.visible_characters = 0
	text_length = TextBox.get_total_character_count()
	plain_text = TextBox.get_parsed_text()
	text_in_progress = true
	start_timer()


func set_dialog_choice( _d : DialogChoice) -> void:
	wait_for_choice = true
	for c in ChoiceOptions.get_children():
		c.queue_free()

	for i in _d.dialog_branches.size():
		var new_choice : Button = Button.new()
		new_choice.text = _d.dialog_branches[i].text
		new_choice.alignment = HORIZONTAL_ALIGNMENT_LEFT
		new_choice.pressed.connect(dialog_choice_select.bind(_d.dialog_branches[i]))
		ChoiceOptions.add_child(new_choice)

	await get_tree().process_frame
	ChoiceOptions.visible = true
	ChoiceBox.visible = true
	ChoiceOptions.get_child(0).grab_focus()


func dialog_choice_select(_d : DialogBranch) -> void:
	ChoiceOptions.visible = false
	ChoiceBox.visible = false
	show_dialogue(_d.dialog_items)



func _on_timer_timeout():
	TextBox.visible_characters += 1
	if TextBox.visible_characters <= text_length:
		letter_add.emit(plain_text[TextBox.visible_characters - 1])
		Arrow.visible = false
		voice_plib(text_sound)
		start_timer()
	else:
		Arrow.visible = true
		text_in_progress = false


func start_timer() -> void:
	TimerT.wait_time = text_speed
#	var char = plain_text[TextBox.visible_characters - 1]
	TimerT.start()


var def_blip = preload("res://sound/text/def.wav")
func voice_plib(sound) -> void:
	match TextBox.text[TextBox.visible_characters - 1]:
		"!", "?", ",", ".", " ":
			pass
		_:
			if sound != null:
				Voiceblip.stream = sound
			else:
				Voiceblip.stream = def_blip
			Voiceblip.play()
