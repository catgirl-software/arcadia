extends Node

var shops = {}

func _init():
	for x in range(2):
		shops[x] = {}
		for y in range(6):
			shops[x][y] = shop.new().empty(location.new(x, y))

	shops["stairs"] = {
		"left": shop.new().stairs(location.new(-1, 1)),
		"right": shop.new().stairs(location.new(-1, 2)),
	}

	print(shops)

func next_location(cur: location, destination: location) -> location:
	pass

func left_entrance() -> location:
	return location.new(0, 0)

func right_entrance() -> location:
	return location.new(5, 0)

func get_shop_at(loc: location) -> shop:
	return shops[loc.x_pos][loc.y_pos]
