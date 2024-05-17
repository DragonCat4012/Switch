extends TextureRect

var black_on_texture = load("res://Sprites/Switch/black_on.svg")
var black_off_texture = load("res://Sprites/Switch/black_off.svg")
var white_on_texture = load("res://Sprites/Switch/white_on.svg")
var white_off_texture = load("res://Sprites/Switch/white_off.svg")

var isOn = false
var lastClick = Time.get_ticks_msec()

func _ready():
	set_process_input(true)
	texture = black_off_texture if self.get_meta("isDark") else white_off_texture
	self.gui_input.connect(_on_gui_input)

func _on_gui_input(event):
	var currentClickTime = Time.get_ticks_msec()
	if event is InputEventMouseButton and currentClickTime > lastClick + 0.2*1000:
		isOn = !isOn
		updateSprite()
		lastClick = currentClickTime

func updateSprite():
	var isDark = self.get_meta("isDark")
	toggleStatus(isOn)
	if isOn:
		texture = black_on_texture if isDark else white_on_texture
	else:
		texture = black_off_texture if isDark else white_off_texture

func toggleStatus(_isOn):
	if get_tree().current_scene.has_method("switch_activated"):
		get_tree().current_scene.switch_activated(get_meta("ID"), isOn)

# Geo
func getCenterPoint():
	return get_rect().get_center()
