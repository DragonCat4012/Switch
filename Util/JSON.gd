const File_name = "user://saves.json"

class JSONHandler:
	var currentData = {
		"isEndianSwitchingEnabled": true,
		"score": 0,
		"highScore": 0
	}

	func _init():
		loadGame()
		
	func saveGame():
		var saveDict = {
			"isEndianSwitchingEnabled": true,
			"score": 0,
			"highScore": 0
		}
		var file = FileAccess.open(File_name, FileAccess.WRITE)
		
		saveDict["isEndianSwitchingEnabled"] = currentData["isEndianSwitchingEnabled"]
		saveDict["score"] = currentData["score"]
		saveDict["highScore"] = currentData["highScore"]
		
		print("save")
		print(saveDict)
		
		file.store_string(JSON.stringify(saveDict))
		file.close()
	
	func loadGame():
		if FileAccess.file_exists((File_name)):
			print("Load File Save")
			var file = FileAccess.open(File_name, FileAccess.READ)
			var dict = JSON.parse_string(file.get_as_text())
			print(dict)
			currentData["isEndianSwitchingEnabled"] = dict["isEndianSwitchingEnabled"]
			currentData["score"] = dict["score"]
			currentData["highScore"] = dict["highScore"]
		else:
			print("File doesnt exist")

	# Getter
	var endian: bool:
		get:
			return currentData["isEndianSwitchingEnabled"]
	
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
		saveGame()
	
	func updatEndian(status: bool):
		currentData["isEndianSwitchingEnabled"] = status
		saveGame()
