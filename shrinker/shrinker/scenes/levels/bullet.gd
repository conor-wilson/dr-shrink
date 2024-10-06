class_name Bullet extends Area2D

var speed     : float = 500
var direction : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction*speed*delta

func set_direction(direction:Vector2): 
	self.direction = direction
	print(direction)
	if direction.x <= 0:
		$Sprite2D.flip_h = true
