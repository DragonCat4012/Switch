class_name Game extends Node2D

# Add properties
@export var mapName = "Kawasaki"
@export var currentNumber = 900
@export var timer = 0

@export var players = []
@export var lamps = []

# Override virtual methods
func _ready():
	currentNumber = getCurrentNumber()
	players = createPlayers()
	lamps = setLamps()

# Timer 
func startTimer():
	return
	
func onTimerFinsih():
	return 
	
# Initial Methods
func createPlayers():
	return []
	
func setLamps():
	return []
	
func getCurrentNumber():
	var rng = RandomNumberGenerator.new()
	var my_random_number = rng.randi_range(6, 50)
	return my_random_number
