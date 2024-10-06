extends Area2D

var empty_sprite  = preload("res://graphics/custom/PotionMachineEmpty-Sheet.png")
var blue_sprite   = preload("res://graphics/custom/PotionMachineBlue-Sheet.png")
var red_sprite    = preload("res://graphics/custom/PotionMachineRed-Sheet.png")
var purple_sprite = preload("res://graphics/custom/PotionMachinePurple-Sheet.png")

@export var has_blue : bool = false
@export var has_red  : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if has_blue && has_red: 
		$Sprite2D.texture = purple_sprite
	elif has_blue && !has_red:
		$Sprite2D.texture = blue_sprite
	elif !has_blue && has_red:
		$Sprite2D.texture = red_sprite
	else:
		$Sprite2D.texture = empty_sprite
