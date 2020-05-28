extends Node2D

onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var shadow = $shadow
export var item_name = "error"
export var size = 1


onready var inventory = get_tree().get_root().find_node("Inventory", true, false)

func _ready():
	var s = ItemDB.get_item(item_name)["asset"]
	
#	print(s.insert(s.length()-4, "_item"))
#	animation.play("floating")
	
	sprite.texture = load(s.insert(s.length()-4, "_item"))
	shadow.texture = load(s.insert(s.length()-4, "_item"))
	
	sprite.scale *= size
	shadow.scale *= size
	
#	shadow.scale = Vector2(sprite.texture.get_width()/22*sprite.scale.x, sprite.texture.get_height()/22*sprite.scale.y)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var distance = mouse_pos.distance_to(sprite.global_position)
	if distance < 5*((sprite.texture.get_width()+sprite.texture.get_height()-7)/35)*size:
		sprite.use_parent_material = true
		shadow.use_parent_material = true
		
		if Input.is_action_just_pressed("shoot"):
			inventory.pickup_item(item_name)
			queue_free()
		
	else:
		sprite.use_parent_material = false
		shadow.use_parent_material = false

