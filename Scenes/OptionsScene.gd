extends Node2D

@onready var endianToggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/TextureRect
var isEndianSwitchingEnabled = false

var onTexture = load("res://Sprites/Toggle/on.PNG")
var offTexture = load("res://Sprites/Toggle/off.PNG")

var lastClick = Time.get_ticks_msec()

@onready var backButton := $CenterContainer/buttonBackTexture/BackButon

func _ready():
	GameManager.jsonHandler.loadGame()
	isEndianSwitchingEnabled = GameManager.jsonHandler.endian
	updateEndianSwitch()
	
func _input(event):
	var currentClickTime = Time.get_ticks_msec()
	if backButton.get_global_rect().has_point(get_global_mouse_position()) and event is InputEventScreenTouch:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
	if endianToggle.get_global_rect().has_point(get_global_mouse_position()) and event is InputEventScreenTouch and currentClickTime > lastClick + 0.5*1000:
		lastClick = Time.get_ticks_msec()
		isEndianSwitchingEnabled = !isEndianSwitchingEnabled
		GameManager.jsonHandler.updatEndian(isEndianSwitchingEnabled)
		updateEndianSwitch()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		GameManager.jsonHandler.saveGame()
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# UI
func updateEndianSwitch():
	if isEndianSwitchingEnabled:
		endianToggle.texture = onTexture
	else:
		endianToggle.texture = offTexture
