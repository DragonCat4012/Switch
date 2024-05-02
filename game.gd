extends Node2D

# Settings
const JSONHandler = preload("res://JSON.gd")
@onready var jsonHandler = JSONHandler.JSONHandler.new()
var isEndianSwitchingEnabled = true

# Nodes
@onready var lamp1 = $"MarginContainer/Lamp 1"
@onready var lamp2 = $"MarginContainer/Lamp 2"
@onready var lamp3 = $"MarginContainer/Lamp 3"
@onready var lamp4 = $"MarginContainer/Lamp 4"
@onready var lamp5 = $"MarginContainer/Lamp 5"
@onready var lamp6 = $"MarginContainer/Lamp 6"
@onready var lamp7 = $"MarginContainer/Lamp 7"

@onready var numberLabel = $CenterContainer/VBoxContainer/NumberLabel
@onready var numberPreviewLabel = $CenterContainer/VBoxContainer/NumberPreview
@onready var scoreLabel = $CenterContainer2/ScoreLabel
@onready var mapLabel = $CenterContainer3/HBoxContainer/MapLabel
@onready var backButton = $ColorRect/buttonBackTexture/BackButon
# Audio
@onready var audioPlayer = $"AudioStreamPlayer"

# Map
@onready var mapObject = $MarginContainer/Map
@onready var timerLabel = $CenterContainer3/HBoxContainer/TimerLabel
var mapRessources = ["res://Sprites/Maps/map_0.PNG","res://Sprites/Maps/map_1.PNG","res://Sprites/Maps/map_2.PNG"]
var mapIndex = 0

# Current Game
var currentNumber = 0
var goalNumber = -1
var smallEndian = false

# General
var timerLeft = 0
var score = 0

# Timer
var timerTime = 50
var timerIteration = 0
var timer = Timer.new()

var map_dict = { # key=switch, value=lamp
	2: {
		1: 4,
		2: 3,
		3: 5,
		4: 2,
		5: 1,
		6: 5,
		7: 7,
		8: 6
	},
	0: {
		1: 1,
		2: 4,
		3: 2,
		4: 3,
		5: 1,
		6: 7,
		7: 5,
		8:6
	},
	1: {
		1: 4,
		2: 1,
		3: 3,
		4: 2,
		5: 3,
		6: 7,
		7: 6,
		8: 5
	}
}

func _ready():
	jsonHandler.loadGame()
	isEndianSwitchingEnabled = jsonHandler.endian
	scoreLabel.text = "Score: 0"
	
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	
	_init_game()
	
func _on_timer_timeout():
	timer.stop()
	jsonHandler.saveScore(score)
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
	timerLabel.text = str(round(timer.time_left)) + " s"
	
	if timer.time_left <= 5:
		var red = Color(1.0,0.0,0.0,1.0)
		timerLabel.set("theme_override_colors/font_color",red)
		
func _input(event): # Handle Touch Inut
	var globalRect = backButton.get_global_rect()
	if globalRect.has_point(get_global_mouse_position()) and event is InputEventScreenTouch:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 

func _init_game():
	setupt_map()
	lamp1.reset()
	lamp2.reset()
	lamp3.reset()
	lamp4.reset()
	lamp5.reset()
	lamp6.reset()
	lamp7.reset()
	initNumber()
	updateCurrentNumber(true)
	
	if isEndianSwitchingEnabled:
		smallEndian = randi()% 2 == 0
	else:
		smallEndian = false
		
	updateEndian()
	timer.wait_time = timerTime
	var white = Color(1.0,1.0,1.0,1.0)
	timerLabel.set("theme_override_colors/font_color", white)
	timer.start()
	
func updateEndian():
	if smallEndian:
		$HBoxContainer/LeftArrow.text = ">"
		$HBoxContainer/RightArrow.text = ""
	else:
		$HBoxContainer/LeftArrow.text = ""
		$HBoxContainer/RightArrow.text = "<"
		
func switch_activated(_switch_number, _isOn):
	if not audioPlayer.playing:
			audioPlayer.play()
	toggleLamp(map_dict[mapIndex][_switch_number])
	
func toggleLamp(_lampID):
	if _lampID == 1:
		lamp1.toggleStatus()
	elif _lampID == 2:
		lamp2.toggleStatus()
	elif _lampID == 3:
		lamp3.toggleStatus()
	elif _lampID == 4:
		lamp4.toggleStatus()
	elif _lampID == 5:
		lamp5.toggleStatus()
	elif _lampID == 6:
		lamp6.toggleStatus()
	elif _lampID == 7:
		lamp7.toggleStatus()
	updateCurrentNumber()

func initNumber():
	var num = randi_range(1, 127)
	numberLabel.text = str(num)
	goalNumber = num 
	
func updateCurrentNumber(_init = false):
	var x = 0
	if smallEndian:
		if lamp1.isOn:
			x += 1
		if lamp2.isOn:
			x += 2
		if lamp3.isOn:
			x += 4
		if lamp4.isOn:
			x += 8
		if lamp5.isOn:
			x += 16
		if lamp6.isOn:
			x += 32
		if lamp7.isOn:
			x += 64
	else:
		if lamp7.isOn:
			x += 1
		if lamp6.isOn:
			x += 2
		if lamp5.isOn:
			x += 4
		if lamp4.isOn:
			x += 8
		if lamp3.isOn:
			x += 16
		if lamp2.isOn:
			x += 32
		if lamp1.isOn:
			x += 64
	currentNumber = x
	numberPreviewLabel.text = str(currentNumber)
	
	if x == goalNumber and _init: # prevent instant success qwq
		lamp1.toggleStatus()
	elif x == goalNumber:
		score += int(timer.time_left)
		timerIteration += 1
		if timerIteration == 40:
			timerTime -= 10
		if timerIteration == 30:
			timerTime -= 10
		elif timerIteration == 20:
			timerTime -= 10
		elif timerIteration == 10:
			timerTime -= 10
		scoreLabel.text = "Score: " + str(score)
		_init_game()
	
# Map
func setupt_map():
	mapIndex = randi_range(0, len(mapRessources)-1)
	mapObject.texture = load(mapRessources[mapIndex])
	mapLabel.text = "["+str(mapIndex)+"]"

# Timer
func resetTimer():
	score = 0
	timerLeft = 0
	
func startTimer():
	timerLeft = 50
