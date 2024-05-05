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

@onready var switch1 = $"MarginContainer/Switch 1"
@onready var switch2 = $"MarginContainer/Switch 2"
@onready var switch3 = $"MarginContainer/Switch 3"
@onready var switch4 = $"MarginContainer/Switch 4"
@onready var switch5 = $"MarginContainer/Switch 5"
@onready var switch6 = $"MarginContainer/Switch 6"
@onready var switch7 = $"MarginContainer/Switch 7"
@onready var switch8 = $"MarginContainer/Switch 8"

@onready var numberLabel = $CenterContainer/VBoxContainer/NumberLabel
@onready var numberPreviewLabel = $CenterContainer/VBoxContainer/NumberPreview
@onready var scoreLabel = $CenterContainer2/ScoreLabel
@onready var mapLabel = $CenterContainer3/HBoxContainer/MapLabel
@onready var backButton = $buttonBackTexture/BackButon

# Audio
@onready var audioPlayer = $"AudioStreamPlayer"

# Map
@onready var timerLabel = $CenterContainer3/HBoxContainer/TimerLabel
var mapIndex = 0
const WireHandler = preload("res://Wire.gd")
@onready var wireHandler = WireHandler.WireHandler.new()

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

var mapping_dict = {} # key=switch, value=lamp

func _ready():
	jsonHandler.loadGame()
	isEndianSwitchingEnabled = jsonHandler.endian
	scoreLabel.text = "Score: 0"
	
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	
	_init_game()
	createWires()
	
func _on_timer_timeout():
	timer.stop()
	jsonHandler.saveScore(score)
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		jsonHandler.saveScore(score)
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 

func _init_game():
	queue_redraw()
	mapLabel.text = "["+str(mapIndex)+"]"
	
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
	updateCurrentNumber()
		
func switch_activated(_switch_number, _isOn):
	if not audioPlayer.playing:
			audioPlayer.play()
	toggleLamp(mapping_dict[_switch_number])
	
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
	var num = randi_range(1, 128)
	numberLabel.text = str(num)
	goalNumber = num 
	
	if goalNumber == 128:
		numberLabel.text = ">> 128 <<"
		var red = Color(1.0,0.0,0.0,1.0)
		numberLabel.set("theme_override_colors/font_color",red)
	
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
func createWires():
	var arr = wireHandler.createMapping()
	setDict(arr)
	var minDiff = 40
	var minVec = Vector2(0, minDiff)
	var minDiffSwitch = 55
	var minswicthVec = Vector2(0, minDiffSwitch)

	var switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8]
	var lamps = [lamp1, lamp2, lamp3, lamp4, lamp5, lamp6, lamp7]
	
	var levelDistances = (switch1.position.y - lamp1.position.y) / lamps.size() - minDiffSwitch + minDiff # 69
	var levelPad: int = (levelDistances / lamps.size()) *2

	var line_width = 3
	
	for w in arr:
		var minY = switches[w.lamp-1].position.y - minDiffSwitch
		var maxLevelks = levelDistances * lamps.size() 
		
		var p3 = switches[w.switch-1].position - minswicthVec
		var p2 =  p3 - Vector2(0, maxLevelks - w.level * levelDistances) -  minswicthVec
		
		var p0 = lamps[w.lamp-1].position + minVec
		var p1 = Vector2(p0.x, p2.y)
		
		# up -down
		draw_line(p0, p1, w.color, line_width)
		# down-> up
		draw_line(p3, p2, w.color, line_width)
	 	# horizontal line
		draw_line(p1, p2, w.color, line_width)
		
func setDict(mapping):
	var dict = {} # switch: lamp
	for w in mapping:
		dict[w.switch] = w.lamp
	mapping_dict = dict
	
func _draw():
	createWires()
	
# Timer
func resetTimer():
	score = 0
	timerLeft = 0
	
func startTimer():
	timerLeft = 50
