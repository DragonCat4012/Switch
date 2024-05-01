extends MarginContainer

#const first_scene = preload("res://game.tscn")

@onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector
@onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector2
@onready var selector_three = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer/Selector3
@onready var labelTutorial = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/Label
@onready var labelStart = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/Label2
@onready var labelExit = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/VBoxContainer2/Label3

var currentSelection = 0
var lastSelection = 0

func _ready():
	set_current_selection(0)
	
func _input(event): # Handle Touch Inut
	var newSelection = 0
	if event is InputEventMouseButton:
		if labelTutorial.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 1
		if labelStart.get_global_rect().has_point(get_global_mouse_position()):
			newSelection = 0
		if labelTutorial.get_global_rect().has_point(get_global_mouse_position()):
			labelExit = 2
			
	if currentSelection == newSelection:
		handle_selection(currentSelection)
	else:
		currentSelection = newSelection
		set_current_selection(newSelection)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		currentSelection += 1
	elif Input.is_action_just_pressed("ui_up"):
		currentSelection -= 1
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if currentSelection < 0:
		currentSelection = 2
	if currentSelection > 2:
		currentSelection = 0
		
	set_current_selection(currentSelection)
	if Input.is_action_just_pressed("ui_accept"):
		handle_selection(currentSelection)
	
func handle_selection(_current_selection):
	if _current_selection == 0: #start option
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
	elif _current_selection == 1: # Options
		get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
	elif _current_selection == 2: # Exit
		get_tree().quit()
	
func set_current_selection(_current_selection):
	if currentSelection != lastSelection:
		if not $"../AudioStreamPlayer".playing:
			$"../AudioStreamPlayer".play()
		
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
		
	if _current_selection == 0 :
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text=">"
		
	lastSelection = _current_selection
