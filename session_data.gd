class_name session_data

var session_shop_types = []

func _init():
	var shop_types = data.shop_types
	shop_types.shuffle()
	session_shop_types = shop_types.slice(0, 10)

func get_shop_type() -> String:
	return util.pick(session_shop_types)
