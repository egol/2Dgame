extends Node2D

export var width = 4
export var height = 4

var Grass = preload("res://World/AnimatedGrass.tscn")

var once = true
var rng = RandomNumberGenerator.new()

func _process(delta):
	if once:
		once = false
		for x in range(width):
			for y in range(height):
				rng.randomize()
				
				var grass = Grass.instance()
				
				get_parent().add_child(grass)
				
				var offsetVec = Vector2(global_position.x + (x*rng.randi_range(20, 32)), global_position.y + (rng.randi_range(13, 16)*y))
				
				grass.global_position = offsetVec
