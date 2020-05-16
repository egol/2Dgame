extends Node2D

const CrateEffect = preload("res://Effects/CrateEffect.tscn")
onready var hurtbox = $Hurtbox

func create_crate_effect():
	var crateEffect = CrateEffect.instance()
	get_parent().add_child(crateEffect)
	crateEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_crate_effect()
	hurtbox.create_hit_effect()
	queue_free()
