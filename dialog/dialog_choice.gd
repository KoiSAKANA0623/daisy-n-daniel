@tool
extends DialogItem
class_name DialogChoice

var dialog_branches : Array[DialogBranch] ## MUST HAVE TWO DIALOG BRANCH NODES



func _ready() -> void:
	if Engine.is_editor_hint():
		return

	for c in get_children():
		if c is DialogBranch:
			dialog_branches.append(c)



func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_branch() == false:
		return ["Requires at least two DialogBranch nodes!"]
	else:
		return []



func _check_for_dialog_branch() -> bool:
	var count := 0
	for c in get_children():
		if c is DialogBranch:
			count += 1
			if count >= 2:
				return true
	return false
