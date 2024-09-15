extends Node2D

@onready var endianToggle := $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/TextureRect
@onready var backgroundMusicToggle := $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer2/TextureRect
@onready var soundeffectsToggle := $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer3/TextureRect

func _ready():
	endianToggle.initValues(GameManager.jsonHandler.endian)
	backgroundMusicToggle.initValues(GameManager.jsonHandler.backgroundMusicEnabled)
	soundeffectsToggle.initValues(GameManager.jsonHandler.soundEffectsEnabled)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		#GameManager.jsonHandler.saveGame()
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# UI
func toggle_activated(id, isOn):
	if id == 0: # endian switching
		GameManager.jsonHandler.updatEndian(endianToggle.isOn)
	elif id == 1: # backgroundmusic
		AudioManager.backgroundSoundEnabled = !AudioManager.backgroundSoundEnabled	
		AudioManager.toggledBackgroundMusic()
		GameManager.jsonHandler.updateBackgroundMusicEnabled()
	elif  id == 2: # soundEffects
		AudioManager.soundEffectsEnabled = !AudioManager.soundEffectsEnabled	
		GameManager.jsonHandler.updateSoundEffectsEnabled()
