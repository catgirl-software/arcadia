extends Node

var details: shop_details
var has_shop: bool = false

class_name shop_buy_icon

func _ready():
	$Signs.visible = false

func add_shop(shop: shop_details):
	details = shop
	$Signs.visible = true
	has_shop = true
	$Signs.frame = data.shop_types.find(shop.thing_2)

func buy_shop() -> shop_details:
	has_shop = false
	$Signs.visible = false
	return details

func text() -> String:
	if has_shop:
		return details.text()
	return "No shop available"
