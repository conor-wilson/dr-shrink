extends CharacterBody2D

signal fire_bullet(pos:Vector2, dir:Vector2)

const bullet_dist_from_player := 7

@export var walk_speed         := 300.0
@export var jump_speed         := 600.0
@export var gravity_multiplier := 1.0
@export var glide_effect       := 0.5

var has_gun : bool = true

func _process(delta: float) -> void:
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
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump()
	
	# Handle shoot input
	if Input.is_action_just_pressed("Shoot") and $ShootCooldown.is_stopped():
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
	if $AnimatedSprite2D.flip_h: 
		bullet_dir = Vector2.LEFT
	else:
		bullet_dir = Vector2.RIGHT
	
	# Derrive the position that the bullet should spawn at
	var bullet_pos := global_position
	bullet_pos += bullet_dir*bullet_dist_from_player
	
	# Fire the bullet and start the cooldown
	fire_bullet.emit(bullet_pos, bullet_dir)
	$ShootCooldown.start()

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
