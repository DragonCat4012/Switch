extends HBoxContainer

var mouseOver = false

func _input(event):
	if event is InputEventMouseButton and mouseOver:
		print("ayayay2")
		
func _on_Area2D_mouse_entered():
	mouseOver = true

func _on_Area2D_mouse_exited():
	mouseOver = false
