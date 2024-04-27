extends Node2D

@onready var scoreLabel = $ColorRect/CenterContainer/VBoxContainer/Label
const File_name = "user://saves.json"

func _ready():
	scoreLabel.text = "Your Score: 0"
	loadOptions()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func loadOptions():
	if FileAccess.file_exists((File_name)):
		var file = FileAccess.open(File_name, FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		var score = int(dict["Score"])
		scoreLabel.text = "Your Score: " + str(score)
