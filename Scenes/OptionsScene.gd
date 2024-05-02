extends Node2D

const JSONHandler = preload("res://JSON.gd")
@onready var jsonHandler = JSONHandler.JSONHandler.new()
@onready var endianToggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer
var isEndianSwitchingEnabled = false

var onTexture = load("res://Sprites/Toggle/on.PNG")
var offTexture = load("res://Sprites/Toggle/off.PNG")

var lastClick = Time.get_ticks_msec()

func _ready():
	jsonHandler.loadGame()
	isEndianSwitchingEnabled = jsonHandler.endian
	updateEndianSwitch()
	
func _input(event):
	var currentClickTime = Time.get_ticks_msec()
	if event is InputEventScreenTouch and endianToggle.get_global_rect().has_point(get_global_mouse_position()) and currentClickTime > lastClick + 0.8*1000:
		lastClick = Time.get_ticks_msec()
		isEndianSwitchingEnabled = !isEndianSwitchingEnabled
		jsonHandler.updatEndian(isEndianSwitchingEnabled)
		updateEndianSwitch()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		jsonHandler.saveGame()
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# UI
func updateEndianSwitch():
	var toggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/SwitchEndian
	if isEndianSwitchingEnabled:
		toggle.texture = onTexture
	else:
		toggle.texture = offTexture
