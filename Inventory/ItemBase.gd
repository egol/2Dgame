extends Control

onready var label = $Label

var ITEMTYPES = {
	"clothing": {
		"folded": false
	},
	"bullets": {
		"max_stack": 50,
		"amount": 1
	},
	"medical": {
		"uses": 5
	},
	"magazine": {
		"temp": 2,
		"amount": 0,
	},
	"attachments":{
		"temp": 2
	},
	"gun":{
		"size": Vector2(0,0)
	},
	"item": {
		"uses": 5
	},
	"backpack": {
		"equipped": false
	},
	"rig": {
		"equipped": false
	},
}

var data = null
var inv = []
#var const_data = null

func update_display():
	if "amount" in data:
		label.text = self.data["amount"] as String
		
		var size =  self.rect_size
		var selfsize = label.get_minimum_size()
		
		label.rect_position = Vector2(size.x - selfsize.x, size.y - selfsize.y)


func init_item_type(type):
	data = ITEMTYPES[type]
	
#	const_data = ItemDB.get_item(self.get_meta("id"))["value"]
	
#	var size self.get_parent(get_size())
#var selfsize = self.get_size() # unneeded unless doing below
#func _ready()
#  self.set_position(Vector2(size.x,size.y)
#  self.set_position(Vector2(size.x - selfsize.x,size.y - selfsize.y)
	
	if "amount" in data:
		label.visible = true
#		label.rect_position = self.rect_size
		label.text = self.data["amount"] as String
		
		var size =  self.rect_size
		var selfsize = label.get_minimum_size()
		
		label.rect_position = Vector2(size.x - selfsize.x, size.y - selfsize.y)
