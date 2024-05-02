extends MarginContainer

const JSONHandler = preload("res://JSON.gd")
@onready var jsonHandler = JSONHandler.JSONHandler.new()

@onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector
@onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector2
@onready var selector_three = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector3
@onready var labelTutorial = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/TutorialLabel
@onready var labelStart = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/LabelStart
@onready var labelExit = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/LabelExit
@onready var labelHighScore = $CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/HighScoreLabel
var currentSelection = 0
var lastSelection = 0

func _ready():
	jsonHandler.loadGame()
	if jsonHandler.score > 0:
		labelHighScore.text = "Highscore: " + str(jsonHandler.score)
	else:
		labelHighScore = ""
	set_current_selection()
	
func _input(event): # Handle Touch Inut
	var newSelection = -1
	if event is InputEventScreenTouch:
		if labelTutorial.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 1
		elif labelStart.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 0
		elif labelExit.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 2
		else:
			return
		
		if currentSelection == newSelection:
			handle_selection(currentSelection)
		else:
			currentSelection = newSelection
			set_current_selection()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		currentSelection += 1
	elif Input.is_action_just_pressed("ui_up"):
		currentSelection -= 1
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	set_current_selection()
	if Input.is_action_just_pressed("ui_accept"):
		handle_selection(currentSelection)
	
func handle_selection(_current_selection):
	if _current_selection == 0: #start option
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif _current_selection == 1: # Options
		get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
	elif _current_selection == 2: # Exit
		get_tree().quit()
	
func set_current_selection():
	if currentSelection < 0:
		currentSelection = 2
	if currentSelection > 2:
		currentSelection = 0
		
	if currentSelection != lastSelection:
		if not $"../AudioStreamPlayer".playing:
			$"../AudioStreamPlayer".play()
		
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
		
	if currentSelection == 0 :
		selector_one.text = ">"
	elif currentSelection == 1:
		selector_two.text = ">"
	elif currentSelection == 2:
		selector_three.text=">"
		
	lastSelection = currentSelection
