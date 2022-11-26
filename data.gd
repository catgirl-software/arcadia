class_name data

const shop_types = [
	"Potion components",
	"Colouratives",
	"Purifiers",
	"Oils",
	"Medicines",
	"Metals and Alloys",
	"Devices",
	"Hand implements",
	"Advanced implements",
	"Medical Implements",
	"Artefacts of Fire and Ice",
	"Translocationaries",
	"Armaments",
	"Precious metals and gemstones",
	"Musical Instruments",
	"Tomes",
	"Flexibles",
	"Skinworks",
	"Building Materials",
	"Furnishings",
	"Utensils",
	"Bindings",
	"Threads",
	"Textiles",
	"Clothing",
	"Lace and Embroidery",
	"Carpets",
	"Playthings",
	"Food",
	"Drinks",
]

const customer_names = [
	"Aloha Bitterfig",
	"Magpie Twistyhorn",
	"Blaze Limecup",
	"Badger Coppermello",
	"Sprinkles Beautycreek",
	"Mulberry Catcliff",
	"Raine Carrotglimmer",
	"Aodh Beautyswamp",
	"Aeden Snowcurl",
	"Tiger Daywhite",
	"Tangy Elmgrace",
	"Barley Frozenwink",
	"Twig Limefall",
	"Blaze Winterray",
	"Barley Sandylashes",
	"Moonbeam Islecloud",
	"Pistachio Citrusnut",
	"Luke Graydust",
	"Tarragon Broomwhisk",
	"Sprinkles Cutetwirls",
	"Infinity Lilydove",
	"Nora Icemint",
	"Marceline Seabeam",
	"Diamond Mapledew",
	"Sprinkles Poplarfruit",
	"Hydrangea Seatail",
	"Amy Rainbowwink",
	"Pine Plumfruit",
	"Pandora Olivemint",
	"Daffodil Greyvine",
	"Juniper Littlebutton",
	"Marina Seadew",
	"Poison Figboots",
	"Mossy Fernbush",
	"Jasmine Glitterroot",
	"Ezra Icespeck",
	"Marigold Foggyfly",
	"Heather Diamondgrace",
	"Clover Lightningcliff",
	"Sunlight Purplerock",
]

const associated_shops = {
	'Potion components': ['Purifiers', 'Oils', 'Advanced implements', 'Tomes'],
	'Colouratives': ['Skinworks', 'Textiles', 'Clothing', 'Carpets'],
	'Purifiers': ['Potion components', 'Clothing', 'Food', 'Drinks'],
	'Oils': ['Potion components', 'Metals and Alloys', 'Artefacts of Fire and Ice', 'Food'],
	'Medicines': ['Advanced implements', 'Medical Implements', 'Tomes', 'Utensils'],
	'Metals and Alloys': ['Oils', 'Hand implements', 'Armaments', 'Building Materials'],
	'Devices': ['Translocationaries', 'Musical Instruments', 'Furnishings', 'Lace and Embroidery'],
	'Hand implements': ['Metals and Alloys', 'Artefacts of Fire and Ice', 'Precious metals and gemstones', 'Bindings'],
	'Advanced implements': ['Potion components', 'Medicines', 'Precious metals and gemstones', 'Threads'],
	'Medical Implements': ['Medicines', 'Tomes', 'Skinworks', 'Textiles'],
	'Artefacts of Fire and Ice': ['Oils', 'Hand implements', 'Translocationaries', 'Food'],
	'Translocationaries': ['Devices', 'Artefacts of Fire and Ice', 'Flexibles', 'Bindings'],
	'Armaments': ['Metals and Alloys', 'Flexibles', 'Building Materials', 'Clothing'],
	'Precious metals and gemstones': ['Hand implements', 'Advanced implements', 'Musical Instruments', 'Lace and Embroidery'],
	'Musical Instruments': ['Devices', 'Precious metals and gemstones', 'Tomes', 'Playthings'],
	'Tomes': ['Potion components', 'Medicines', 'Medical Implements', 'Musical Instruments'],
	'Flexibles': ['Translocationaries', 'Armaments', 'Building Materials', 'Playthings'],
	'Skinworks': ['Colouratives', 'Medical Implements', 'Furnishings', 'Textiles'],
	'Building Materials': ['Metals and Alloys', 'Armaments', 'Flexibles', 'Carpets'],
	'Furnishings': ['Devices', 'Skinworks', 'Lace and Embroidery', 'Carpets'],
	'Utensils': ['Medicines', 'Bindings', 'Threads', 'Drinks'],
	'Bindings': ['Hand implements', 'Translocationaries', 'Utensils', 'Playthings'],
	'Threads': ['Advanced implements', 'Utensils', 'Lace and Embroidery', 'Carpets'],
	'Textiles': ['Colouratives', 'Medical Implements', 'Skinworks', 'Clothing'],
	'Clothing': ['Colouratives', 'Purifiers', 'Armaments', 'Textiles'],
	'Lace and Embroidery': ['Devices', 'Precious metals and gemstones', 'Furnishings', 'Threads'],
	'Carpets': ['Colouratives', 'Building Materials', 'Furnishings', 'Threads'],
	'Playthings': ['Musical Instruments', 'Flexibles', 'Bindings', 'Drinks'],
	'Food': ['Purifiers', 'Oils', 'Artefacts of Fire and Ice', 'Drinks'],
	'Drinks': ['Purifiers', 'Utensils', 'Playthings', 'Food'],
}

static func name() -> String:
	return util.pick(customer_names)
