class_name util

static func pick(list):
	return list[randi() % len(list)]

static func chance(p: float) -> bool:
	return randf() < p
