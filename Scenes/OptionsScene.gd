extends Node2D

const JSONHandler = preload("res://JSON.gd")
@onready var jsonHandler = JSONHandler.JSONHandler.new()
@onready var endianToggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/CenterContainer/NinePatchRect
var isEndianSwitchingEnabled = false

func _ready():
	jsonHandler.loadGame()
	
func _input(event):
	var x = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/CenterContainer/NinePatchRect
	if event is InputEventMouseButton and event.is_pressed():
		if x.get_rect().has_point(to_local(event.position)):
			print("toggg") # TODO: toggle click not detected
			isEndianSwitchingEnabled = !isEndianSwitchingEnabled
			jsonHandler.updatEndian(isEndianSwitchingEnabled)
			updateEndianSwitch()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		jsonHandler.saveGame()
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# UI
func updateEndianSwitch():
	var onTexture = "res://Sprites/Toggle/on.PNG"
	var offTexture = "res://Sprites/Toggle/off.PNG"
	var toggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/CenterContainer/NinePatchRect
	if isEndianSwitchingEnabled:
		toggle.texture = load(onTexture)
	else:
		toggle.texture = load(offTexture)
