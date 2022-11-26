extends Node

class_name arcade

const CAMERA_X = 800
const CAMERA_Y = 600
const SHOP_X = 48*7
const SHOP_Y = 32*7
const STAIR_X = 16*7
const FRAME_EDGE = 8*7
const FRAME_Y = 72*7
var customer_scene = preload("res://customer.tscn")

var shops = {}
var arcade_members = []
var money: int
var current_selection: location

var customer_timer: Timer
var tick_timer: Timer

var rng: RandomNumberGenerator

func _ready():
	randomize()
	rng = RandomNumberGenerator.new()
	rng.randomize()
	money = 0
	$camera.position.x = CAMERA_X/2 - SHOP_X/2
	$camera.position.y = (-CAMERA_Y/2) + SHOP_Y/2
	$camera/shopdetails.text = ""
	$frame.position.x = -SHOP_X/2
	$frame.position.y = SHOP_Y/2
	print(self.get_children()[0])
	for x in range(6):
		shops[x] = {}
		for y in range(2):
			shops[x][y] = get_node("shop" + str(x) + str(y))
			shops[x][y].set_location(location.new(x, y)).empty()
			shops[x][y].position.x = SHOP_X * x + FRAME_EDGE
			if x >=1:
				shops[x][y].position.x += STAIR_X
			if x >=5:
				shops[x][y].position.x += STAIR_X
			shops[x][y].position.y = -SHOP_Y * y - FRAME_EDGE
			shops[x][y].get_node("Shopfront").frame = y
	var leftStair = shop.new().set_location(location.new("stairs", "left")).stairs()
	add_child(leftStair)
	var rightStair = shop.new().set_location(location.new("stairs", "right")).stairs()
	add_child(rightStair)
	shops["left"] = {
		"stairs": leftStair,
	}
	shops["right"] = {
		"stairs": rightStair
	}

	print(shops)
	for x in range(6):
		for y in range(2):
			get_shop_at(location.new(x, y)).shop(random_shop(10))

	current_selection = $shop00.loc
	new_customer(10)

#func _ready():
	customer_timer = Timer.new()
	add_child(customer_timer)
	customer_timer.wait_time = 10.0
	var _t = customer_timer.connect("timeout", self, "customer_timer_cb")
	#customer_timer.start()

	tick_timer = Timer.new()
	add_child(tick_timer)
	tick_timer.wait_time = 0.5
	_t = tick_timer.connect("timeout", self, "tick_timer_cb")
	tick_timer.start()

func _input(event):
	var cur_x = current_selection.x_pos
	var cur_y = current_selection.y_pos

	if event.is_action_pressed("ui_up"):
		cur_y = (cur_y + 1) % 2
	elif event.is_action_pressed("ui_down"):
		cur_y = (cur_y - 1 + 6) % 2
	elif event.is_action_pressed("ui_left"):
		cur_x = (cur_x - 1 + 6) % 6
	elif event.is_action_pressed("ui_right"):
		cur_x = (cur_x + 1) % 6
	else:
		return

	var moved_right = cur_x > current_selection.x_pos
	var moved_left = cur_x < current_selection.x_pos

	current_selection = location.new(cur_x, cur_y)
	var cur_shop = get_shop_at(current_selection)
	$camera/shopdetails.text = cur_shop.text()
	$selector.position.x = cur_shop.position.x
	$selector.position.y = cur_shop.position.y

	if moved_right:
		$camera.position.x = cur_shop.position.x - SHOP_X/4
	if moved_left:
		$camera.position.x = cur_shop.position.x + SHOP_X/4

# timer callbacks

func customer_timer_cb():
	new_customer(3)

func tick_timer_cb():
	print("some time passes...")
	var to_remove = []
	for c in arcade_members:
		if util.chance(0.5):
			continue
		var remove = process_action(c)
		if remove != null:
			to_remove.append(remove)

#		if new_position.x_pos is int and old_position.x_pos is int:
#			if new_position.x_pos > old_position.x_pos:
#				c.flip_h = false
#			elif new_position.x_pos < old_position.x_pos:
#				c.flip_h = true
#			else:
#				c.flip_h = util.pick([true, false])

		if c.cur_action in [customer.Action.Moving, customer.Action.Leaving]:
			c.z_index = rng.randi_range(2000, 4000)
		if c.cur_action in [customer.Action.InShop, customer.Action.Browsing]:
			c.z_index = rng.randi_range(1000, 2000)
		print([c.cur_action, c.next_location])
		if c.cur_action in [customer.Action.Moving, customer.Action.Leaving]:
			var shop = get_shop_at(c.next_location)
			var shop_loc = get_customer_position(shop.position.x, shop.position.y)
			c.move_towards(shop_loc[0], shop_loc[1])

	if len(to_remove):
		var new_customer_list = []
		for c in arcade_members:
			if not (c in to_remove):
				new_customer_list.append(c)
			else:
				c.queue_free()
		arcade_members = new_customer_list

func get_customer_position(x: int, y: int):
	y = y + 2*7
	y = y + int(7.0*randf())
	x = x + int(7.0*randf())
	return [x, y]

