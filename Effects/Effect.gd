extends Sprite

export var Effect = preload("res://Effects/BloodEffect.tscn")

onready var animPlayer = $AnimationPlayer
	
func _process(delta):
	if !animPlayer.is_playing():
		animPlayer.play("death")

func create_death_effect():
	var bloodEffect = Effect.instance()
	bloodEffect.global_position = global_position - Vector2(-5,-9)
	get_parent().add_child(bloodEffect)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
