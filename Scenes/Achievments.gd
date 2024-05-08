extends Node2D
const AchievementsHandler = preload("res://Util/AchievementHandler.gd")
@onready var achievementHandler = AchievementsHandler.AchievementsHandler.new()
	
# Labels
@onready var a1 = $MarginContainer/ScrollContainer/VBoxContainer/Found128/Label
@onready var a2 = $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver50/Label
@onready var a3 = $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver100/Label
@onready var a4 = $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver1000/Label
@onready var a5 = $MarginContainer/ScrollContainer/VBoxContainer/AllLightsOn/Label
@onready var a6 = $MarginContainer/ScrollContainer/VBoxContainer/Win10Times/Label
@onready var a7 = $MarginContainer/ScrollContainer/VBoxContainer/Win100Times/Label
@onready var a8 = $MarginContainer/ScrollContainer/VBoxContainer/Loose10Times/Label
@onready var a9 = $MarginContainer/ScrollContainer/VBoxContainer/Loose100Times/Label

func _ready():
	_setLabels()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 

func _setLabels():
	if achievementHandler.found128:
		a1.text = "Find the hidden number"
	if achievementHandler.scoreOver50:
		a2.text = "Achieve a score over 50"
	if achievementHandler.scoreOver100:
		a3.text = "Achieve a score over 100"
	if achievementHandler.scoreOver1000:
		a4.text = "Achieve a score over 1000"
	if achievementHandler.allLightsOn:
		a5.text = "Let there be light - turn on all lamps"
		
	if achievementHandler.allLightsOn:
		a6.text = "Solve 10 Maps"
	if achievementHandler.scoreOver1000:
		a7.text = "Solve 100 Maps"
	if achievementHandler.allLightsOn:
		a8.text = "Loose 10 Times"
	if achievementHandler.allLightsOn:
		a9.text = "Loose 100 Times"
