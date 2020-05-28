extends Node2D

const ICON_PATH = "res://Inventory/assets/"

const ITEMS = {
	"ChestRig": {
		"asset": ICON_PATH + "Rig.png",
		"slot": "CHEST"
	},
	"AI2": {
		"asset": ICON_PATH + "AI2.png",
		"slot": "NONE"
	},
	"stick": {
		"asset": ICON_PATH + "stick.png",
		"slot": "WEAPON"
	},
	"error": {
		"asset": ICON_PATH + "error.png",
		"slot": "NONE"
	},
}

func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
