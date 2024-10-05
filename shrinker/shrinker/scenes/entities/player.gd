class_name Player extends CharacterBody2D

signal fire_bullet(pos:Vector2, dir:Vector2)

const bullet_dist_from_player := 14

@export var walk_speed         := 300.0
@export var jump_speed         := 600.0
@export var gravity_multiplier := 1.0
@export var glide_effect       := 0.5

var has_gun : bool = false
var health  : int  = 100

func _process(delta: float) -> void:
	check_death()
	apply_gravity(delta)
	handle_input()
	set_animation()
	move_and_slide()

func apply_gravity(delta: float):
	if not is_on_floor():
		var vel_due_to_gravity:Vector2 = get_gravity() * gravity_multiplier * delta
		if velocity.y > 0 && Input.is_action_pressed("Jump"):
			vel_due_to_gravity *= glide_effect
			print("GLIDING!")
		
		velocity += vel_due_to_gravity

func handle_input():
	
	# Handle jump input
	if Input.is_action_just_pressed("Jump") && is_on_floor():
		jump()
	
	# Handle shoot input
	if Input.is_action_just_pressed("Shoot") && $Timers/ShootCooldown.is_stopped() && has_gun :
		shoot()
	
	# Handle the directional input
	var direction := Input.get_axis("Left", "Right")
	move(direction)
	set_direction(direction)

func jump():
	velocity.y = -jump_speed

func shoot():
	
	# Derrive the direction that the bullet should fire (TODO: Maybe make a direction var)
	var bullet_dir : Vector2
	var fire_animation : Sprite2D
	if $AnimatedSprite2D.flip_h: 
		bullet_dir = Vector2.LEFT
		fire_animation = $Fire/FireLeft
	else:
		bullet_dir = Vector2.RIGHT
		fire_animation = $Fire/FireRight
	
	# Derrive the position that the bullet should spawn at
	var bullet_pos := global_position
	bullet_pos += bullet_dir*bullet_dist_from_player
	
	# Fire the bullet and start the cooldown
	fire_bullet.emit(bullet_pos, bullet_dir)
	fire_animation.show()
	await get_tree().create_timer(0.1).timeout
	fire_animation.hide()
	$Timers/ShootCooldown.start()

func move(direction:float):
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

func set_animation():
	
	# Idle animation
	if velocity == Vector2.ZERO:
		if has_gun:
			$AnimatedSprite2D.animation = 'idle_gun'
		else: 
			$AnimatedSprite2D.animation = 'idle'
	
	# Jump animation
	elif !is_on_floor():
		if has_gun:
			$AnimatedSprite2D.animation = 'jump_gun'
		else: 
			$AnimatedSprite2D.animation = 'jump'
	
	# Walk animation
	else:
		if has_gun:
			$AnimatedSprite2D.animation = 'walk_gun'
		else: 
			$AnimatedSprite2D.animation = 'walk'

func set_direction(direction:float):
	if direction != 0:
		$AnimatedSprite2D.flip_h = (direction <= 0)

func check_death():
	if health <= 0:
		get_tree().quit()

func damage(amount:int):
	
	# Check for invincibility
	if !$Timers/InvincibilityCooldown.is_stopped():
		return
	
	# Damage the Player's health and check for death
	health -= amount
	check_death()
	
	# Flicker the Player using the shader
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
	# Make the Player temporarily invulnerable
	$Timers/InvincibilityCooldown.start()
