
class WireHandler:
	var nr_lamps = 7
	var nr_switches = 8
	
	func _init(nr_lamps: int = 7, nr_switches: int = 8):
		nr_lamps = nr_lamps
		nr_switches = nr_switches
	
	func createMappingDict():
		# Init everything
		var dict = {} # lamp: swicth
		var levels = nr_lamps
		var arrLamps = [1,2,3,4,5,6,7,8,9,10,11,12]
		arrLamps.resize(nr_lamps)
		var randomLamp = arrLamps.pick_random()
		
		var arrSwicthes = [1,2,3,4,5,6,7,8,9,10,11,12]
		arrSwicthes.resize(nr_switches)
		
		var dataArr = [] # [Wire]
		var levelArr = [1,2,3,4,5,6,7,8,9,10,11,12]
		levelArr.resize(nr_lamps)
		
		# Pair lamps & switches with level
		for lamp in arrLamps:
			var level = levelArr.pick_random()
			var switch = arrSwicthes.pick_random()
			var wire = (Wire.new(lamp,switch,level))
			
			arrSwicthes.erase(switch)
			levelArr.erase(level)
			dataArr.append(wire)
			
			if lamp == randomLamp:	# duplicate lamp
				var switch2 = arrSwicthes.pick_random()
				var wire2 = (Wire.new(lamp,switch2,level))
				arrSwicthes.erase(switch2)
				dataArr.append(wire2)
			
		return dataArr

class Wire:
	var lamp = 0
	var switch = 0
	var level = 0
	
	func _init(lamp: int = 0, switch: int = 0, level: int = 0):
		lamp = lamp
		switch = switch
		level = level
