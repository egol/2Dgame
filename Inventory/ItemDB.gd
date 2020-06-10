extends Node2D

const ICON_PATH = "res://Inventory/assets/"
const ICON_PATH_AMMO = "res://Inventory/assets/bullets/"
const ICON_PATH_CLOTHING = "res://Inventory/assets/clothing/"
const ICON_PATH_RIG = "res://Inventory/assets/rig/"
const ICON_PATH_MEDICAL = "res://Inventory/assets/medical/"
const ICON_PATH_BACKPACK = "res://Inventory/assets/backpacks/"
const ICON_PATH_GUNS = "res://Inventory/assets/guns/"

const ITEMS = {
	"error": {
		"asset": ICON_PATH + "error.png",
		"slot": "NONE"
	},
}

const CLOTHING = {
	"shirt": {
		"asset": ICON_PATH_CLOTHING + "Rig.png",
		"slot": "CHEST"
	},
}

const RIG = {
	"ChestRig": {
		"asset": ICON_PATH_RIG + "Rig.png",
		"slot": "RIG",
		"inv": [[[1,2], [1,2], [1,2]],
				[[1,2], [2,2], [1,2]]]
	},
}

const MEDICAL = {
	"AI2": {
		"asset": ICON_PATH_MEDICAL + "AI2.png",
		"slot": "NONE"
	},
}

const BACKPACK = {
	"SSOPatrol": {
		"asset": ICON_PATH_BACKPACK + "SSOPatrol.png",
		"slot": "BACKPACK",
		"inv": [[[5,6]],
				[[1,1], [1,1], [1,1], [1,1], [1,1]]]
	},
}

const GUNS = {
	"AK47": {
		"asset": ICON_PATH_GUNS + "ak47.png",
		"slot": "MAIN_HAND",
	},
}

const ATTACHMENTS = {
	"AK47": {
		"asset": ICON_PATH_GUNS + "ak47.png",
		"slot": "NONE",
		"accuracy": 50,
		"recoil": 20,
		"ergonomics": 10,
	},
}

const AMMO = {
	"7.62x39mm": {
		"asset": ICON_PATH_AMMO + "bullet.png",
		"slot": "NONE",
		"type": {
			"7N6M": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
			"7N22": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
		},
		"compatible": "AK",
		"description": "blank"
	},
	"9×19mm": {
		"asset": ICON_PATH_AMMO + "bullet.png",
		"slot": "NONE",
		"type": {
			"BALLMK1z": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
			"FMJ": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
			"m/39": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
		},
		"compatible": "pistol",
		"description": "blank"
	},
	"7.62x35mm": {
		"asset": ICON_PATH_AMMO + "bullet.png",
		"slot": "NONE",
		"type": {
			"115grUMC": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
			"90grBarnesOTFB": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
		},
		"compatible": "M4",
		"description": "blank"
	},
	"5.45×39mm": {
		"asset": ICON_PATH_AMMO + "bullet.png",
		"slot": "NONE",
		"type": {
			"7N6M": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
			"7N10": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
			"7N22": {
				"penetration": 5,
				"fragmentation": 30,
				"damage": 4,
			},
		},
		"compatible": "AK",
		"description": "blank"
	},
}


func get_item(item_id):
	
	var list = [AMMO, CLOTHING, MEDICAL, BACKPACK, ITEMS, RIG]
	var list_type = ["bullets", "clothing", "medical", "backpack", "item", "rig"]
	
	for i in range(list.size()):
		if item_id in list[i]:
#			print({"value": list[i][item_id], "type": list_type[i]})
			return {"value": list[i][item_id], "type": list_type[i]}
			
	return {"value": ITEMS["error"], "type": "item"}
	
	
#	if item_id in AMMO:
#		return {"value": AMMO[item_id], "type": "bullets"}
#	else:
#		if item_id in CLOTHING:
#			return {"value": CLOTHING[item_id], "type": "clothing"}
#		else:
#			if item_id in MEDICAL:
#				return {"value": MEDICAL[item_id], "type": "medical"}
#			else:
#				if item_id in BACKPACK:
#					return {"value": BACKPACK[item_id], "type": "backpack"}
#				else:
#					if item_id in ITEMS:
#						return {"value": ITEMS[item_id], "type": "item"}
#					else:
#						return {"value": ITEMS["error"], "type": "item"}
