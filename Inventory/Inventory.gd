extends Control

const item_base = preload("res://Inventory/ItemBase.tscn")

onready var inv_base = $InventoryBase
onready var grid_bkpk = $Stash
onready var eq_slots = $EquipmentSlots
onready var backpack_slot = $ScrollContainer/VBoxContainer/Control11/backpack
onready var rig_slot = $ScrollContainer/VBoxContainer/Control12/rig
onready var HotbarUI = get_tree().get_root().find_node("HotbarUI", true, false).get_child(0)

var player_inv_list = []

var item_held = null
var item_offset = Vector2()
var last_container = null
var last_pos = Vector2()
var last_item = null
var last_inventory = null
var last_rot = 0

var dbl_clk = false

func _ready():
	pickup_item("AI2")
	pickup_item("ChestRig")
	pickup_item("AI2")
	pickup_item("SSOPatrol")
	pickup_item("AK47")
	pickup_item("KCIAK47")
	pickup_item("AKGasBlock")
	pickup_item("AKHandGuard")
	pickup_item("AKMuzzleBreak")
	pickup_item("AKPistolGrip")
	pickup_item("AKStock")
	
	for a in range(10):
		pickup_item("7.62x39mm")
		
#func _on_backpack_changed_backpack(item):
#	player_inv_list.append(item)
		
func _on_Inventory_gui_input(event):
#	print(event)
	var cursor_pos = get_global_mouse_position()
	if event is InputEventMouseButton:
		if event.doubleclick:
			dbl_clk = true
			grab(cursor_pos)
			
			var c = get_container_under_cursor(cursor_pos)
			if c.has_method("insert_item"):
				if is_instance_valid(item_held) and "amount" in item_held.data:
					stack_similair(c)
				if is_instance_valid(item_held) and item_held.inv.size() > 0:
#					if item_held.find_node("VBox", true, false) or item_held.find_node("VBox", true, false):
#						for i in range(item_held.inv.size()):
#							item_held.remove_child(item_held.inv[i])
#					else:
					for i in range(item_held.inv.size()):
						item_held.add_child(item_held.inv[i])
									
			release(cursor_pos)
#func _on_VBoxContainer_gui_input(event):
#	print("ee")
#	if event is InputEventMouseButton:
#		var cursor_pos = get_global_mouse_position()
#		if event.doubleclick:
#			grab(cursor_pos)
#			stack_similair()
#			release(cursor_pos)

func _process(delta):
	var cursor_pos = get_global_mouse_position()
	if !dbl_clk:
		if Input.is_action_just_pressed("inv_grab") and Input.is_action_pressed("quick_equip"):
			grab(cursor_pos)
			if item_held != null:
				if !last_container.name == "Stash":
					if grid_bkpk.insert_item_at_first_available_spot(item_held):
						var prev_pos = item_held.rect_global_position
						change_parent(grid_bkpk, item_held)
						item_held.rect_global_position = prev_pos
						item_held = null
					else:
						return_item_to_last_slot(last_inventory)
				else:
					if backpack_slot.get_child_count() > 1:
						var backpack = backpack_slot.get_child(1).get_child(2).get_child(0).get_child(0)
						if backpack.insert_item_at_first_available_spot(item_held):
							var prev_pos = item_held.rect_global_position
							change_parent(backpack, item_held)
							item_held.rect_global_position = prev_pos
							item_held = null
						else:
							return_item_to_last_slot(last_inventory)
				
		elif Input.is_action_just_pressed("inv_grab"):
			grab(cursor_pos)
		elif Input.is_action_just_released("inv_grab"):
			release(cursor_pos)
		elif Input.is_action_just_pressed("rotate_item") and !Input.is_action_pressed("inv_grab"):
			var item = grab(cursor_pos)
			rotate_grabbed(cursor_pos, item)
			release(cursor_pos)
		elif Input.is_action_just_pressed("rotate_item") and Input.is_action_pressed("inv_grab"):
			rotate_grabbed(cursor_pos, last_item)
	if item_held != null and is_instance_valid(item_held):
		item_held.rect_global_position = cursor_pos + item_offset
	dbl_clk = false
		
