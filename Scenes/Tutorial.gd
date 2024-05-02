extends Node2D

@onready var textField = $ColorRect/Label
@onready var picture = $ColorRect/Sprite2D
@onready var e = $ColorRect
var imgCount = 11
var currentIndex = 0
var texts =  ["This is a lamp", "This is an active lamp", "These are wires connecting lamps and stuff",
"These are switches", "They can change the lamps status", "This is the number we want to display in Binary (lamp on = 1, lamp off = 0)",
"This is our current number displayed by the lamps", "This is your current score", "Your time left in seconds, You will loose if you run out of time", "The current map", 
"From where to read the number in Binary. You´ve finished the tutorial"]
var lastClick = Time.get_ticks_msec()

func _ready():
	textField.text = texts[0]
	picture.texture = load("res://Sprites/Tutorial/t_0.JPG")
	
func _input(event): # Handle Touch Inut
	var globalRect = e.get_global_rect()
	var currentClickTime = Time.get_ticks_msec()

	if globalRect.has_point(get_global_mouse_position()) and event is InputEventScreenTouch and currentClickTime > lastClick + 0.8*1000:
		lastClick = Time.get_ticks_msec()
		if globalRect.size.y > 1920/2:
			nextImg()
		else:
			beforeImage()
			
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		nextImg()
	elif Input.is_action_just_pressed("ui_left"):
		beforeImage()
	elif Input.is_action_just_pressed("ui_right"):
		nextImg()
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func nextImg():
	currentIndex += 1
	if currentIndex == imgCount:
		# Go back to main
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		currentIndex = imgCount-1
	_updateUI()
	
func beforeImage():
	currentIndex -= 1
	if currentIndex < 0:
		currentIndex = 0
	_updateUI()

func _updateUI():
	textField.text = texts[currentIndex]
	picture.texture = load("res://Sprites/Tutorial/t_" + str(currentIndex) +".JPG")
