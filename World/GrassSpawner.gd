extends Node2D

export var width = 4
export var height = 4

var Grass = preload("res://World/AnimatedGrass.tscn")

var once = true

func _process(delta):
	if once:
		once = false
		for x in range(width):
			for y in range(height):
				var grass = Grass.instance()
				
				get_parent().add_child(grass)
				
				var offsetVec = Vector2(global_position.x + (32*x), global_position.y + (12*y))
				
				grass.global_position = offsetVec
