extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var tooltip = $ToolTip
onready var dialogue = get_tree().get_root().find_node("Dialogue", true, false)
var talking = false
#onready var Dialogue = DialoguScene.find

var once = true

func _ready():
#	Dialogue.connect("start_dialogue", self, "started_dialogue")
	pass

func _physics_process(delta):
	var player = playerDetectionZone.player
	if  player == null:
		tooltip.visible = false
		dialogue.visible = false
	if Input.is_action_just_pressed("talk") and player != null:
		dialogue.visible = true
		dialogue.get_child(1).initialize()
		talking = !talking
#		var dialoguescene = DialogueScene.instance()
#		get_tree().get_root().find_node("CanvasLayer", true, false).add_child(dialoguescene)
#		dialoguescene.rect_global_position = Vector2(400, 500)
		tooltip.visible = false
	if !talking:
		dialogue.visible = false

func _on_PlayerDetectionZone_body_entered(body):
	tooltip.visible = true
