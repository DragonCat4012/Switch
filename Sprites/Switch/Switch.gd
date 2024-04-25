extends Sprite2D

var onTexture = load("res://Sprites/Switch/on.PNG")
var offTexture = load("res://Sprites/Switch/off.PNG")
var isOn = false

func _ready():
	set_process_input(true)
	texture = offTexture

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if get_rect().has_point(to_local(event.position)):
			isOn = !isOn
			updateSprite()


func updateSprite():
	if isOn:
		texture = onTexture
	else:
		texture = offTexture
