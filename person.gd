extends Node

class_name person

var money: int
var interests = {}
var position: location
var destination: location

func _init(m, i, p, d):
	money = m
	interests = i
	position = p
	destination = d
