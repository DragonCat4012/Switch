extends Control

@onready var scoreLabel := $ColorRect/CenterContainer/VBoxContainer/Label

func _ready():
	scoreLabel.text = "Your Score: 0"
	GameManager.jsonHandler.loadGame()
	scoreLabel.text = "Your Score: " + str(GameManager.jsonHandler.score)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") or  Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
