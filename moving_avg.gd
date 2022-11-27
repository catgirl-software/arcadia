class_name moving_avg

var values
var avg
var ptr = 0

func _init():
	avg = 0.0
	values = []

func add(val: int) -> int:
	if len(values) < 500:
		avg += val
		values.append(val)
		return avg/len(values)
	else:
		avg -= values[ptr]
		avg += val
		values[ptr] = val
		ptr = (ptr + 1) % 500
		return avg / 500
