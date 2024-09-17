extends Node2D
const AchievementsHandler = preload("res://Util/AchievementHandler.gd")
@onready var achievementHandler := AchievementsHandler.AchievementsHandler.new()
	
# Labels
@onready var a1 := $MarginContainer/ScrollContainer/VBoxContainer/Found128/Label
@onready var a2 := $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver50/Label
@onready var a3 := $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver100/Label
@onready var a4 := $MarginContainer/ScrollContainer/VBoxContainer/ScoreOver1000/Label
@onready var a5 := $MarginContainer/ScrollContainer/VBoxContainer/AllLightsOn/Label
@onready var a6 := $MarginContainer/ScrollContainer/VBoxContainer/Win10Times/Label
@onready var a7 := $MarginContainer/ScrollContainer/VBoxContainer/Win100Times/Label
@onready var a8 := $MarginContainer/ScrollContainer/VBoxContainer/Loose10Times/Label
@onready var a9 := $MarginContainer/ScrollContainer/VBoxContainer/Loose100Times/Label
@onready var a10 := $MarginContainer/ScrollContainer/VBoxContainer/WinKoop/Label
@onready var a11 = $MarginContainer/ScrollContainer/VBoxContainer/PlayKoop/Label

var white = Color(1.0,1.0,1.0,1.0)
var gray = Color(1.0,1.0,1.0,0.3)
	
func _ready():
	_setLabels()
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
		
func _setLabels():
	var labels = [a1,a2,a3,a4,a5,a6,a7,a8,a9,a10, a11]
	
	for l in labels:
		if l is  Label:
			_update_label(l, "?", gray)
	
	if achievementHandler.found128:
		a1.text = "Find the hidden number - 128"
		a1.set("theme_override_colors/font_color", white)
	if achievementHandler.scoreOver50:
		a2.text = "Achieve a Score over 50"
		a2.set("theme_override_colors/font_color", white)
	if achievementHandler.scoreOver100:
		a3.text = "Achieve a Score over 100"
		a3.set("theme_override_colors/font_color", white)
	if achievementHandler.scoreOver1000:
		a4.text = "Achieve a Score over 1000"
		a4.set("theme_override_colors/font_color", white)
	if achievementHandler.allLightsOn:
		a5.text = "Let there be Light - turn on all Lamps"
		a5.set("theme_override_colors/font_color", white)
		
	if achievementHandler.won10:
		_update_label(a6, "Solve 10 Maps", white)
	if achievementHandler.won100:
		_update_label(a7, "Solve 100 Map", white)
	if achievementHandler.lost10:
		_update_label(a8, "Loose 10 Times", white)
	if achievementHandler.lost100:
		_update_label(a9, "Skill Issue - Loose 100 Times", white)
	if achievementHandler.winKoop:
		_update_label(a10, "Team Player - Win a multiplayer map", white)
	if achievementHandler.playKoop:
		_update_label(a11, "Play a coop game", white)

func _update_label(label: Label, text: String, color: Color):
	label.text = text
	label.set("theme_override_colors/font_color", color)
