extends Node2D

var lastClick = Time.get_ticks_msec()
@onready var endianGroup = $Endian
@onready var lampGroup = $Lamp
@onready var switchGroup = $Switch2
@onready var numberGroup = $Numbers

@onready var pageLabel = $Pages/Label

@onready  var allGroups: Array[Control] = [lampGroup, switchGroup, numberGroup, endianGroup]

var currentStep = 0
var maxStep = 4

func _ready():
	hideAllExplanations()
	updatePages()
	for child in allGroups[currentStep].get_children():
			child.visible = true
		
func _input(event):
	var currentClickTime = Time.get_ticks_msec()
	if event is InputEventScreenTouch and currentClickTime > lastClick + 0.8*1000:
		updateCurrentStep()
		lastClick = Time.get_ticks_msec()

func updateCurrentStep():
	currentStep += 1
	
	if currentStep >= maxStep: # End of tutorial
		print("end")
		if OS.has_feature("android") or OS.has_feature("ios"): # hotkey tutorial
			print("mobile")
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		else:
			print("pc")
			get_tree().change_scene_to_file("res://Scenes/Tutorial/Hotkeys/Hotkeys.tscn")
	
	else:
		hideAllExplanations()
		for child in allGroups[currentStep].get_children():
				child.visible = true
		updatePages()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pass
		#get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func hideAllExplanations():
	for group in allGroups:
		for child in group.get_children():
			child.visible = false

func updatePages():
	pageLabel.text = str(currentStep+1) + "/" + str(maxStep)
