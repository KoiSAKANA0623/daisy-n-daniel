extends DialogItem
class_name DialogBranch

@export var text : String = "Maybe"

var dialog_items : Array[DialogItem]

func _ready():
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
