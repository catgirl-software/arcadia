extends Sprite

class_name customer

enum Action {
	Moving,
	InShop,
	Browsing,
	Leaving,
}

var desire: String
var affinities = {}
var loc: location
var destination: location
var customer_name: String
var cur_action # : Action
var visited_locations = []
var money: float
var sprite: Sprite

func init(f: int, m: int, wants: String, l: location, dest: location, n: String):
	frame = f
	money = m
	desire = wants
	affinities[desire] = randf()
	for related in data.associated_shops[desire]:
		affinities[related] = randf()
	loc = l
	destination = dest
	customer_name = n
	cur_action = Action.Moving

func _to_string():
	return customer_name + ", looking for " + desire + " at " + str(destination)

