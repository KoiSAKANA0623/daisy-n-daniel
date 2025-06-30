extends DialogItem
class_name DialogText

@export_multiline var text : String = "Placeholder! OH NO" : set = _set_text


func _set_text( value : String ) -> void:
	text = value
