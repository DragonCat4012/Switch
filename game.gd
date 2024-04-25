extends Node2D

@onready var lamp1 = $"MarginContainer/Lamp 1"
@onready var lamp2 = $"MarginContainer/Lamp 2"
@onready var lamp3 = $"MarginContainer/Lamp 3"
@onready var lamp4 = $"MarginContainer/Lamp 4"

var map_dict = { # key=switch, value=lamp
	1: 4,
	2: 1,
	3:3,
	4:4, 
	5:2, 
	6:3
}

func _ready():
	lamp1.reset()
	lamp2.reset()
	lamp3.reset()
	lamp4.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_activated(_switch_number, _isOn):
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

func randomBool():
	return randi() % 2
