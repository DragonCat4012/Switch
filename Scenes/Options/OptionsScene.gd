extends Node2D

@onready var endianToggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/TextureRect
@onready var backgroundMusicToggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer2/TextureRect
@onready var soundeffectsToggle = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer3/TextureRect

var lastClick = Time.get_ticks_msec()

@onready var backButton := $CenterContainer/buttonBackTexture/BackButon

func _ready():
	GameManager.jsonHandler.loadGame()
	
	endianToggle.initValues(GameManager.jsonHandler.endian)
	backgroundMusicToggle.initValues(AudioManager.backgroundSoundEnabled)
	soundeffectsToggle.initValues(AudioManager.soundEffectsEnabled)
	# TODO: set toggles
	
func _input(event):
	var currentClickTime = Time.get_ticks_msec()
	if backButton.get_global_rect().has_point(get_global_mouse_position()) and event is InputEventScreenTouch:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
	lastClick = Time.get_ticks_msec()	

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		GameManager.jsonHandler.saveGame()
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# UI
func toggle_activated(id, isOn):
	if id == 0: # endian switching
		GameManager.jsonHandler.updatEndian(endianToggle.isOn)
	elif id == 1: # backgroundmusic
		AudioManager.backgroundSoundEnabled = !AudioManager.backgroundSoundEnabled	
		AudioManager.toggledBackgroundMusic()
	elif  id == 2: # soundEffects
		AudioManager.soundEffectsEnabled = !AudioManager.soundEffectsEnabled	
