extends Node

class_name arcade

var session: session_data

var shops = {}
var arcade_members = []
var money: int

var customer_timer: Timer
var tick_timer: Timer

func _init():
	randomize()
	money = 0
	session = session_data.new()
	for x in range(6):
		shops[x] = {}
		for y in range(2):
			shops[x][y] = shop.new(location.new(x, y)).empty()
	shops["stairs"] = {
		"left": shop.new(location.new("stairs", "left")).stairs(),
		"right": shop.new(location.new("stairs", "right")).stairs(),
	}

	var loc = location.new(3, 1)
	get_shop_at(loc).shop(random_shop(10))

	new_customer(10)
	print(shops)

func _ready():
	customer_timer = Timer.new()
	add_child(customer_timer)
	customer_timer.wait_time = 10.0
	customer_timer.connect("timeout", self, "customer_timer_cb")
	#customer_timer.start()

	tick_timer = Timer.new()
	add_child(tick_timer)
	tick_timer.wait_time = 1.0
	tick_timer.connect("timeout", self, "tick_timer_cb")
	tick_timer.start()

# timer callbacks

func customer_timer_cb():
	new_customer(3)

func tick_timer_cb():
	print("some time passes...")
	var to_remove = []
	for c in arcade_members:
		match c.cur_action:
			customer.Action.Moving:
				c.loc = next_location(c.loc, c.destination)
				print("customer " + str(c) + " moving to " + str(c.loc))
				if location.same(c.loc, c.destination):
					print("customer " + str(c) + " has reached their destination!")
					c.cur_action = customer.Action.InShop
			customer.Action.Leaving:
				c.loc = next_location(c.loc, c.destination)
				print("customer " + str(c) + " leaving, moving to " + str(c.loc))
				if location.same(c.loc, c.destination):
					print("customer " + str(c) + " has left the arcade...")
					to_remove.append(c)
			customer.Action.InShop:
				print("customer " + str(c) + " shopping...")
				if util.chance(0.3):
					print("customer " + str(c) + " bought their item!")
					c.cur_action = customer.Action.Leaving
					c.destination = util.pick([left_entrance(), right_entrance()])
	if len(to_remove):
		var new_customer_list = []
		for c in arcade_members:
			if not (c in to_remove):
				new_customer_list.append(c)
			else:
				c.queue_free()
		arcade_members = new_customer_list


func random_shop(p: int) -> shop_details:
	var details = shop_details.new()
	details.thing_1 = session.get_shop_type()
	details.thing_2 = session.get_shop_type()
	details.thing_3 = session.get_shop_type()
	details.price = p
	print(details)
	return details

func new_customer(friendliness: int):
	var n = data.name()
	print("new customer, " + n + "!")
	for _i in range(friendliness):
		var desire = session.get_shop_type()
		print(n + " is looking for " + desire)
		var destination = get_destination(desire)
		if destination == null:
			print("no shop matching " + desire + "!")
			continue
		var c = customer.new(
			desire,
			util.pick([left_entrance(), right_entrance()]),
			destination.loc,
			n
		)
		add_child(c)
		print(n + " is buying " + desire + " from " + str(destination))
		arcade_members.append(c)
		return
	print(n + " leaves in disgust...")

func get_destination(desire: String) -> location:
	var possible_shops = []
	for k in shops.values():
		for shop in k.values():
			if shop.has_item(desire):
				possible_shops.append(shop)
	if len(possible_shops) == 0:
		return null
	return util.pick(possible_shops)

func next_location(cur: location, dest: location) -> location:
	# if we're on stairs, leave them and move towards the destination
	if str(cur.y_pos) == "stairs":
		if cur.x_pos == "left":
			print("stairs left " + str(dest.x_pos))
			if dest.x_pos == 0:
				return location.new(0, dest.y_pos)
			if dest.x_pos > 0:
				return location.new(1, dest.y_pos)
		elif cur.x_pos == "right":
			if dest.x_pos == 5:
				return location.new(5, dest.y_pos)
			if dest.x_pos < 5:
				return location.new(4, dest.y_pos)

	# if we need to get to stairs, move onto them
	if cur.y_pos != dest.y_pos:
		if cur.x_pos in [0, 1]:
			if dest.x_pos <= 2 or util.chance(0.5):
				return left_stairs()
		if cur.x_pos in [4, 5]:
			if dest.x_pos >= 3 or util.chance(0.5):
				return right_stairs()

		# or towards the stairs towards our destination
		if dest.x_pos <= 2:
			return location.new(cur.x_pos - 1, cur.y_pos)
		return location.new(cur.x_pos + 1, cur.y_pos)

	# otherwise just move towards the destination
	if cur.x_pos > dest.x_pos:
		return location.new(cur.x_pos - 1, cur.y_pos)

	return location.new(cur.x_pos + 1, cur.y_pos)

func left_stairs() -> location:
	return location.new("left", "stairs")
func right_stairs() -> location:
	return location.new("right", "stairs")

func left_entrance() -> location:
	return location.new(0, 0)

func right_entrance() -> location:
	return location.new(5, 0)

func get_shop_at(loc: location) -> shop:
	return shops[loc.x_pos][loc.y_pos]
