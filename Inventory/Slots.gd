extends Panel

onready var slots = get_children()
var items = {}
var cosmetic_base = preload("res://Inventory/Attachment.tscn")
var cosmetic_list = {}

func _ready():
	for slot in slots:
		items[slot.name] = null
		cosmetic_list[slot.name] = null
		
func insert_item(item):
	var item_pos = item.rect_global_position + item.rect_size / 2
	var slot = get_slot_under_pos(item_pos)
	
	if slot == null:
		return false
	
	var item_data = ItemDB.get_item(item.get_meta("id"))["value"]
	
	var item_slot = item_data["slot"]
	
	if item_slot != slot.name:
		return false
	if items[item_slot] != null:
		return false
		
	# place the item into the equipment slot
	items[item_slot] = item
	item.rect_global_position = slot.rect_global_position + slot.rect_size/2 - item.rect_size/2
	
	var offset = (item_data["compatible"][self.get_parent().get_meta("id")]["pos"])*2
	var size = item_data["compatible"][self.get_parent().get_parent().get_meta("id")]["size"]
	
	var cosmetic = cosmetic_base.instance()
	cosmetic.texture = load(item_data["asset_gun"])
	cosmetic.rect_min_size = cosmetic.texture.get_size()
	
	if "show_behind" in item_data["compatible"][self.get_parent().get_meta("id")]:
		cosmetic.show_behind_parent = true
	
	self.get_parent().add_child(cosmetic)
	
	cosmetic.size = size
	cosmetic.pos = offset
	
	cosmetic.expand = true
	cosmetic.rect_size = cosmetic.rect_min_size*2
	cosmetic.rect_position = offset
	
	cosmetic_list[item_slot] = cosmetic
	
	return true

func insert_item_without_pos(item, parent):
	var item_data = ItemDB.get_item(item.get_meta("id"))["value"]
	
	var item_slot = item_data["slot"]
	
	var slot = null
	for i in range(self.get_child_count()):
		if self.get_child(i).name == item_slot:
			slot = self.get_child(i)
	
	if slot == null:
		return false
		
	if item_slot != slot.name:
		return false
	if items[item_slot] != null:
		return false
		
	# place the item into the equipment slot
	items[item_slot] = item
	item.rect_position = slot.rect_position + slot.rect_size/2 - item.rect_size/2
	
	var offset = (item_data["compatible"][parent.get_parent().get_parent().get_meta("id")]["pos"])*2
	var size = item_data["compatible"][parent.get_parent().get_parent().get_meta("id")]["size"]
	var cosmetic = cosmetic_base.instance()
	cosmetic.texture = load(item_data["asset_gun"])
	cosmetic.rect_min_size = cosmetic.texture.get_size()
	
	if "show_behind" in item_data["compatible"][parent.get_parent().get_parent().get_meta("id")]:
		cosmetic.show_behind_parent = true
	
	parent.add_child(cosmetic)
	
	cosmetic.size = size
	cosmetic.pos = offset
	
	cosmetic.expand = true
	cosmetic.rect_size = cosmetic.rect_min_size*2
	cosmetic.rect_position = offset
	
	cosmetic_list[item_slot] = cosmetic
	
	return true
	
func grab_item(pos):
	var item = get_item_under_pos(pos)
	
	if !item:
		return null
		
	var item_slot = ItemDB.get_item(item.get_meta("id"))["value"]["slot"]
	items[item_slot] = null
	
	self.get_parent().rect_size -= (cosmetic_list[item_slot].size*32)
	self.get_parent().get_child(0).rect_position -= cosmetic_list[item_slot].size*32
	
#	self.get_parent().remove_child(cosmetic_list[item_slot])
	self.get_parent().get_child(0).get_child(0).remove_child(cosmetic_list[item_slot])
	cosmetic_list[item_slot] = null
#	self.get_parent()
	
	return item
	
		
func get_slot_under_pos(pos):
	return get_thing_under_pos(slots, pos)
	
	
func get_item_under_pos(pos):
	return get_thing_under_pos(items.values(), pos)
	
	
func get_thing_under_pos(arr, pos):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
	
	
