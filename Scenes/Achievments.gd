extends Node2D
const AchievementsHandler = preload("res://Util/AchievementHandler.gd")
@onready var achievementHandler = AchievementsHandler.AchievementsHandler.new()
	
# Labels
@onready var a1 = $MarginContainer/ScrollContainer/VBoxContainer/Found128/Label
@onready var a2 = $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver50/Label
@onready var a3 = $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver100/Label
@onready var a4 = $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver1000/Label

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
