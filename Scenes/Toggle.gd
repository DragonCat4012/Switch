extends NinePatchRect

var mouseOver = false

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if get_rect().has_point(event.position):
	#if event is InputEventMouseButton and mouseOver:
			print("ayayay")
		
func _on_Area2D_mouse_entered():
	mouseOver = true

func _on_Area2D_mouse_exited():
	mouseOver = false
