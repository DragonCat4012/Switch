const File_name = "user://saves.json"

class JSONHandler:
	var achievementHandler;
	
	var currentData = {
		"isEndianSwitchingEnabled": true,
		"score": 0,
		"highScore": 0,
		"mapsWon": 0,
		"mapsLost": 0,
		"backgroundMusicEnabled": true,
		"soundEffectsEnabled": true
	}

	func _init():
		var AchievementsHandler = load("res://Util/AchievementHandler.gd")
		achievementHandler = AchievementsHandler.AchievementsHandler.new()
		
		loadGame()
		
	func saveGame():
		var saveDict = {}
		var file = FileAccess.open(File_name, FileAccess.WRITE)
		
		for key in currentData.keys():
			saveDict[key] = currentData[key]

		print("Saving: ", saveDict)
		
		file.store_string(JSON.stringify(saveDict))
		file.close()
	
	func loadGame():
		if FileAccess.file_exists((File_name)):
		
			var file = FileAccess.open(File_name, FileAccess.READ)
			var dict = JSON.parse_string(file.get_as_text())
			print("Load File Save: ", printData(dict))
			if not dict:
				return
			
			for key in currentData.keys():
				if key in dict.keys():
					currentData[key] = dict[key]
				else:
					print("Missing key: ", key)
		else:
			print("Save File doesnt exist")

	# Getter
	var endian: bool:
		get:
			return currentData["isEndianSwitchingEnabled"]
	
	var backgroundMusicEnabled: bool:
		get:
			return currentData["backgroundMusicEnabled"]

	var soundEffectsEnabled: bool:
		get:
			return currentData["soundEffectsEnabled"]

	var score: int:
		get:
			return currentData["score"]
	
	var highScore: int:
		get:
			return currentData["highScore"]

# Update properties
	func saveScore(score: int):
		currentData["score"] = score
		if score > currentData["highScore"]:
			currentData["highScore"] = score
		if score > 50:
			achievementHandler.add_scoreOver50()
		if score > 100:
			achievementHandler.add_scoreOver100()
		if score > 1000:
			achievementHandler.add_scoreOver1000()
	
		saveGame()
	
	func saveWonMap():
		currentData["mapsWon"] = currentData["mapsWon"] + 1
		if currentData["mapsWon"] > 100:
			achievementHandler.add_won100Games()
		elif currentData["mapsWon"] > 10:
			achievementHandler.add_won10Games()
		saveGame()
		
	func saveLostMap():
		currentData["mapsLost"] = currentData["mapsLost"] + 1
		if currentData["mapsLost"] > 100:
			achievementHandler.add_lost100Games()
		elif currentData["mapsLost"] > 10:
			achievementHandler.add_lost10Games()
		saveGame()
	
	func updatEndian(status: bool):
		currentData["isEndianSwitchingEnabled"] = status
		saveGame()
	
	func updateBackgroundMusicEnabled():
		currentData["backgroundMusicEnabled"] = !currentData["backgroundMusicEnabled"]
		saveGame()
	
	func updateSoundEffectsEnabled():
		currentData["soundEffectsEnabled"] = !currentData["soundEffectsEnabled"]
		saveGame()
		
# Add Achievements
	func saveWonMultiplayerMap():
		achievementHandler.add_winKoop()
		
	func add128achievement():
		achievementHandler.add_found128()
		
	func addAllLightsOn():
		achievementHandler.add_allLightsOn()

# Util - Formatting 
	func printData(dict):
		if not dict:
			return "Dict not found"
		print(dict)
		var keys = dict.keys()
		var str = ""
		for k in keys:
			var val = "-1"
			if dict[k] is int:
				val = String(dict[k])
			elif dict[k] is float:
				val = str(dict[k]).pad_decimals(0)
			elif dict[k] is bool:
				val = "✓" if dict[k] else "×"
			str+= k + ": " + val + ", "
		return str
		
