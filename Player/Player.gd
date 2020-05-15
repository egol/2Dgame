extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

var velocity = Vector2.ZERO

signal fired_shot

export var shoot_effect: PackedScene

onready var animationPlayer = $Gun/gunanimation
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

onready var gun = $Gun
onready var raycast = $Gun/RayCast2D
onready var gunbarrel = $Gun/gunbarrel
onready var gunsprite = $Gun/sprite

func _unhandled_input(event):
	if event.is_action_pressed("shoot") and raycast.is_colliding():
		emit_signal("fired_shot", raycast.get_collision_point())
		var temp = shoot_effect.instance()
		add_child(temp)
		temp.position = gunbarrel.global_position - global_position
		temp.rotation = gunbarrel.global_rotation
		animationPlayer.play("Shooting")
		
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)	
	
	if gun.global_rotation_degrees > 90 or gun.global_rotation_degrees < -90:
		gunsprite.scale.y = -1
	else:
		gunsprite.scale.y = 1
	
	
	var look_vec = get_global_mouse_position() - global_position
	rotate_pointer(look_vec)
			
			
func rotate_pointer(point_direction: Vector2) -> void:
	var temp = rad2deg(atan2(point_direction.y, point_direction.x))
	gun.rotation_degrees = temp
			
func kill():
	get_tree().reload_current_scene()
