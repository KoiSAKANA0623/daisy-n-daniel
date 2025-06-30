class_name AudioManager extends Node


@export var Music_Volume := 0.0
@export var Sound_Volume := 0.0


@onready var music_strm = $Music/MusStream

@onready var strm_1 = $SFX/Stream_1
@onready var strm_2 = $SFX/Stream_2
@onready var strm_3 = $SFX/Stream_3
@onready var strm_4 = $SFX/Stream_4

## Sounds
# PUT STUFF HERE

## Music
# MENU MUSIC MAYBE???



func _init() -> void:
	Global.audio_manager = self



func play_music(mus2play) -> void:
	music_strm.stream = load(mus2play)
	music_strm.play()



func play_sound(stream_num: int, sfx2play, position: Vector2) -> void:
	match stream_num:
		1:
			move_strm(strm_1, position)
			strm_1.stream = sfx2play
			strm_1.play()
		2:
			move_strm(strm_2, position)
			strm_2.stream = sfx2play
			strm_2.play()
		3:
			move_strm(strm_3, position)
			strm_3.stream = sfx2play
			strm_3.play()
		4:
			move_strm(strm_4, position)
			strm_4.stream = sfx2play
			strm_4.play()



func move_strm(strm, position) -> void:
	strm.global_position = position
	return
