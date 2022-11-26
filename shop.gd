extends Node

class_name shop

var shop_name: String

func _to_string() -> String:
	return "[shop: " + shop_name + "]"

func empty(loc) -> shop:
	shop_name = "empty shop@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	return self

func stairs(loc) -> shop:
	shop_name = "stairs@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	return self