func process_action(c):
	print(c)
	match c.cur_action:
		customer.Action.Moving:
			if location.same(c.loc, c.destination):
				print("customer " + str(c) + " has reached their destination!")
				c.cur_action = customer.Action.InShop
				c.z_index = rng.randi_range(3, 1000)
				return
			else:
				if not (c.loc in c.visited_locations):
					var cur_shop = get_shop_at(c.loc)
					for item in c.affinities.keys():
						if cur_shop.has_item(item):
							print("customer " + str(c) + " saw a " + item + " in the window...")
							if util.chance(c.affinities[item]):
								print(str(c) + " went in to browse!")
								c.cur_action = customer.Action.Browsing
								c.z_index = rng.randi_range(3, 1000)
								return
							else:
								print(str(c) + " wasn't interested...")
			c.loc = c.next_location
			c.next_location =  next_location(c.loc, c.destination)
			print("customer " + str(c) + " moving to " + str(c.loc))
		customer.Action.Leaving:
			if location.same(c.loc, c.destination):
				print("customer " + str(c) + " has left the arcade...")
				return c
			c.loc = c.next_location
			c.next_location =  next_location(c.loc, c.destination)
			print("customer " + str(c) + " leaving, moving to " + str(c.loc))
		customer.Action.Browsing:
			print("customer " + str(c) + " browsing...")
			var price = barter(c, get_shop_at(c.loc))
			if price:
				print("customer " + str(c) + " bought an item for $" + str(price) + "!")
				c.money = c.money - price
				money = money + price
				c.cur_action = customer.Action.Moving
				c.z_index = rng.randi_range(1000, 4000)
				c.visited_locations.append(c.loc)
			elif util.chance(0.6):
				print("customer " + str(c) + " got bored of browsing...")
				c.cur_action = customer.Action.Moving
				c.z_index = rng.randi_range(1000, 4000)
				c.visited_locations.append(c.loc)
		customer.Action.InShop:
			print("customer " + str(c) + " shopping...")
			var price = barter(c, get_shop_at(c.loc))
			if price:
				print("customer " + str(c) + " bought their item for $" + str(price) + "!")
				c.money = c.money - price
				money = money + price
				c.cur_action = customer.Action.Leaving
				c.z_index = rng.randi_range(1000, 4000)
				c.destination = util.pick([left_entrance(), right_entrance()])
			elif util.chance(0.3):
				print("customer " + str(c) + " left the shop without buying anything...")
				c.visited_locations.append(c.destination)
				for shop in get_destinations(c.desire):
					if shop.loc in c.visited_locations:
						print(str(c) + " isn't going to " + str(shop) + " again!")
						continue
					if util.chance(0.5):
						print(str(c) + " decided to go to " + str(shop) + " instead!")
						c.cur_action = customer.Action.Moving
						c.z_index = rng.randi_range(1000, 4000)
						c.destination = shop.loc
						return null
					else:
						print(str(c) + " decided not to go to " + str(shop))
				print(str(c) + " couldn't find a good shop, leaving...")
				c.cur_action = customer.Action.Leaving
				c.z_index = rng.randi_range(1000, 4000)
				c.destination = util.pick([left_entrance(), right_entrance()])

	return null

func random_shop(p: int) -> shop_details:
	var details = shop_details.new()
	details.thing_1 = data.get_shopbg_type()
	details.thing_2 = data.get_shop_type()
	details.thing_3 = data.get_shop_type()
	details.price = p
	return details

func new_customer(friendliness: int):
	var n = data.name()
	print("new customer, " + n + "!")
	for _i in range(friendliness):
		var desire = data.get_shop_type()
		print(n + " is looking for " + desire)
		var possible_destinations = get_destinations(desire)
		if not len(possible_destinations):
			print("no shop matching " + desire + "!")
			continue
		var destination = util.pick(possible_destinations)
		var richness = rng.randi_range(5, 15)
		var c = customer_scene.instance()
		c.init(
			rng.randi_range(0, 90),
			richness,
			desire,
			util.pick([left_entrance(), right_entrance()]),
			destination.loc,
			n
		)
		c.next_location =  next_location(c.loc, c.destination)
		add_child(c)
		print(n + " is buying " + desire + " from " + str(destination))
		arcade_members.append(c)
		return
	print(n + " leaves in disgust...")

func barter(c: customer, s: shop) -> int:
	var c_price = randfn_less(c.money, c.money/2)
	var s_price = randfn_pos(s.stats.price, s.stats.price/3)
	print(str(s) + " offers " + str(s_price) + ", " + c.customer_name + " has " + str(c_price))
	if s_price <= c_price:
		return s_price
	return 0

func randfn_pos(mean: float, dev: float) -> float:
	for _i in range(10):
		var res = rng.randfn(mean, dev)
		if res > 0:
			return res
	return 0.0

func randfn_less(top: float, dev: float) -> float:
	for _i in range(20):
		var res = rng.randfn(top, dev)
		if res > 0 and res <= top:
			return res
	return 0.0


func get_destinations(desire: String):
	var possible_shops = []
	for k in shops.values():
		for shop in k.values():
			if shop.has_item(desire):
				possible_shops.append(shop)
	return possible_shops

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

func left_exit() -> location:
	return location.new("left", "exit")
func right_exit() -> location:
	return location.new("right", "exit")

func left_entrance() -> location:
	return location.new(0, 0)

func right_entrance() -> location:
	return location.new(5, 0)

func get_shop_at(loc: location) -> shop:
	print("getting shop " + str(loc.x_pos) + " " + str(loc.y_pos))
	return shops[loc.x_pos][loc.y_pos]
