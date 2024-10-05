extends Area2D

var health := 2
var direction:Vector2 = Vector2.RIGHT
@export var speed:int = 50

func _process(delta: float) -> void:
	move(delta)

func check_death(): 
	if health == 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	
	# Confirm that this is a bullet (and then delete the bullet)
	if area is not Bullet:
		return
	area.queue_free()
	
	# Damage the worm
	health -= 1
	$DamageSound.play()
	
	# Flicker the worm using the shader
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
	# Check for death
	await $DamageSound.finished
	check_death()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(10)

func move(delta:float):
	position += direction * speed * delta

func _on_border_area_body_entered(body: Node2D) -> void:
	direction = -direction
	set_sprite_direction()

func set_sprite_direction():
	if direction.x >= 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		 


func _on_bottom_right_area_body_exited(body: Node2D) -> void:
	direction = Vector2.LEFT
	set_sprite_direction()

func _on_bottom_left_area_body_exited(body: Node2D) -> void:
	direction = Vector2.RIGHT
	set_sprite_direction()
