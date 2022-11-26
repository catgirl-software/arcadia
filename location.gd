extends Node

class_name location

var x_pos
var y_pos

func _init(x, y):
	x_pos = x
	y_pos = y

func _to_string() -> String:
	return "[location " + str(x_pos) + " " + str(y_pos) + "]"

static func same(a: location, b: location) -> bool:
	return str(a.x_pos) == str(b.x_pos) and str(a.y_pos) == str(b.y_pos)
