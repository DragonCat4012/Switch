extends Node2D
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

#UtilNodes
@onready var light_score_label = $VBoxContainer/LightScore
@onready var dark_score_label = $DarkInfo/DarkScore

@onready var light_timer_label = $VBoxContainer/LightTime
@onready var dark_timer_label = $DarkInfo/DarkTime

# Number Nodes
@onready var light_goal_number = $LightNums/LightGoal
@onready var dark_goal_number = $DarkNums/DarkGoal

@onready var light_current_number = $LightNums/LightCurrent
@onready var dark_current_number = $DarkNums/DarkCurrent


@onready var backButton = $buttonBackTexture/BackButon
# Current Game
var score = 0
var currentNumber = 0
var goalNumber = -1

# Map
@onready var mapNode = $Map
var mapping_dict = {} # key=switch, value=lamp
const WireHandler = preload("res://Util/Wire.gd")
@onready var wireHandler = WireHandler.WireHandler.new()

# Timer
var timerLeft = 0
var timerTime = 50
var timerIteration = 0
var timer = Timer.new()

func _ready():
	#AudioManager.play_music_background()
	GameManager.jsonHandler.loadGame()
	
	light_score_label.text = "Score: 0"
	dark_score_label.text = "Score: 0"
	
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	
	_init_game()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
		
	light_timer_label.text = str(round(timer.time_left)) + " s"
	dark_timer_label.text = str(round(timer.time_left)) + " s"
	if timer.time_left <= 5.5:
		var red = Color(1.0,0.0,0.0,1.0)
		light_timer_label.set("theme_override_colors/font_color", red)
		dark_timer_label.set("theme_override_colors/font_color", red)
		
func _input(event): # Handle Touch Inut
	var globalRect = backButton.get_global_rect()
	if globalRect.has_point(get_global_mouse_position()) and event is InputEventScreenTouch:
		GameManager.jsonHandler.saveScore(score)
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
		
func _on_timer_timeout():
	timer.stop()
	GameManager.jsonHandler.saveScore(score)
	GameManager.jsonHandler.saveLostMap()
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	
func _init_game():
	queue_redraw()
	
	for lamp in lamps:
		lamp.reset()
		
	initNumber()
	
	timer.wait_time = timerTime
	light_timer_label.set("theme_override_colors/font_color", Color.BLACK)
	dark_timer_label.set("theme_override_colors/font_color", Color.WHITE)
	timer.start()
	updateCurrentNumber(true)
	
func initNumber():
	var num = randi_range(1, 128)
	light_goal_number.text = str(num)
	dark_goal_number.text = str(num)
	goalNumber = num 
	
	if goalNumber == 128:
		light_goal_number.text = ">> 128 <<"
		dark_goal_number.text = ">> 128 <<"
		var red = Color(1.0,0.0,0.0,1.0)
		light_goal_number.set("theme_override_colors/font_color",red)
		dark_goal_number.set("theme_override_colors/font_color",red)
		GameManager.jsonHandler.add128achievement()
		
func switch_activated(_switch_number, _isOn):
	AudioManager.playZap()
	toggleLamp(mapping_dict[_switch_number])
	
func toggleLamp(_lampID):
	for lamp in lamps:
		if _lampID == lamp.get_meta("ID"):
			lamp.toggleStatus()
	updateCurrentNumber()
	
func updateCurrentNumber(_init = false):
	var x = 0
		
	for index in range(lamps.size()):
		var pw = index
		if lamps[index].isOn:
			x+= 2**pw
			
	currentNumber = x
	
	dark_current_number.text = str(currentNumber)
	light_current_number.text = str(currentNumber)
	if x == 127:
		GameManager.jsonHandler.addAllLightsOn()
	
	if _init: 
		return
	elif x == goalNumber:
		score += int(timer.time_left)
		GameManager.jsonHandler.saveWonMultiplayerMap()
		
		timerIteration += 1
		if timerIteration == 40:
			timerTime -= 10
		if timerIteration == 30:
			timerTime -= 10
		elif timerIteration == 20:
			timerTime -= 10
		elif timerIteration == 10:
			timerTime -= 10
			
		dark_score_label.text = "Score: " + str(score)
		light_score_label.text = "Score: " + str(score)
		_init_game()
		
# Map
func createWires():
	var arr = wireHandler.createKoopMapping()
	setDict(arr)
	
	var switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8]
	mapNode.setStuff(arr, switches, lamps)
	mapNode.queue_redraw()
	mapNode.createWires_multiplayer()
	
func setDict(mapping):
	var dict = {} # switch: lamp
	for w in mapping:
		dict[w.switch] = w.lamp
	mapping_dict = dict
	
func _draw():
	createWires()
