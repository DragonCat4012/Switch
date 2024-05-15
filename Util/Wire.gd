
class WireHandler:
	var nr_lamps = 7
	var nr_switches = 8
	
	func _init(nr_lamps: int = 7, nr_switches: int = 8):
		nr_lamps = nr_lamps
		nr_switches = nr_switches
		
	func createKoopMapping():
		# Init everything
		var dict = {} # lamp: swicth
		var levels = nr_lamps
		var arrLamps = [1,2,3,4,5,6,7,8,9,10,11,12]
		arrLamps.resize(nr_lamps)
		var randomLamp = arrLamps.pick_random()
		
		var arrSwicthes = [1,2,3,4,5,6,7,8,9,10,11,12]
		arrSwicthes.resize(nr_switches)
		
		var dataArr = [] # [Wire]
		var levelArr = [1,2,3,4]
		var levelArr_dark = [1,2,3,4]
		#levelArr.resize(5)
		
		var colorArr = [Color(1,0.5, 0.5, 1), Color(0.870588, 0.721569, 0.529412, 1), Color(0.5,0.5,1, 1), Color(0.5,1,1, 1), Color(1,0.5,1, 1), 
		Color(1,1,0.5, 1), Color(0.2,1,0.5, 1), Color(1,0.2,0.5, 1), Color(0.8,1,0.1, 1)]
		
		# Pair lamps & switches with level
		for lamp in arrLamps:
			var level = levelArr_dark.pick_random() if lamp > 4  else levelArr.pick_random()
			var switch = arrSwicthes.pick_random()
			var color = colorArr.pick_random()
			var wire = (Wire.new(lamp,switch,level, color))
			
			arrSwicthes.erase(switch)
			levelArr.erase(level)
			colorArr.erase(color)
			dataArr.append(wire)
	
			if lamp == randomLamp:	# duplicate lamp
				var switch2 = arrSwicthes.pick_random()
				var wire2 = (Wire.new(lamp,switch2,level, color))
				arrSwicthes.erase(switch2)
				dataArr.append(wire2)
			
		return dataArr
		
	func createMapping():
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
		
		var colorArr = [Color(1,0.5, 0.5, 1), Color(0.870588, 0.721569, 0.529412, 1), Color(0.5,0.5,1, 1), Color(0.5,1,1, 1), Color(1,0.5,1, 1), 
		Color(1,1,0.5, 1), Color(0.2,1,0.5, 1), Color(1,0.2,0.5, 1), Color(0.8,1,0.1, 1)]
		
		# Pair lamps & switches with level
		for lamp in arrLamps:
			var level = levelArr.pick_random()
			var switch = arrSwicthes.pick_random()
			var color = colorArr.pick_random()
			var wire = (Wire.new(lamp,switch,level, color))
			
			arrSwicthes.erase(switch)
			levelArr.erase(level)
			colorArr.erase(color)
			dataArr.append(wire)
	
			if lamp == randomLamp:	# duplicate lamp
				var switch2 = arrSwicthes.pick_random()
				var wire2 = (Wire.new(lamp,switch2,level, color))
				arrSwicthes.erase(switch2)
				dataArr.append(wire2)
			
		return dataArr

class Wire:
	var lamp = 0
	var switch = 0
	var level = 0
	var color: Color = Color(1,1,1,0)
	
	func _init(lamp: int = 0, switch: int = 0, level: int = 0, color = Color(1,1,1,0)):
		self.lamp = lamp
		self.switch = switch
		self.level = level
		self.color = color
	
	func _to_string():
		return "(l: " + str(lamp) + ", s: " + str(switch) + ") l: " +str(level)
