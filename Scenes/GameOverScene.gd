extends Node2D

@onready var scoreLabel = $ColorRect/CenterContainer/VBoxContainer/Label
const JSONHandler = preload("res://JSON.gd")
@onready var jsonHandler = JSONHandler.JSONHandler.new()

func _ready():
	scoreLabel.text = "Your Score: 0"
	jsonHandler.loadGame()
	scoreLabel.text = "Your Score: " + str(jsonHandler.score)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") or  Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
