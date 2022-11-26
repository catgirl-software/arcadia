extends Node

class_name customer

enum Action {
	Moving,
	InShop,
	Leaving,
}

var desire: String
var loc: location
var destination: location
var customer_name: String
var cur_action # : Action
var visited_locations = []
var money: float

func _init(m: int, wants: String, l: location, dest: location, n: String):
	money = m
	desire = wants
	loc = l
	destination = dest
	customer_name = n
	cur_action = Action.Moving

func _to_string():
	return customer_name + ", looking for " + desire + " at " + str(destination)

