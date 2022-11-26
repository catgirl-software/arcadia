extends Node

class_name shop

var shop_name: String
var stats: shop_details
var loc: location

func _init(l: location):
	loc = l

func _to_string() -> String:
	return "[shop: " + shop_name + "]"

func empty() -> shop:
	shop_name = "empty shop@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	return self

func stairs() -> shop:
	shop_name = "stairs@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	return self

func shop(s: shop_details) -> shop:
	stats = s
	shop_name = str(stats) + "@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	return self

func has_item(desire: String) -> bool:
	if not stats:
		return false
	return stats.thing_1 == desire || stats.thing_2 == desire || stats.thing_3 == desire

