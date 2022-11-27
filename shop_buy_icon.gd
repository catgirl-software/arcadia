extends Node

var details: shop_details
var has_shop: bool = false

class_name shop_buy_icon

func _ready():
	$Signs.visible = false
	$Iconglow.visible = false
	$Newshopselector.visible = false

func add_shop(shop: shop_details):
	details = shop
	has_shop = true
	$Signs.frame = data.shop_types.find(shop.thing_2)
	$Signs.visible = true
	$Blankicon.visible = false
	$Iconglow.visible = true

func buy_shop() -> shop_details:
	has_shop = false
	$Signs.visible = false
	$Blankicon.visible = true
	$Iconglow.visible = false
	deselect()
	return details

func select():
	$Iconglow.visible = false
	$Newshopselector.visible = true
func deselect():
	$Newshopselector.visible = false

func text() -> String:
	if has_shop:
		return details.text()
	return "No shop available"
