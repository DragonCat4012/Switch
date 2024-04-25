class_name Player extends Node2D

# Add properties
@export var tablePosition: int = 0 #not set
@export var switches = []

# Override virtual methods
func _ready():
	initSwitchStates()

func setTablePosition(pos: int):
	tablePosition = pos
# lamps
func initSwitchStates():
	return
	
func toggle(lamp:int):
	return 
