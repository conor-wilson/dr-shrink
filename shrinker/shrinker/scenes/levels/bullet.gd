class_name Bullet extends Area2D

var speed     : float = 150
var direction : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction*speed*delta
	apply_gravity(delta)

func apply_gravity(delta: float):
	var vel_due_to_gravity:Vector2 = Vector2.DOWN * 2 * delta	
	direction += vel_due_to_gravity

func set_direction(direction:Vector2): 
	self.direction = direction
	print(direction)
	if direction.x <= 0:
		$Sprite2D.flip_h = true

func set_sprite_size(scale:float):
	$Sprite2D.scale = Vector2(1,1)*scale
	$CollisionShape2D.scale = Vector2(1,1)*scale
	speed *= scale



func _on_life_time_timeout() -> void:
	queue_free()
