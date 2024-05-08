const File_name = "user://achievements.json"

class AchievementsHandler:
	var stats = {
		"found128": false,
		"scoreOver50": false,
		"scoreOver100": false,
		"scoreOver1000": false,
		"allLightsOn": false
	}

	func _init():
		_loadGame()
	
	func _saveGame():
		var saveDict = {}
		var file = FileAccess.open(File_name, FileAccess.WRITE)
		
		for key in stats.keys():
			saveDict[key] = stats[key]
		
		file.store_string(JSON.stringify(saveDict))
		file.close()
	
	func _loadGame():
		if FileAccess.file_exists((File_name)):
			var file = FileAccess.open(File_name, FileAccess.READ)
			var dict = JSON.parse_string(file.get_as_text())
			
			for key in stats.keys():
				if key in dict.keys():
					stats[key] = dict[key]
		else:
			print("Achievemnt File doesn´t exist")

	# Getter
	var found128: bool:
		get:
			return stats["found128"]
			
	var scoreOver50: bool:
		get:
			return stats["scoreOver50"]
			
	var scoreOver100: bool:
		get:
			return stats["scoreOver100"]
			
	var scoreOver1000: bool:
		get:
			return stats["scoreOver1000"]
			
	var allLightsOn: bool:
		get: 
			return stats["allLightsOn"]
	# Update properties
	func add_found128():
		_updateKey("found128")
	
	func add_scoreOver50():
		_updateKey("scoreOver50")
		
	func add_scoreOver100():
		_updateKey("scoreOver100")
	
	func add_scoreOver1000():
		_updateKey("scoreOver1000")
		
	func add_allLightsOn():
		_updateKey("allLightsOn")
		
	func _updateKey(key: String, value: bool = true):
		if stats[key] == true:
			return
		stats[key] = value
		_saveGame()
