extends Sprite2D

var onTexture = load("res://Sprites/Lamps/on.PNG")
var offTexture = load("res://Sprites/Lamps/off.PNG")
var isOn = false

func _ready():
	set_process_input(true)
	texture = offTexture

func toggleStatus():
	isOn = !isOn
	_updateSprite()
	
func _updateSprite(): # Private
	if isOn:
		texture = onTexture
	else:
		texture = offTexture
