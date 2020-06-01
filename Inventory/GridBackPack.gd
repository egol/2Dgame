extends TextureRect

var items = []

var grid = {}
var cell_size = 32
var grid_width = 0
var grid_height = 0

func create_empty_grid():
	for x in range(grid_width):
		grid[x] = {}
		for y in range(grid_height):
			grid[x][y] = false  # mark this grid cell as empty (occupied = "false")
		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	var s = get_grid_size(self)
	grid_width = s.width
	grid_height = s.height
	create_empty_grid()

			
			
func insert_item(item):
	# set item_pos to the center of the top-left cell
	var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
	
	var g_pos = pos_to_grid_coord(item_pos, item)
	var item_size_in_cells = get_grid_size(item)
	
	if is_grid_space_available(g_pos, item_size_in_cells):
		set_grid_space(g_pos, item_size_in_cells, true)
		item.rect_global_position = rect_global_position + Vector2(g_pos.x, g_pos.y) * cell_size
		#checked
		items.append(item)
		return true
	else:
		return false


func get_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
	
	return item

func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null and !is_instance_valid(item):
		return null
		
	var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
	
	var g_pos = pos_to_grid_coord(item_pos, item)
	var item_size_in_cells = get_grid_size(item)
	
	set_grid_space(g_pos, item_size_in_cells, false)
	
	items.remove(items.find(item))
	
	return item
	
	
func update_item(item):
		
#	var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
#	var g_pos = pos_to_grid_coord(item_pos, item)
#	var item_size_in_cells = get_grid_size(item)
#	set_grid_space(g_pos, item_size_in_cells, false)
#
#	items.remove(items.find(item))
#	return item
	pass
	
	
	
func get_item_under_pos(pos):
	#checked
	for item in items:
		if is_instance_valid(item) and item.has_method("update_display"):
			if item.get_global_rect().has_point(pos):
				return item
	return null
	
	
func set_grid_space(pos, item_size_in_cells, state):
	for i in range(pos.x , pos.x + item_size_in_cells.width):#+ item_size_in_cells.width
		for j in range(pos.y, pos.y + item_size_in_cells.height):
			grid[i][j] = state
	
		
func is_grid_space_available(pos, item_size_in_cells):
	if pos.x < 0 or pos.y < 0:
		return false
	if pos.x + item_size_in_cells.width > grid_width or pos.y + item_size_in_cells.height > grid_height:
		return false
		
	# check every cell in the grid if it's occupied	
	for i in range(pos.x, pos.x + item_size_in_cells.width):
		for j in range(pos.y, pos.y + item_size_in_cells.height):
			if grid[i][j]:  # is occupied already
				return false
	return true

	
func pos_to_grid_coord(pos, item):
	var local_pos = pos - rect_global_position
#	print(local_pos)
	var local_pivot = item.rect_pivot_offset + local_pos
	var results = {}
	results.x = int(local_pos.x / cell_size)
	results.y = int(local_pos.y / cell_size)
	

#	if item.rect_rotation == 90:
#		item.rect_global_position.x += item.rect_scale.y
#		pass
#		var temp = rotate_point(local_pivot, -90, local_pos)
#		results.x = int(temp.x / cell_size)-1
#		results.y = int(temp.y / cell_size)-1
		#print(results)
		
	return results

func get_grid_size(item):
# return the item's size in units of cell_size
	var results = {}
	
	if item.get_child(0) != null:
		var s = item.rect_size
		var r = item.rect_rotation
		if r == 90:
			s.x = item.rect_size.y
			s.y = item.rect_size.x
		results.width = clamp(int(s.x / cell_size), 1, 500)
		results.height = clamp(int(s.y / cell_size), 1, 500)
	else:
		var s = item.rect_size
		var r = item.rect_rotation
		if r == 90:
			s.x = item.rect_size.y
			s.y = item.rect_size.x
		results.width = clamp(int(s.x / cell_size), 1, 500)
		results.height = clamp(int(s.y / cell_size), 1, 500)
	return results
	
	
func insert_item_at_first_available_spot(item):
	for y in range(grid_height):
		for x in range(grid_width):
			if !grid[x][y]:
				item.rect_global_position = rect_global_position + Vector2(x, y) * cell_size
				if insert_item(item):
					return true
	return false
