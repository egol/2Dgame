extends Control

const item_base = preload("res://Inventory/ItemBase.tscn")

onready var inv_base = $InventoryBase
onready var grid_bkpk = $ScrollContainer/VBoxContainer/Control11/GridBackPack
onready var eq_slots = $EquipmentSlots

var item_held = null
var item_offset = Vector2()
var last_container = null
var last_pos = Vector2()
var last_item = null

func _ready():
	pickup_item("AI2")
	pickup_item("ChestRig")
	pickup_item("AI2")
	
	for a in range(10):
		pickup_item("7.62x39mm")
		
func _on_Inventory_gui_input(event):
	pass
#	if event is InputEventMouseButton:
#		var cursor_pos = get_global_mouse_position()
#		if event.doubleclick:
#			grab(cursor_pos)
#			stack_similair()
#			release(cursor_pos)
#		elif event.pressed:
#			if Input.is_action_just_pressed("inv_grab"):
#				print("yo")
#				grab(cursor_pos)
#		elif !event.pressed:
#			if Input.is_action_just_released("inv_grab"):
#				release(cursor_pos)
				


func _process(delta):
	var cursor_pos = get_global_mouse_position()
#	if Input.is_action_just_pressed("inv_grab"):
#		grab(cursor_pos)
#	if Input.is_action_just_released("inv_grab"):
#		release(cursor_pos)
	if Input.is_action_just_pressed("rotate_item"):
		rotate_grabbed(cursor_pos)
	if item_held != null and is_instance_valid(item_held):
		item_held.rect_global_position = cursor_pos + item_offset
		
func rotate_grabbed(cursor_pos):
	#var item = grab(cursor_pos, true)
	if last_item != null:
		if last_item.rect_rotation < 90:
			last_item.rect_rotation += 90
			last_item.rect_scale.y = -1
		else:
			last_item.rect_rotation = 0
			last_item.rect_scale.y = 1
	#release(cursor_pos)
	
func _on_GridBackPack_gui_input(event):
	if event is InputEventMouseButton:
		var cursor_pos = get_global_mouse_position()
		if event.doubleclick:
			grab(cursor_pos)
			stack_similair()
			release(cursor_pos)
		elif event.pressed:
			if Input.is_action_just_pressed("inv_grab"):
				grab(cursor_pos)
		elif !event.pressed:
			if Input.is_action_just_released("inv_grab"):
				release(cursor_pos)
	
func stack_similair():
#	for a in grid_bkpk.items:
#		counter += 1
#		if a.get_global_rect().has_point(get_global_mouse_position()):
#			item_held = a
	if is_instance_valid(item_held) and "amount" in item_held.data:
		for i in range(len(grid_bkpk.items)-1, 0, -1):
			var a = grid_bkpk.items[i]
			if is_instance_valid(a):
				if "amount" in a.data:
					if item_held.get_meta("id") == a.get_meta("id"):
						if item_held.data["amount"] + a.data["amount"] <= item_held.data["max_stack"]:
							item_held.data["amount"] += a.data["amount"]
							item_held.update_display()
#							if !a.is_queued_for_deletion():
							grid_bkpk.items.remove(i)
							
							set_grid(a, false)
							
							a.queue_free()
							a = null
							
func set_grid(item, type):
	var item_pos = item.rect_global_position + Vector2(grid_bkpk.cell_size/2, grid_bkpk.cell_size/2)
	
	var g_pos = grid_bkpk.pos_to_grid_coord(item_pos, item)
	var item_size_in_cells = grid_bkpk.get_grid_size(item)
	
	grid_bkpk.set_grid_space(g_pos, item_size_in_cells, type)
	
func grab(cursor_pos):
	var c = get_container_under_cursor(cursor_pos)
	if c and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_pos) 
		if item_held:
			last_container = c
			last_pos = item_held.rect_global_position
			item_offset = item_held.rect_global_position - cursor_pos
			last_item = item_held
			grid_bkpk.move_child(item_held, grid_bkpk.get_child_count())
			return item_held 


func get_container_under_cursor(cursor_pos):
	var containers = [grid_bkpk, eq_slots, inv_base]
	
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			return c
	return null

func release(cursor_pos):
	if not item_held:
		return
	if !is_instance_valid(item_held):
		return
	
	var c = get_container_under_cursor(cursor_pos)
	
	if not c:
		drop_item()
	elif c.has_method("insert_item"):
		if Input.is_action_pressed("split_stack"):
			if "amount" in item_held.data:
				split_stack(c)
			else:
				return_item_to_last_slot()
						
		elif c.insert_item(item_held):
			item_held = null
		else:
			if "amount" in item_held.data:
				merge_item(item_held)
			else:
				return_item_to_last_slot()
	else:
		return_item_to_last_slot()
		


func split_stack(container):
	if item_held.data["amount"]/2 > 0:
		var item_new = new_item(item_held)
		
		if item_held.data["amount"]%2 == 1: 
			item_new.data["amount"] = item_held.data["amount"]/2+1
		else:
			item_new.data["amount"] = item_held.data["amount"]/2
			
		item_held.data["amount"] /= 2
		
		item_held.update_display()
		item_new.update_display()
		
		if container.insert_item(item_new):
			item_new = null
		else:
			if !merge_item(item_new):
				item_held.data["amount"] = item_held.data["amount"]*2
				item_held.update_display()
				item_new.queue_free()
				item_new = null
		return_item_to_last_slot()
	else:
		return_item_to_last_slot()

func merge_item(item):
	var item_into = grid_bkpk.get_item_under_pos(get_global_mouse_position())
	if item_into != null and is_instance_valid(item_into):
		if item.get_meta("id") == item_into.get_meta("id"):
			if item.data["amount"] + item_into.data["amount"] <= item.data["max_stack"]:
				item_into.data["amount"] = item.data["amount"] + item_into.data["amount"]
				item_into.update_display()
				
				item.queue_free()
				item = null
				return true
	return false

func new_item(copy):
	var item_dat = ItemDB.get_item(copy.get_meta("id"))
	var item_new = item_base.instance()
	var cursor_pos = get_global_mouse_position()
	
	item_new.set_meta("id", copy.get_meta("id"))
	item_new.texture = load(item_dat["value"]["asset"])
	
	grid_bkpk.add_child(item_new)
	
	item_new.expand = true
	item_new.rect_size = item_new.rect_size*2
	
	item_new.init_item_type(item_dat["type"])
	item_new.rect_global_position = cursor_pos + item_offset
	
	return item_new
	
func drop_item():
	item_held.queue_free()
	item_held = null
	
func return_item_to_last_slot():
	var item_into = grid_bkpk.get_item_under_pos(last_pos)
	if item_into != null and is_instance_valid(item_into):
		merge_item(item_held)
	else:
		item_held.rect_global_position = last_pos
		last_container.insert_item(item_held)
		item_held = null
	
	
func pickup_item(item_id):
	var item = item_base.instance()
	item.set_meta("id", item_id)
	
	var item_dat = ItemDB.get_item(item_id)
	
	item.texture = load(item_dat["value"]["asset"])
	
	grid_bkpk.add_child(item)
	
	item.expand = true
	item.rect_size = item.rect_size*2
	
	item.init_item_type(item_dat["type"])
	
#	if item.data[item_dat["type"]]["amount"] != null:
#		item.get_child(0).visible = true
#		item.get_child(0).rect_position = item.rect_size
#		item.get_child(0).text = item.data["amount"]
		
	if !grid_bkpk.insert_item_at_first_available_spot(item):
		item.queue_free()
		return false
	return true
