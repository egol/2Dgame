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

	var a1 = animationPlayer.get_animation("Wind").duplicate()
	
	var t = rng.randf_range(1, 3)
	
	a1.track_set_key_value(0, 0, Vector2(t, yoffset))
	a1.track_set_key_value(0, 1, Vector2(rng.randf_range(4, 6), yoffset))
	a1.track_set_key_value(0, 2, Vector2(t, yoffset))
	
	t = rng.randf_range(5, 8)
	
	a1.track_set_key_value(1, 0, t)
	a1.track_set_key_value(1, 1, rng.randf_range(13, 20))
	a1.track_set_key_value(1, 2, t)
	
	a1.track_set_key_time(0, 1, rng.randf_range(0.3, 1.7))
	
	animationPlayer.add_animation("WindRight", a1)
	
	
	var a2 = animationPlayer.get_animation("Wind").duplicate()
	
	t = rng.randf_range(-1, -3)
	
	a2.track_set_key_value(0, 0, Vector2(t, yoffset))
	a2.track_set_key_value(0, 1, Vector2(rng.randf_range(-4, -6), yoffset))
	a2.track_set_key_value(0, 2, Vector2(t, yoffset))
	
	t = rng.randf_range(-5, -8)
	
	a2.track_set_key_value(1, 0, t)
	a2.track_set_key_value(1, 1, rng.randf_range(-13, -20))
	a2.track_set_key_value(1, 2, t)
	
	a2.track_set_key_time(0, 1, rng.randf_range(0.3, 1.7))
	
	animationPlayer.add_animation("WindLeft", a2)
	
	
	var a3 = animationPlayer.get_animation("Wind").duplicate()
	
	t = rng.randf_range(1, 3)
	
	a3.track_set_key_value(0, 0, Vector2(0, t-yoffset))
	a3.track_set_key_value(0, 1, Vector2(0, rng.randf_range(4, 6)-yoffset))
	a3.track_set_key_value(0, 2, Vector2(0, t-yoffset))
	
	t = Vector2(1, rng.randf_range(1, 1.1))
	
	a3.track_set_key_value(1, 0, t)
	a3.track_set_key_value(1, 1, Vector2(1, rng.randf_range(1, 1.4)))
	a3.track_set_key_value(1, 2, t)
	
	a3.track_set_key_time(0, 1, rng.randf_range(0.3, 1.7))
	
	animationPlayer.add_animation("WindDown", a3)

	var a4 = animationPlayer.get_animation("Wind").duplicate()
	
	t = rng.randf_range(-1, -3)
	
	a4.track_set_key_value(0, 0, Vector2(0, t-yoffset))
	a4.track_set_key_value(0, 1, Vector2(0, rng.randf_range(-4, -6)-yoffset))
	a4.track_set_key_value(0, 2, Vector2(0, t-yoffset))
	
	t = Vector2(1, rng.randf_range(1, 0.9))
	
	a4.track_set_key_value(1, 0, t)
	a4.track_set_key_value(1, 1, Vector2(1, rng.randf_range(1, 0.6)))
	a4.track_set_key_value(1, 2, t)
	
	a4.track_set_key_time(0, 1, rng.randf_range(0.3, 1.7))
	
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
		
