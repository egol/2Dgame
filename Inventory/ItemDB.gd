extends Node2D

const ICON_PATH = "res://Inventory/assets/"
const ICON_PATH_AMMO = "res://Inventory/assets/bullets/"
const ICON_PATH_CLOTHING = "res://Inventory/assets/clothing/"
const ICON_PATH_RIG = "res://Inventory/assets/rig/"
const ICON_PATH_MEDICAL = "res://Inventory/assets/medical/"
const ICON_PATH_BACKPACK = "res://Inventory/assets/backpacks/"
const ICON_PATH_GUNS = "res://Inventory/assets/guns/"
const ICON_PATH_MAGS = "res://Inventory/assets/mags/"
const ICON_PATH_ATTACHMENTS = "res://Inventory/assets/attachments/"

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

const MAGAZINE = {
	"KCIAK47":{
		"asset": ICON_PATH_MAGS + "ak30rdKCI.png",
		"asset_gun": ICON_PATH_GUNS + "ak30rdKCI.png",
		"max_cap": 30,
		"type": "7.62x39mm",
		"slot": "MAG",
		"compatible": {
			"AK47":{
				"pos": Vector2(11, 9),
				"size": Vector2(0, 1),
				"show_behind": true,
				},
		},
	},
}

const GUNS = {
	"AK47": {
		"asset": ICON_PATH_GUNS + "ak47body.png",
		"slot": "MAIN_HAND",
		"ammo": "7.62x39mm",
		"hotbar": true,
	},
}

const ATTACHMENTS = {
	"AKGasBlock": {
		"asset": ICON_PATH_ATTACHMENTS + "akGasBlockStandard.png",
		"asset_gun": ICON_PATH_GUNS + "akGasBlockStandard.png",
		"compatible": {
			"AK47":{
				"pos": Vector2(-3, -4),
				"size": Vector2(0, 0)
				},
		},
		"slot": "GASBLOCK",
	},
	"AKHandGuard": {
		"asset": ICON_PATH_ATTACHMENTS + "akHandGuardWood.png",
		"asset_gun": ICON_PATH_GUNS + "akHandGuardWood.png",
		"compatible": {
			"AK47":{
				"pos": Vector2(21, -1),
				"size": Vector2(0, 0)
				},
		},
		"slot": "HANDGUARD",
	},
	"AKMuzzleBreak": {
		"asset": ICON_PATH_ATTACHMENTS + "akMuzzleBreak.png",
		"asset_gun": ICON_PATH_GUNS + "akMuzzleBreak.png",
		"compatible": {
			"AK47":{
				"pos": Vector2(53, -2),
				"size": Vector2(0, 0)
				},
		},
		"slot": "MUZZLE",
	},
	"AKPistolGrip": {
		"asset": ICON_PATH_ATTACHMENTS + "akPistolGripWood.png",
		"asset_gun": ICON_PATH_GUNS + "akPistolGripWood.png",
		"compatible": {
			"AK47":{
				"pos": Vector2(-6, 7),
				"size": Vector2(0, 1)
				},
		},
		"slot": "GRIP",
	},
	"AKStock": {
		"asset": ICON_PATH_ATTACHMENTS + "akStockWood.png",
		"asset_gun": ICON_PATH_GUNS + "akStockWood.png",
		"compatible": {
			"AK47":{
				"pos": Vector2(-30, 1),
				"size": Vector2(2, 0)
				},
		},
		"slot": "STOCK",
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
	
	var list = [AMMO, CLOTHING, MEDICAL, BACKPACK, ITEMS, RIG, GUNS, MAGAZINE, ATTACHMENTS]
	var list_type = ["bullets", "clothing", "medical", "backpack", "item", "rig", "gun", "magazine", "attachments"]
	
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
