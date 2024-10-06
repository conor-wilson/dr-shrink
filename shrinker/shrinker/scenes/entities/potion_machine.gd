extends Area2D

var empty_sprite  = preload("res://graphics/custom/PotionMachineEmpty-Sheet.png")
var blue_sprite   = preload("res://graphics/custom/PotionMachineBlue-Sheet.png")
var red_sprite    = preload("res://graphics/custom/PotionMachineRed-Sheet.png")
var purple_sprite = preload("res://graphics/custom/PotionMachinePurple-Sheet.png")

@export var has_blue : bool = false
@export var has_red  : bool = false

func _ready() -> void:
	set_sprite()

func set_sprite():
	if has_blue && has_red: 
		$Sprite2D.texture = purple_sprite
	elif has_blue && !has_red:
		$Sprite2D.texture = blue_sprite
	elif !has_blue && has_red:
		$Sprite2D.texture = red_sprite
	else:
		$Sprite2D.texture = empty_sprite




func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		has_red = true
		set_sprite()
		area.queue_free()
