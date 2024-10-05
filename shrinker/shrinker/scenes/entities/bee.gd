extends Area2D

# TODO: This de-duplicate the enemy code

@export var speed: float = 25
@export var marker1: Marker2D
@export var marker2: Marker2D

var health := 3
@onready var target = marker2

func _process(delta: float) -> void:
	set_target()
	move(delta)

func check_death(): 
	if health == 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	
	# Confirm that this is a bullet (and then delete the bullet)
	if area is not Bullet:
		return
	area.queue_free()
	
	# Damage the worm and check for death
	health -= 1
	check_death()
	
	# Flicker the worm using the shader
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(1)

func move(delta: float):
	var direction : Vector2 = (target.position - position).normalized()
	position += direction * speed * delta
	set_sprite_direction(direction)

func set_target():
	if target == marker2 && position.distance_to(marker2.position) < 10:
		target = marker1
	elif target == marker1 && position.distance_to(marker1.position) < 10:
		target = marker2

func set_sprite_direction(direction:Vector2):
	if direction.x >= 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		 
