extends Node2D

@onready var endianToggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/CenterContainer/NinePatchRect
const File_name = "user://saves.json"
var isEndianSwitchingEnabled = false
var saveDict = {
	"isEndianSwitchingEnabled": true
}

func _input(event):
	var x = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/CenterContainer/NinePatchRect
	if event is InputEventMouseButton and event.is_pressed():
		if x.get_rect().has_point(to_local(event.position)):
			print("toggg") # TODO: toggle click not detected
			isEndianSwitchingEnabled = !isEndianSwitchingEnabled
			updateEndianSwitch()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		saveSettings()
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		
func saveSettings():
	var file = FileAccess.open(File_name, FileAccess.WRITE)
	saveDict["isEndianSwitchingEnabled"] = isEndianSwitchingEnabled
	
	file.store_string(JSON.stringify(saveDict))
	file.close()

# UI
func updateEndianSwitch():
	var onTexture = "res://Sprites/Toggle/on.PNG"
	var offTexture = "res://Sprites/Toggle/off.PNG"
	var toggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/CenterContainer/NinePatchRect
	if isEndianSwitchingEnabled:
		toggle.texture = load(onTexture)
	else:
		toggle.texture = load(offTexture)
