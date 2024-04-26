extends Node2D

const File_name = "user://saves.json"
var isEndianSwitchingEnabled = false
var saveDict = {
	"isEndianSwitchingEnabled": true
}

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		saveSettings()
		get_tree().change_scene_to_file("res://menu.tscn")
		
func saveSettings():
	#if not FileAccess.file_exists((File_name)):

	var file = FileAccess.open(File_name, FileAccess.WRITE)
	saveDict["isEndianSwitchingEnabled"] = isEndianSwitchingEnabled
	
	file.store_string(JSON.stringify(saveDict))
	file.close()
