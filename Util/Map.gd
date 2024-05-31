extends Node2D

var arr = []
var switches = []
var lamps = []

func setStuff(arr2, switches2, lamps2):
	arr = arr2
	switches = switches2
	lamps = lamps2
	
# Map
func createWires():
	var minDiff = 40
	var minVec = Vector2(0, minDiff)
	var minDiffSwitch = 55
	var minswicthVec = Vector2(0, minDiffSwitch)
	
	var levelDistances = (switches[0].getCenterPoint().y - lamps[0].getCenterPoint().y) / lamps.size() - minDiffSwitch + minDiff
	var line_width = 3
	
	for w in arr:
		var minY = switches[w.lamp-1].getCenterPoint().y - minDiffSwitch
		var maxLevelks = levelDistances * lamps.size() 
		
		var p3 = switches[w.switch-1].getCenterPoint() - minswicthVec
		var p2 =  p3 - Vector2(0, maxLevelks - w.level * levelDistances) -  minswicthVec
		
		var p0 = lamps[w.lamp-1].getCenterPoint() + minVec
		var p1 = Vector2(p0.x, p2.y)
		
		# up -down
		draw_line(p0, p1, w.color, line_width)
		# down-> up
		draw_line(p3, p2, w.color, line_width)
	 	# horizontal line
		draw_line(p1, p2, w.color, line_width)
		
func createWires_multiplayer():
	if not arr or not switches:
		return
		
	var minDiff = 56
	var minVec = Vector2(minDiff, 0)
	var minDiffSwitch = 160/2
	var minswicthVec = Vector2(minDiffSwitch, 0)
	
	var darkDistances = switches[4].global_position.x - lamps[0].global_position.x + minDiff - minDiffSwitch
	var lightDistances = lamps[0].global_position.x - switches[0].global_position.x - minDiff + minDiffSwitch
	var levelDistances = 0
	var line_width = 5

	for w in arr:
		levelDistances = (lightDistances if w.switch < 5 else darkDistances) / 4
		var isDark = true
		if w.switch < 5: # light
			isDark = false
		var pad = -1 if isDark else 1
		
		var p3 = switches[w.switch-1].global_position + Vector2(0,68/2) + pad*2*minswicthVec
		var p0 = lamps[w.lamp-1].global_position - pad*2*minVec -pad*Vector2(0,minDiff)
		var p2 = p3 + pad*Vector2((4 - w.level) * levelDistances, 0) + pad*minswicthVec
		if w.level == 1:
			p2 = p3 + pad*Vector2((1.2) * levelDistances, 0)
		var p1 = Vector2(p2.x, p0.y) 
		
		if not isDark:
			p3 = switches[w.switch-1].global_position + Vector2(0,68/2)
			p0 = lamps[w.lamp-1].global_position + Vector2(0, 118/2)
			
			p2 = p3 + pad*Vector2((4 - w.level) * levelDistances, 0) + pad*minswicthVec
			if w.level == 1:
				p2 = p3 + pad*Vector2((1.2) * levelDistances, 0)
			p1 = Vector2(p2.x, p0.y) 
		 
		# lamp to level
		draw_line(p0, p1, w.color, line_width)
		# level
		draw_line(p3, p2, w.color, line_width)
	 	# switch - level
		draw_line(p1, p2, w.color, line_width)
			
func _draw():
	if self.get_meta("isMultiplayer"):
		createWires_multiplayer()
	else:
		createWires()
