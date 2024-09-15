extends Node2D

@onready var backButton := %BackButonClass


func _input(event): # Handle Touch Inut
	var globalRect = backButton.get_global_rect()
	if globalRect.has_point(get_global_mouse_position()) and event is InputEventScreenTouch:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
