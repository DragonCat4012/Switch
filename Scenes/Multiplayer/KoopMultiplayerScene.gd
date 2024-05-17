extends Node2D
# Nodes
@onready var lamp1 = $Lamp_1
@onready var lamp2 = $Lamp_2
@onready var lamp3 = $Lamp_3
@onready var lamp4 = $Lamp_4
@onready var lamp5 = $Lamp_5
@onready var lamp6 = $Lamp_6
@onready var lamp7 = $Lamp_7

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

func _on_timer_timeout():
	timer.stop()
	GameManager.jsonHandler.saveScore(score)
	GameManager.jsonHandler.saveLostMap()
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	
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
	
	timer.wait_time = timerTime
	light_timer_label.set("theme_override_colors/font_color", Color.BLACK)
	dark_timer_label.set("theme_override_colors/font_color", Color.WHITE)
	timer.start()
	
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
	
	dark_current_number.text = str(currentNumber)
	light_current_number.text = str(currentNumber)
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
			
		dark_score_label.text = "Score: " + str(score)
		light_score_label.text = "Score: " + str(score)
		_init_game()
# Map
func createWires():
	var arr = wireHandler.createKoopMapping()
	setDict(arr)
	var minDiff = 40
	var minVec = Vector2(minDiff, 0)
	var minDiffSwitch = 55
	var minswicthVec = Vector2( minDiffSwitch, 0)

	var switches = [switch1, switch2, switch3, switch4, switch5, switch6, switch7, switch8]
	var lamps = [lamp1, lamp2, lamp3, lamp4, lamp5, lamp6, lamp7]
	
	var lightDistances = (lamp1.getCenterPoint().x - switch1.getCenterPoint().x) / 4 - minDiffSwitch + minDiff
	var darkDistances = (switch5.getCenterPoint().x - lamp1.getCenterPoint().x) / 4 
	var levelDistances = lightDistances#(switch1.getCenterPoint().y - lamp1.getCenterPoint().y) / lamps.size() - minDiffSwitch + minDiff
	
	var line_width = 3
	
	for w in arr:
		levelDistances = darkDistances
		var isDark = true
		if w.switch < 5: # light
			isDark = true
			levelDistances = lightDistances
			continue 
		print(w)
		var maxLevelks = levelDistances * 4
		
		var p3 = switches[w.switch-1].getCenterPoint() - minswicthVec # ig fine
		var p2 =  p3 - Vector2((4 - w.level) * levelDistances, 0) + minswicthVec
		
		var p0 = lamps[w.lamp-1].global_position + Vector2(0, 56) # yay
		var p1 = Vector2(p2.x, p0.y)
		
		# up -down
		draw_line(p0, p1, Color.RED, line_width)
		#print(p0, p1)
		#draw_line(p0, p1, Color.RED, line_width)
		# left-> right
		#draw_line(p3, p2, Color.GREEN, line_width)
	 	# horizontal line
		#draw_line(p1, p2, w.color, line_width)
			
func setDict(mapping):
	var dict = {} # switch: lamp
	for w in mapping:
		dict[w.switch] = w.lamp
	mapping_dict = dict
	
func _draw():
	createWires()
