extends Node2D

@onready var lamp1 = $"MarginContainer/Lamp_1"
@onready var lamp2 = $"MarginContainer/Lamp_2"
@onready var lamp3 = $"MarginContainer/Lamp_3"
@onready var lamp4 = $"MarginContainer/Lamp_4"

var map_dict = { # key=switch, value=lamp
	1: 4,
	2: 1,
	3:3,
	4:4, 
	5:2, 
	6:3
}

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_activated(_switch_number, _isOn):
	lamp1.toggleStatus()
	
func toggleLamp(_lampID):
	if _lampID == 1:
		lamp1.toggleStatus()
	elif _lampID == 2:
		lamp2.toggleStatus()
	elif _lampID == 3:
		lamp3.toggleStatus()
	elif _lampID == 4:
		lamp4.toggleStatus()
