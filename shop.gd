extends Node2D

class_name shop

var shop_name: String
var stats: shop_details
var loc: location

func _to_string() -> String:
	return "[shop: " + shop_name + "]"

func set_location(l: location) -> shop:
	loc = l
	return self

func empty() -> shop:
	shop_name = "empty shop@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	$Empty.visible = true
	return self

func stairs() -> shop:
	shop_name = "stairs@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	return self

func shop(s: shop_details) -> shop:
	stats = s
	print("setting " + str(loc) + " to a shop!")
	$Empty.visible = false
	$Rooms.frame = data.shop_types.find(stats.thing_1)
	$Signs.frame = data.shop_types.find(stats.thing_2)
	shop_name = str(stats) + "@" + str(loc.x_pos) + ", " + str(loc.y_pos)
	return self

func text() -> String:
	if $Empty.visible:
		return "No shop."
	return "Selling " + stats.thing_1 + ", " + stats.thing_2 + ", and " + stats.thing_3

func has_item(desire: String) -> bool:
	if not stats:
		return false
	return stats.thing_1 == desire || stats.thing_2 == desire || stats.thing_3 == desire

