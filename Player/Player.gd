extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 500

var velocity = Vector2.ZERO

enum {
	MOVE,
	ROLL,
	INVENTORY,
	TALK
}

var state = MOVE
var bullet = preload("res://Player/Bullet.tscn")
var roll_vector = Vector2.DOWN
var stats = PlayerStats

#signal fired_shot

export var shoot_effect: PackedScene
export var bullet_speed = 1000
export var fire_rate = 0.1
var in_inventory = false
var talking = false

var can_fire = true
var once = false
var init = true

onready var animationPlayer = $Gun/gunanimation
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

onready var gun = $Gun
onready var gunbarrel = $Gun/gunbarrel
onready var gunsprite = $Gun/sprite
onready var hurtbox = $Hurtbox
var inventory = null
onready var canvas = get_tree().get_root().find_node("CanvasLayer", true, false)

func _ready():
	var Inventory = preload("res://Inventory/Inventory.tscn")
	inventory = Inventory.instance()
	
#	canvas.add_child(inventory, true)
#	canvas.remove_child(inventory)
	
	in_inventory = true
	once = true
	state = INVENTORY
	
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	
		
func _physics_process(delta):
	
	match state:
		MOVE: 
			move_state(delta)
			
		ROLL: 
			roll_state(delta)
			
		INVENTORY: 
			inventory_state(delta)
			
		TALK:
			talk_state()
			
			
func _process(delta):
	var look_vec = get_global_mouse_position() - global_position
	rotate_pointer(look_vec)
	if Input.is_action_pressed("shoot") and can_fire and state != INVENTORY and state != ROLL:
		var bullet_instance = bullet.instance()
		var bulletHitbox = bullet_instance.get_child(2)
		bullet_instance.position = gunbarrel.get_global_position()
		bullet_instance.rotation_degrees = gun.global_rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(gun.rotation))
		bulletHitbox.knockback_vector = roll_vector
		
		get_tree().get_root().add_child(bullet_instance)
		
		var temp = shoot_effect.instance()
		temp.position = gunbarrel.get_global_position()
		temp.rotation = gunbarrel.global_rotation
		get_tree().get_root().add_child(temp)
		
		animationPlayer.play("Shooting")
		
#		emit_signal("fired_shot")
		
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		
func inventory_state(delta):
#	var inv = get_tree().get_root().find_node("Inventory", true, false)
	if in_inventory and once:
		canvas.add_child(inventory, true)
		once = false
	if !in_inventory:
		canvas.remove_child(inventory)
		state = MOVE
	if init:
		init = false
		in_inventory = !in_inventory
		canvas.remove_child(inventory)
		state = MOVE
		
	if Input.is_action_just_pressed("open_inv"):
		in_inventory = !in_inventory
		
func talk_state():
	talking = false
	state = MOVE
#	if !talking:
#		state = MOVE
#	if Input.is_action_just_pressed("talk"):
#		talking = !talking
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		Wind.windDirection = input_vector
#		print(Wind.windDirection)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		roll_vector = input_vector
		
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
#	var direction = Vector2(cos(gunbarrel.global_rotation), sin(gunbarrel.global_rotation))
#	animationTree.set("parameters/Roll/blend_position", direction)
#	roll_vector = direction
	
	
	move()
	
	if gun.global_rotation_degrees > 90 or gun.global_rotation_degrees < -90:
		gunsprite.scale.y = -1
	else:
		gunsprite.scale.y = 1
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	if Input.is_action_just_pressed("open_inv"):
		in_inventory = !in_inventory
		once = true
		state = INVENTORY
	if Input.is_action_just_pressed("talk"):
		talking = !talking
		state = TALK
		
		
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func move():
	velocity = move_and_slide(velocity)	

func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE
			
func rotate_pointer(point_direction: Vector2) -> void:
	var temp = rad2deg(atan2(point_direction.y, point_direction.x))
	gun.rotation_degrees = temp
			
func kill():
	get_tree().reload_current_scene()

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
