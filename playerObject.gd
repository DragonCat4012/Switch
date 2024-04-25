class_name Player extends Node2D

# Add properties
@export var tablePosition: int = 0 #not set
@export var switches = []

# init
func init(tablePosition=0,switches=[]): #pseudo-constructor
	#some action like follows
	tablePosition=tablePosition
	switches=switches
	
# Override virtual methods
func _ready():
	initSwitchStates()

# lamps
func initSwitchStates():
	return 
	
func toggle(lamp:int):
	return 
