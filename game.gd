extends Node2D

# Settings
const File_name = "user://saves.json"
var isEndianSwitchingEnabled = true

# Nodes
@onready var lamp1 = $"MarginContainer/Lamp 1"
@onready var lamp2 = $"MarginContainer/Lamp 2"
@onready var lamp3 = $"MarginContainer/Lamp 3"
@onready var lamp4 = $"MarginContainer/Lamp 4"
@onready var numberLabel = $CenterContainer/VBoxContainer/NumberLabel
@onready var numberPreviewLabel = $CenterContainer/VBoxContainer/NumberPreview
@onready var scoreLabel = $CenterContainer2/ScoreLabel
@onready var audioPlayer = $"AudioStreamPlayer"

# Current Game
var currentNumber = 0
var goalNumber = -1
var smallEndian = false

# General
var score = 0

var map_dict = { # key=switch, value=lamp
	1: 4,
	2: 1,
	3:3,
	4:4, 
	5:2, 
	6:3
}

func _ready():
	loadOptions()
	scoreLabel.text = "Score: 0"
	_init_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://menu.tscn")

func loadOptions():
	if FileAccess.file_exists((File_name)):
		var file = FileAccess.open(File_name, FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		isEndianSwitchingEnabled = dict[isEndianSwitchingEnabled]

func _init_game():
	lamp1.reset()
	lamp2.reset()
	lamp3.reset()
	lamp4.reset()
	initNumber()
	updateCurrentNumber(true)
	
	if isEndianSwitchingEnabled:
		smallEndian = randi()% 2 == 0
	else:
		smallEndian = false
	updateEndian()
	
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
	toggleLamp(map_dict[_switch_number])
	
func toggleLamp(_lampID):
	if _lampID == 1:
		lamp1.toggleStatus()
	elif _lampID == 2:
		lamp2.toggleStatus()
	elif _lampID == 3:
		lamp3.toggleStatus()
	elif _lampID == 4:
		lamp4.toggleStatus()
	updateCurrentNumber()

func initNumber():
	var num = randi_range(1, 12)
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
	else:
		if lamp4.isOn:
			x += 1
		if lamp3.isOn:
			x += 2
		if lamp2.isOn:
			x += 4
		if lamp1.isOn:
			x += 8
		
	currentNumber = x
	numberPreviewLabel.text = str(currentNumber)
	
	if x == goalNumber and _init: # prevent instant success qwq
		lamp1.toggleStatus()
	elif x == goalNumber:
		score += 1
		scoreLabel.text = "Score: " + str(score)
		_init_game()
	
