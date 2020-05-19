extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var wind = Wind.windDirection
var rng = RandomNumberGenerator.new()
var yoffset = -8

func _ready():
	rng.randomize()
	
	animationTree.active = true
	
#	var r = randi()
#	print(rng.get_seed())
#	seed(r)

	var a1 = animationPlayer.get_animation("WindRight").duplicate()
	animationPlayer.remove_animation("WindRight")
	a1.track_set_key_value(0, 1, Vector2(rng.randi_range(3, 5), yoffset))
	a1.track_set_key_value(0, 2, Vector2(rng.randi_range(3, 5), yoffset))
	a1.track_set_key_value(0, 3, Vector2(rng.randi_range(3, 5), yoffset))
	animationPlayer.add_animation("WindRight", a1)
	
	var a2 = animationPlayer.get_animation("WindLeft").duplicate()
	animationPlayer.remove_animation("WindLeft")
	a2.track_set_key_value(0, 1, Vector2(rng.randi_range(-3, -5), yoffset))
	a2.track_set_key_value(0, 2, Vector2(rng.randi_range(-3, -5), yoffset))
	a2.track_set_key_value(0, 3, Vector2(rng.randi_range(-3, -5), yoffset))
	animationPlayer.add_animation("WindLeft", a2)
	
	var a3 = animationPlayer.get_animation("WindDown").duplicate()
	animationPlayer.remove_animation("WindDown")
	a3.track_set_key_value(0, 1, Vector2(0, rng.randi_range(3, 5)+yoffset))
	a3.track_set_key_value(0, 2, Vector2(0, rng.randi_range(3, 5)+yoffset))
	a3.track_set_key_value(0, 3, Vector2(0, rng.randi_range(3, 5)+yoffset))
	animationPlayer.add_animation("WindDown", a3)
	
	var a4 = animationPlayer.get_animation("WindUp").duplicate()
	animationPlayer.remove_animation("WindUp")
	a4.track_set_key_value(0, 1, Vector2(0, rng.randi_range(-3, -5)+yoffset))
	a4.track_set_key_value(0, 2, Vector2(0, rng.randi_range(-3, -5)+yoffset))
	a4.track_set_key_value(0, 3, Vector2(0, rng.randi_range(-3, -5)+yoffset))
	animationPlayer.add_animation("WindUp", a4)
	
	
func _physics_process(delta):
	move_state(delta)
	
	
func move_state(delta):
	wind = Wind.windDirection
	if wind != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", wind)
		animationTree.set("parameters/Wind/blend_position", wind)
		animationState.travel("Wind")
	else:
		animationState.travel("Idle")
		
