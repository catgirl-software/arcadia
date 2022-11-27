class_name shop_details

var thing_1: String
var thing_2: String
var thing_3: String

var price: float

var shop_name: String

func _init():
	pass

func _to_string() -> String:
	return "[shop " + thing_1 + ", " + thing_2 + ", " + thing_3 + " @ " + str(price) + "]"

func text() -> String:
	return shop_name + ", selling " + thing_1 + ", " + thing_2 + ", and " + thing_3
