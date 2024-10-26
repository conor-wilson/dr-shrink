extends Area2D

@export var original_scale := 4
@export var original_position : Vector2
var direction:Vector2 = Vector2.RIGHT
@export var speed:int = 50
@export var damage:int = 10

var damage_thresholds : Array[int] = [
	0,
	1,
	2,
	4,
	8
]

func _process(delta: float) -> void:
	if visible:
		move(delta)

func check_death(): 
	if scale == Vector2.ONE:
		hide()

func _on_area_entered(area: Area2D) -> void:
	
	if !visible:
		return
	
	# Confirm that this is a bullet (and then delete the bullet)
	if area is not Bullet:
		return
	area.queue_free()
	
	# Damage the worm
	scale = scale - Vector2.ONE
	$DamageSound.play()
	
	# Flicker the worm using the shader
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
	# Check for death
	await $DamageSound.finished
	
	position.y += 4
	check_death()

func _on_body_entered(body: Node2D) -> void:
	
	if !visible:
		return
	
	if body is Player:
		if scale.x >= damage_thresholds[body.current_size]:
			body.damage(damage)

func move(delta:float):
	
	if !visible:
		return
	
	position += direction * speed * delta

func _on_border_area_body_entered(body: Node2D) -> void:
	
	if !visible:
		return
	
	direction = -direction
	set_sprite_direction()

func set_sprite_direction():
	
	if !visible:
		return
		
	if direction.x >= 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		 


func _on_bottom_right_area_body_exited(body: Node2D) -> void:
	
	if !visible:
		return
	
	direction = Vector2.LEFT
	set_sprite_direction()

func _on_bottom_left_area_body_exited(body: Node2D) -> void:
	
	if !visible:
		return
	
	direction = Vector2.RIGHT
	set_sprite_direction()

func reset_health():
	scale = original_scale*Vector2.ONE
	position = original_position


func _on_visibility_changed() -> void:
	if visible:
		reset_health()
