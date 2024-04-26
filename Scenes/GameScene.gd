extends MarginContainer
#const first_scene = preload("res://menu.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