func rotate_grabbed(cursor_pos, item):
	#var item = grab(cursor_pos, true)
	if item != null:
		if item.rect_rotation < 90:
			item.rect_rotation += 90
			item.rect_scale.y = -1
		else:
			item.rect_rotation = 0
			item.rect_scale.y = 1
	#release(cursor_pos)
	
#func _on_GridBackPack_gui_input(event):
#	if event is InputEventMouseButton:
#		var cursor_pos = get_global_mouse_position()
#		if event.doubleclick:
#			grab(cursor_pos)
#			stack_similair(c)
#			release(cursor_pos)
	
func stack_similair(c):
#	for a in grid_bkpk.items:
#		counter += 1
#		if a.get_global_rect().has_point(get_global_mouse_position()):
#			item_held = a
	var vBox = c.get_parent().get_parent()
	
	if vBox.name == "VBox":
		for h in range(vBox.get_child_count()):
			for b in range(vBox.get_child(h).get_child_count()):
				var grid = vBox.get_child(h).get_child(b)
				for i in range(len(grid.items)-1, -1, -1):
					var a = grid.items[i]
					if is_instance_valid(a):
						if "amount" in a.data:
							if item_held.get_meta("id") == a.get_meta("id"):
								if item_held.data["amount"] + a.data["amount"] <= item_held.data["max_stack"]:
									item_held.data["amount"] += a.data["amount"]
									item_held.update_display()
									
									grid.items.remove(i)
									
									set_grid(a, false, grid)
									
									a.queue_free()
									a = null
	else:
		for i in range(len(c.items)-1, -1, -1):
			var a = c.items[i]
			if is_instance_valid(a):
				if "amount" in a.data:
					if item_held.get_meta("id") == a.get_meta("id"):
						if item_held.data["amount"] + a.data["amount"] <= item_held.data["max_stack"]:
							item_held.data["amount"] += a.data["amount"]
							item_held.update_display()
							
							c.items.remove(i)
							
							set_grid(a, false, c)
							
							a.queue_free()
							a = null
							
func set_grid(item, type, c):
	var item_pos = item.rect_position + Vector2(c.cell_size/2, c.cell_size/2)
	
	var g_pos = c.pos_to_grid_coord(item_pos)
	var item_size_in_cells = c.get_grid_size(item)
	
	c.set_grid_space(g_pos, item_size_in_cells, type)

func change_parent(parent, child):
	if child.get_parent():
		child.get_parent().remove_child(child)
		if !parent:
			add_child(child)
			move_child(child, get_child_count())
		else:
			parent.add_child(child)
			parent.move_child(child, parent.get_child_count())


func grab(cursor_pos):
	var c = get_container_under_cursor(cursor_pos)
	if c and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_pos) 
		if item_held:
			last_container = c
			last_rot = item_held.rect_rotation
			
			#A monstrosity im too lazy to replace
			if item_held.inv.size() > 0:
				for i in range(item_held.inv.size()):
					if item_held.inv[i].get_child_count() > 1:
						for b in range(item_held.inv[i].get_child_count()):
							for c in range(item_held.inv[i].get_child(b).get_child_count()):
								if item_held.inv[i].get_child(b).get_child(c).get_child_count() > 0:
									for d in range(item_held.inv[i].get_child(b).get_child(c).get_child_count()):
										if item_held.inv[i].get_child(b).get_child(c).get_child(d).get_child_count() > 1:
											for e in range(item_held.inv[i].get_child(b).get_child(c).get_child(d).inv.size()):
												item_held.inv[i].get_child(b).get_child(c).get_child(d).remove_child(item_held.inv[i].get_child(b).get_child(c).get_child(d).inv[e])
					
					item_held.remove_child(item_held.inv[i])
			
			if c.has_method("get_item_under_pos"):
				last_inventory = c
			
			last_pos = item_held.rect_global_position
			item_offset = item_held.rect_global_position - cursor_pos
			last_item = item_held
			item_held.get_parent().move_child(item_held, item_held.get_parent().get_child_count())
			change_parent(null, item_held)
			item_held.rect_global_position = last_pos
			return item_held 

