class_name moving_avg

var values
var avg
var l = 1000
var ptr = 0

func _init():
	avg = 0.0
	values = []
	values.resize(l)
	values.fill(0)

func add(val: int) -> int:
	avg -= values[ptr]
	avg += val
	values[ptr] = val
	ptr = (ptr + 1) % l
	return avg / l
