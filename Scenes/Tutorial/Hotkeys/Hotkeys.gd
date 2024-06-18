extends Node2D

@onready var neededKeysLabel = $VBoxContainer/Keys/TODO/VBoxContainer/TODONumbers
var switchRessource = preload("res://Sprites/Switch/Switch.gd")

var arrTODO = [0,1,2,3,4,5,6,7]
var canESC = false

func _ready():
	neededKeysLabel.text = ", ".join(arrTODO)
	for s in $VBoxContainer/CenterContainer2/HBoxContainer.get_children():
		s.shouldListenToClick = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and canESC:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
		
	# Handle Number Inputs
	if Input.is_action_just_pressed("0"):
		switch_activated(1)
	elif Input.is_action_just_pressed("1"):
		switch_activated(2)
	elif Input.is_action_just_pressed("2"):
		switch_activated(3)
	elif Input.is_action_just_pressed("3"):
		switch_activated(4)
	elif Input.is_action_just_pressed("4"):
		switch_activated(5)
	elif Input.is_action_just_pressed("5"):
		switch_activated(6)
	elif Input.is_action_just_pressed("6"):
		switch_activated(7)
	elif Input.is_action_just_pressed("7"):
		switch_activated(8)
		
func switch_activated(num, isOn=false):
	if num-1 in arrTODO:
		arrTODO.erase(num-1)

	neededKeysLabel.text = ", ".join(arrTODO)
	if arrTODO.is_empty():
		canESC = true
		neededKeysLabel.text = "ESC"
	
	# update graphic
	for s in $VBoxContainer/CenterContainer2/HBoxContainer.get_children():
		if s.get_meta("ID") == num-1:
			s.updateFromTutorial()