func get_container_under_cursor(cursor_pos):
	var containers = [backpack_slot, rig_slot, grid_bkpk, eq_slots, inv_base, HotbarUI]
	for c in player_inv_list:
		if c.get_parent() != null:
#			print(player_inv_list)
			if c.get_global_rect().has_point(cursor_pos):
				return c
	
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
		if Input.is_action_pressed("split_stack") and c.has_method("get_item_under_pos") and !dbl_clk:
			if "amount" in item_held.data:
				var prev_pos = item_held.rect_global_position
#				change_parent(c.get_parent(), item_held)
				change_parent(c, item_held)
				item_held.rect_global_position = prev_pos
				split_stack(c)
			else:
				return_item_to_last_slot(last_inventory)
						
		elif c.insert_item(item_held):
			var prev_pos = item_held.rect_global_position
			change_parent(c, item_held)
			item_held.rect_global_position = prev_pos
			item_held = null
		elif c.has_method("get_item_under_pos"):
			if "temp" in item_held.data:
				if !attach_attachment(item_held, c):
					return_item_to_last_slot(last_inventory)
				else:
					item_held = null
			elif "amount" in item_held.data:
				if merge_item(item_held, c):
					var prev_pos = item_held.rect_global_position
	#				change_parent(c.get_parent(), item_held)
					change_parent(c, item_held)
					item_held.rect_global_position = prev_pos
				else:
					return_item_to_last_slot(last_inventory)
#				merge_item(item_held)
			else:
				return_item_to_last_slot(last_inventory)
	else:
		return_item_to_last_slot(last_inventory)
		
func attach_attachment(item, c):
	var item_into = c.get_item_under_pos(get_global_mouse_position())
	if item_into != null and is_instance_valid(item_into):
		var item_dat = ItemDB.get_item(item.get_meta("id"))["value"]["compatible"]
		if item_into.get_meta("id") in item_dat:
			if c.has_method("update_item"):
				if !c.update_item(item_into, ItemDB.get_item(item.get_meta("id"))["value"]["compatible"][item_into.get_meta("id")]["size"]):
					return false
			if item_into.inv[0].insert_item_without_pos(item, item_into.get_child(0).get_child(0)):
				var prev = item.rect_position
				change_parent(item_into.inv[0], item)
				item.rect_position = prev
				item = null
				
				return true
	return false

func split_stack(container):
	if item_held.data["amount"]/2 > 0:
		var item_new = new_item(item_held, container)
		
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
			if !merge_item(item_new, container):
				item_held.data["amount"] = item_held.data["amount"]*2
				item_held.update_display()
				item_new.queue_free()
				item_new = null
		return_item_to_last_slot(last_inventory)
	else:
		return_item_to_last_slot(last_inventory)

func merge_item(item, c):
	var item_into = c.get_item_under_pos(get_global_mouse_position())
	if item_into != null and is_instance_valid(item_into) and item_into.get_instance_id() != item.get_instance_id():
		if item.get_meta("id") == item_into.get_meta("id"):
			if item.data["amount"] + item_into.data["amount"] <= item.data["max_stack"]:
				item_into.data["amount"] = item.data["amount"] + item_into.data["amount"]
				item_into.update_display()
				
				item.queue_free()
				item = null
				return true
	return false

func new_item(copy, c):
	var item_dat = ItemDB.get_item(copy.get_meta("id"))
	var item_new = item_base.instance()
	var cursor_pos = get_global_mouse_position()
	
	var item_texture = item_new.get_child(0).get_child(0)
	
	item_new.set_meta("id", copy.get_meta("id"))
	item_texture.texture = load(item_dat["value"]["asset"])
	
#	c.get_parent().add_child(item_new)
	c.add_child(item_new)
	
	item_texture.expand = true
	item_texture.rect_min_size = item_texture.rect_size*2
	
	item_new.init_item_type(item_dat["type"])
	item_new.rect_global_position = cursor_pos + item_offset
	item_new.rect_size = item_texture.rect_min_size
	
	return item_new
	
func drop_item():
	item_held.queue_free()
	item_held = null
	
