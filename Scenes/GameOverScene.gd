extends Node2D

@onready var scoreLabel := $ColorRect/CenterContainer/VBoxContainer/Label
@onready var backButton := $ColorRect/CenterContainer/buttonBackTexture/BackButon

func _ready():
	scoreLabel.text = "Your Score: 0"
	GameManager.jsonHandler.loadGame()
	scoreLabel.text = "Your Score: " + str(GameManager.jsonHandler.score)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") or  Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		
func _input(event):
	if backButton.get_global_rect().has_point(get_global_mouse_position()) and event is InputEventScreenTouch:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
