extends AnimatedSprite

export var Effect = preload("res://Effects/BloodEffect.tscn")

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	play("Animate")

func _on_animation_finished():
	if Effect != null:
		create_death_effect()
	queue_free()

func create_death_effect():
	var bloodEffect = Effect.instance()
	bloodEffect.global_position = global_position - Vector2(-5,-9)
	get_parent().call_deferred("add_child", bloodEffect)