func return_item_to_last_slot(c):
	var item_into = c.get_item_under_pos(last_pos)
	if item_into != null and is_instance_valid(item_into):
		merge_item(item_held, c)
	else:
		if item_held.get_parent() != c:
			change_parent(c, item_held)
		
		last_item.rect_rotation = last_rot
		
		if last_rot == 90:
			last_item.rect_scale.y = -1
		else:
			last_item.rect_scale.y = 1
		
		item_held.rect_global_position = last_pos
		last_container.insert_item(item_held)
		item_held = null
	
	
func pickup_item(item_id):
	var item = item_base.instance()
	item.set_meta("id", item_id)
	
	var item_dat = ItemDB.get_item(item_id)
	
	var item_texture = item.get_child(0).get_child(0)
	
	item_texture.texture = load(item_dat["value"]["asset"])
	
	item_texture.rect_min_size = item_texture.texture.get_size()
	
#	grid_bkpk.get_parent().add_child(item)
	grid_bkpk.add_child(item)
	
	item_texture.expand = true
	item_texture.rect_min_size = item_texture.rect_min_size*2
	item.rect_size = item_texture.rect_min_size
	
	item.init_item_type(item_dat["type"])
	
	if "gun" in item_dat["type"]:
		var Slots = preload("res://Inventory/GunUI.tscn")
		var slots = Slots.instance()
		slots.rect_position -= Vector2(60, -40) 
		
		player_inv_list.append(slots)
		item.inv.append(slots)
		
		add_child(slots)
		remove_child(slots)
		
	if "inv" in item_dat["value"]:
		
		var Vbox = preload("res://Inventory/VBox.tscn")
		var vbox = Vbox.instance()
		
		for y in range(item_dat["value"]["inv"].size()):
			
			var Hbox = preload("res://Inventory/HBox.tscn")
			var hbox = Hbox.instance()
			
			for x in range(item_dat["value"]["inv"][y].size()):
				var grid = preload("res://Inventory/BackPackBase.tscn")
				var new_grid = grid.instance()
	#			item.add_child(new_grid)
				var size = Vector2(item_dat["value"]["inv"][y][x][0], item_dat["value"]["inv"][y][x][1])*Vector2(new_grid.cell_size, new_grid.cell_size)
				
#				if x-1 >= 0:
#					new_grid.rect_position = item.rect_position - (Vector2(-(x*1.2), -(y*1.2))*Vector2(new_grid.cell_size, new_grid.cell_size)*Vector2(item_dat["value"]["inv"][y][x-1][0], item_dat["value"]["inv"][y][x-1][1])) - Vector2(-100, 0)
#				else:
#					new_grid.rect_position = item.rect_position - (Vector2(-(x*1.2), -(y*1.2))*Vector2(new_grid.cell_size, new_grid.cell_size)*Vector2(item_dat["value"]["inv"][y][x][0], item_dat["value"]["inv"][y][x][1])) - Vector2(-100, 0)
				new_grid.rect_position = Vector2(0,0)
				new_grid.rect_min_size = size
				
#				grid_s = new_grid.cell_size
				
#				item.inv.append(new_grid)
				hbox.add_child(new_grid)
				new_grid.rect_size = size
				player_inv_list.append(new_grid)
#
#				if y == item_dat["value"]["inv"].size()-1 and x == item_dat["value"]["inv"][y].size()-1:
#					max_val = size + Vector2(20, 20) + new_grid.rect_position + Vector2(-100, 0)
			
			vbox.add_child(hbox)
		
		vbox.rect_position -= Vector2(-100, 0) 
		item.inv.append(vbox)
		
		var back = preload("res://Inventory/invBackground.tscn")
		var new_back = back.instance()
		
		add_child(vbox)
		remove_child(vbox)
		
		new_back.rect_position = item.rect_position - Vector2(-90, 10)
		new_back.rect_size = vbox.rect_size + Vector2(20, 20)
		item.inv.insert(0, new_back)
		
#			item.remove_child(new_grid)
	
#	if item.data[item_dat["type"]]["amount"] != null:
#		item.get_child(0).visible = true
#		item.get_child(0).rect_position = item.rect_size
#		item.get_child(0).text = item.data["amount"]
	if !grid_bkpk.insert_item_at_first_available_spot(item):
		item.queue_free()
		return false
	return true
