extends Area2D

var empty_sprite  = preload("res://graphics/custom/PotionMachineEmpty-Sheet.png")
var blue_sprite   = preload("res://graphics/custom/PotionMachineBlue-Sheet.png")
var red_sprite    = preload("res://graphics/custom/PotionMachineRed-Sheet.png")
var purple_sprite = preload("res://graphics/custom/PotionMachinePurple-Sheet.png")

@export var has_blue : bool = true
@export var has_red  : bool = false

@onready var player:Player = get_tree().get_first_node_in_group('Player') # <-- COOL!

func _ready() -> void:
	set_sprite()

func set_sprite():
	if has_blue && has_red: 
		$ShrinkInstructions.show()
		$Sprite2D.texture = purple_sprite
	elif has_blue && !has_red:
		$ShrinkInstructions.hide()
		$Sprite2D.texture = blue_sprite
	elif !has_blue && has_red:
		$ShrinkInstructions.hide()
		$Sprite2D.texture = red_sprite
	else:
		$ShrinkInstructions.hide()
		$Sprite2D.texture = empty_sprite

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		has_red = true
		set_sprite()
		area.queue_free()
	
	# Check if the player should be allowed to shrink
	if has_red && has_blue && overlaps_body(player):
		player.can_shrink = true

# TODO: Review how this is handled (probably after the game jam)
func _on_body_entered(body: Node2D) -> void:	
	if body is Player && has_blue && has_red:
		body.can_shrink = true

# TODO: Review how this is handled (probably after the game jam)
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.can_shrink = false
