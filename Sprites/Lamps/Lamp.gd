extends TextureRect

var onTexture = load("res://Sprites/Lamps/lamp_on.svg")
var offTexture = load("res://Sprites/Lamps/lamp_off.svg")
var isOn = false

func _ready():
	set_process_input(true)
	texture = offTexture

func reset():
	isOn = randi() % 2
	_updateSprite()

func toggleStatus():
	isOn = !isOn
	_updateSprite()
	
func _updateSprite(): # Private
	if isOn:
		texture = onTexture
	else:
		texture = offTexture
		
# Geo
func getCenterPoint():
	return get_rect().get_center()
