extends Node2D
# Nodes
@onready var lamp1 = $Lamps/Lamp_1
@onready var lamp2 = $Lamps/Lamp_2
@onready var lamp3 = $Lamps/Lamp_3
@onready var lamp4 = $Lamps/Lamp_4
@onready var lamp5 = $Lamps/Lamp_5
@onready var lamp6 = $Lamps/Lamp_6
@onready var lamp7 = $Lamps/Lamp_7

@onready var switch1 = $Switch_1
@onready var switch2 = $Switch_2
@onready var switch3 = $Switch_3
@onready var switch4 = $Switch_4
@onready var switch5 = $Switch_5
@onready var switch6 = $Switch_6
@onready var switch7 = $Switch_7
@onready var switch8 = $Switch_8

# Current Game
var score = 0
var currentNumber = 0
var goalNumber = -1

# Map
var mapping_dict = {} # key=switch, value=lamp
#@onready var timerLabel = $VBoxContainer/TimerLabel
const WireHandler = preload("res://Util/Wire.gd")
@onready var wireHandler = WireHandler.WireHandler.new()

# Timer
var timerLeft = 0
var timerTime = 50
var timerIteration = 0
var timer = Timer.new()

func _ready():
	AudioManager.play_music_background()
	GameManager.jsonHandler.loadGame()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 

func _init_game():
	queue_redraw()
	
	lamp1.reset()
	lamp2.reset()
	lamp3.reset()
	lamp4.reset()
	lamp5.reset()
	lamp6.reset()
	lamp7.reset()
	initNumber()
	
func initNumber():
	var num = randi_range(1, 128)
	#numberLabel.text = str(num)
	goalNumber = num 
	
	if goalNumber == 128:
		#numberLabel.text = ">> 128 <<"
		var red = Color(1.0,0.0,0.0,1.0)
		#numberLabel.set("theme_override_colors/font_color",red)
		GameManager.jsonHandler.add128achievement()
		
func switch_activated(_switch_number, _isOn):
	AudioManager.playZap()
	#toggleLamp(mapping_dict[_switch_number])
	
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
	
func updateCurrentNumber(_init = false):
	var x = 0
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
	currentNumber = x
	#numberPreviewLabel.text = str(currentNumber)
	if x == 127:
		GameManager.jsonHandler.addAllLightsOn()

	if x == goalNumber and _init: # prevent instant success qwq
		lamp1.toggleStatus()
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
		#scoreLabel.text = "Score: " + str(score)
		#_init_game()
