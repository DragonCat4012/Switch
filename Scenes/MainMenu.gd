extends MarginContainer

@onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector
@onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector2
@onready var selector_three = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector3
@onready var selector_four =$CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector4
@onready var selector_five =$CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector5
@onready var selector_six =$CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector6

@onready var labelStart := $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/LabelStart
@onready var labelAchievemnts := $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/AchievLabel
@onready var labelTutorial := $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/TutorialLabel
@onready var labelOptions := $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/LabelOptions
@onready var labelExit := $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/LabelExit
@onready var labelMultiplayer := $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/LabelMultiplayer
@onready var labelHighScore: Label = $CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/HighScoreLabel

var currentSelection = 0
var lastSelection = 0

func _ready():
	AudioManager.play_music_background()
	GameManager.jsonHandler.loadGame()
	if GameManager.jsonHandler.highScore > 0:
		labelHighScore.text = "Highscore: " + str(GameManager.jsonHandler.highScore)
	else:
		labelHighScore.text = ""
	set_current_selection()
	
func _input(event): # Handle Touch Inut
	var newSelection = -1
	if event is InputEventScreenTouch:
		if labelStart.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 0
		elif labelAchievemnts.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 1
		elif labelTutorial.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 2
		elif labelOptions.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 3
		elif labelMultiplayer.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 4
		elif labelExit.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 5
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
	elif _current_selection == 1: # Achievments
		get_tree().change_scene_to_file("res://Scenes/Achievments.tscn")
	elif _current_selection == 2: # Tutorial
		get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
	elif _current_selection == 3: # Options
		print("e")
		get_tree().change_scene_to_file("res://Scenes/Options/OptionsScene.tscn")
	elif _current_selection == 4: # Multiplayer
		get_tree().change_scene_to_file("res://Scenes/Multiplayer/KoopMultiplayerScene.tscn")
	elif _current_selection == 5: # Exit
		get_tree().quit()
	
func set_current_selection():
	if currentSelection < 0:
		currentSelection = 5
	if currentSelection > 5:
		currentSelection = 0
		
	if currentSelection != lastSelection:
		AudioManager.playZap()
		
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	selector_four.text = ""
	selector_five.text = ""
	selector_six.text = ""
	
	if currentSelection == 0 :
		selector_one.text = ">"
	elif currentSelection == 1:
		selector_two.text = ">"
	elif currentSelection == 2:
		selector_three.text=">"
	elif currentSelection == 3:
		selector_four.text=">"
	elif currentSelection == 4:
		selector_five.text=">"
	elif currentSelection == 5:
		selector_six.text=">"	
	lastSelection = currentSelection
