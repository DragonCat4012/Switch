extends Sprite2D

var black_on_texture = load("res://Sprites/Switch/black_on.svg")
var black_off_texture = load("res://Sprites/Switch/black_off.svg")
var white_on_texture = load("res://Sprites/Switch/white_on.svg")
var white_off_texture = load("res://Sprites/Switch/white_off.svg")

var isOn = false

func _ready():
	set_process_input(true)
	texture = white_off_texture

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if get_rect().has_point(to_local(event.position)):
			isOn = !isOn
			updateSprite()

func updateSprite():
	var type = self.get_meta("isDark")
	toggleStatus(isOn)
	if isOn:
		texture = white_on_texture
	else:
		texture = white_off_texture

func toggleStatus(_isOn):
	if get_tree().current_scene.has_method("switch_activated"):
		get_tree().current_scene.switch_activated(self.get_meta("id"), isOn)
