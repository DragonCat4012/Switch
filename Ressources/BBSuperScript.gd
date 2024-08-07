@tool
extends RichTextEffect
class_name  RichTextSuperscript

var bbcode := "sup"

func _process_custom_fx(char_fx):
	var offset := Vector2(0, 18)
	char_fx.offset = offset
	return true
