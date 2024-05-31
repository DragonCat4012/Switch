extends Node2D

# Settings
var isEndianSwitchingEnabled = true

# Nodes
@onready var lamp1 = $Lamp_1
@onready var lamp2 = $Lamp_2
@onready var lamp3 = $Lamp_3
@onready var lamp4 = $Lamp_4
@onready var lamp5 = $Lamp_5
@onready var lamp6 = $Lamp_6
@onready var lamp7 = $Lamp_7
@onready var lamps = [lamp1, lamp2, lamp3, lamp4, lamp5, lamp6, lamp7]

@onready var switch1 = $Switch_1
@onready var switch2 = $Switch_2
@onready var switch3 = $Switch_3
@onready var switch4 = $Switch_4
@onready var switch5 = $Switch_5
@onready var switch6 = $Switch_6
@onready var switch7 = $Switch_7
@onready var switch8 = $Switch_8

@onready var numberLabel = $CenterContainer/VBoxContainer/NumberLabel
@onready var numberPreviewLabel = $CenterContainer/VBoxContainer/NumberPreview
@onready var scoreLabel = $VBoxContainer/ScoreLabel
@onready var backButton = $buttonBackTexture/BackButon

# Map
@onready var mapNode = $Map
var mapping_dict = {} # key=switch, value=lamp
@onready var timerLabel = $VBoxContainer/TimerLabel
const WireHandler = preload("res://Util/Wire.gd")
@onready var wireHandler = WireHandler.WireHandler.new()

# Current Game
var score = 0
var currentNumber = 0
var goalNumber = -1
var smallEndian = false

# Timer
var timerLeft = 0
var timerTime = 50
var timerIteration = 0
var timer = Timer.new()

func _ready():
	GameManager.jsonHandler.loadGame()
	isEndianSwitchingEnabled = GameManager.jsonHandler.endian
	scoreLabel.text = "Score: 0"
	
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	
	_init_game()
	createWires()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
		
	timerLabel.text = str(round(timer.time_left)) + " s"
	if timer.time_left <= 5.5:
		var red = Color(1.0,0.0,0.0,1.0)
		timerLabel.set("theme_override_colors/font_color",red)
		
func _input(event): # Handle Touch Inut
	var globalRect = backButton.get_global_rect()
	if globalRect.has_point(get_global_mouse_position()) and event is InputEventScreenTouch:
		GameManager.jsonHandler.saveScore(score)
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 

# Timer
func _on_timer_timeout():
	timer.stop()
	GameManager.jsonHandler.saveScore(score)
	GameManager.jsonHandler.saveLostMap()
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

# Game
func _init_game():
	queue_redraw()
	
	for lamp in lamps:
		lamp.reset()
		
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
	$HBoxContainer/LeftArrow.text = ">" if smallEndian else ""
	$HBoxContainer/RightArrow.text = "" if smallEndian else "<"
	updateCurrentNumber()
		
func switch_activated(_switch_number, _isOn):
	AudioManager.playZap()
	toggleLamp(mapping_dict[_switch_number])
	
func toggleLamp(_lampID):
	for lamp in lamps:
		if _lampID == lamp.get_meta("ID"):
			lamp.toggleStatus()
	
	updateCurrentNumber()

func initNumber():
	var num = randi_range(1, 128)
	numberLabel.text = str(num)
	goalNumber = num 
	
	if goalNumber == 128:
		numberLabel.text = ">> 128 <<"
		var red = Color(1.0,0.0,0.0,1.0)
		numberLabel.set("theme_override_colors/font_color",red)
		GameManager.jsonHandler.add128achievement()
	
func updateCurrentNumber(_init = false):
	var x = 0
	var arrSmallEndian = lamps.duplicate()
	
	if smallEndian: # reverse order if big endian
		arrSmallEndian.reverse()
		
	for index in range(arrSmallEndian.size()):
		var pw = index
		if arrSmallEndian[index].isOn:
			x+= 2**pw

	currentNumber = x
	numberPreviewLabel.text = str(currentNumber)
	if x == 127:
		GameManager.jsonHandler.addAllLightsOn()
	
	if _init: # prevent instant success qwq
		return
	elif x == goalNumber:
		score += int(timer.time_left)
		GameManager.jsonHandler.saveWonMap()
		
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
func createWires():
	var arr = wireHandler.createMapping()
	setDict(arr)
	
	var switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8]
	mapNode.setStuff(arr, switches, lamps)
	mapNode.createWires()
		
func setDict(mapping):
	var dict = {} # switch: lamp
	for w in mapping:
		dict[w.switch] = w.lamp
	mapping_dict = dict
	
func _draw():
	createWires()
