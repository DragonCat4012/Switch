extends TextureRect

var onTexture = load("res://Sprites/Toggle/on.PNG")
var offTexture = load("res://Sprites/Toggle/off.PNG")

var isOn = false
var lastClick = Time.get_ticks_msec()

func _ready():
	set_process_input(true)
	texture = onTexture if isOn else offTexture
	self.gui_input.connect(_on_gui_input)

func initValues(value:bool):
	isOn = value
	texture = onTexture if isOn else offTexture
	
func _on_gui_input(event):
	var currentClickTime = Time.get_ticks_msec()
	if event is InputEventMouseButton and currentClickTime > lastClick + 0.2*1000:
		isOn = !isOn
		updateSprite()
		lastClick = currentClickTime

func updateSprite():
	toggleStatus(isOn)
	texture = onTexture if isOn else offTexture

func toggleStatus(_isOn):
	if get_tree().current_scene.has_method("toggle_activated"):
		get_tree().current_scene.toggle_activated(get_meta("ID"), isOn)
