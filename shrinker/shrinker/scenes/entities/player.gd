class_name Player extends CharacterBody2D

signal fire_bullet(pos:Vector2, dir:Vector2)
signal shrank

const bullet_dist_from_player := 56

@export var current_size : int = 4

var walk_speed         
var jump_speed         
var gravity_multiplier
var glide_effect    

# TODO: Review how these are set after the jam. Very jankey at the moment.
var walk_speeds: Array[float] = [
	150.0,  # Size 0 (not currently scoped)
	200.0,  # Size 1
	300.0,  # Size 2
	600.0,  # Size 3
	1000.0, # Size 4
]
var jump_speeds: Array[float] = [
	275,  # Size 0 (not currently scoped)
	550,  # Size 1
	950,  # Size 2
	1750, # Size 3
	3500, # Size 4
]
var grav_multipliers: Array[float] = [
	1, # Size 0 (not currently scoped)
	2.1, # Size 1
	3.5, # Size 2
	6, # Size 3
	10, # Size 4
]
var glide_effects: Array[float] = [
	0.25, # Size 0 (not currently scoped)
	0.25, # Size 1
	0.25, # Size 2
	0.25, # Size 3
	0.25, # Size 4
]

var has_gun          : bool = false
var is_swimming      : bool = false
var head_above_water : bool = true
var health           : int  = 100

# TODO: Review how this is handled (probably after the game jam) (this goes for basically eveything lmao)
var can_shrink:bool = false

func _ready():
	set_sprite_size()
	set_variable_params()

func _process(delta: float) -> void:
	apply_gravity(delta)
	handle_input()
	set_animation()
	move_and_slide()

func apply_gravity(delta: float):
	if not is_on_floor():
		var vel_due_to_gravity:Vector2 = get_gravity() * gravity_multiplier * delta
		if velocity.y > 0:
			if Input.is_action_pressed("Jump"):
				vel_due_to_gravity *= glide_effect
			if is_swimming:
				vel_due_to_gravity *= 0.1
		
		velocity += vel_due_to_gravity

func handle_input():
	
	if Input.is_action_just_pressed("Shrink") && can_shrink:
		shrink()
	
	# Handle jump input
	if Input.is_action_just_pressed("Jump") && (is_on_floor() or is_swimming):
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
	if is_swimming && !head_above_water: 
		velocity.y *= 0.6
	$Sounds/JumpSound.play()

func shoot():
	
	# Derrive the direction that the bullet should fire (TODO: Maybe make a direction var)
	var bullet_dir : Vector2 = Vector2.UP
	if $AnimatedSprite2D.flip_h: 
		bullet_dir += Vector2.LEFT
	else:
		bullet_dir += Vector2.RIGHT
	
	# Derrive the position that the bullet should spawn at
	var bullet_pos := global_position
	
	# Fire the bullet and start the cooldown
	fire_bullet.emit(bullet_pos, bullet_dir.normalized())
	$Sounds/FireSound.play()
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
	$Sounds/DamageSound.play()
	check_death()
	
	# Flicker the Player using the shader
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
	# Make the Player temporarily invulnerable
	$Timers/InvincibilityCooldown.start()

func shrink():
	current_size -= 1
	health = 100
	has_gun = false
	set_sprite_size()
	set_variable_params()
	shrank.emit()

func set_sprite_size():
	$AnimatedSprite2D.scale = Vector2(1,1)* pow(2, current_size)
	$CollisionShape2D.scale = Vector2(1,1)* pow(2, current_size)
	$Camera2D.zoom = Vector2(1,1)* (4* pow(2, -current_size))
	
func set_variable_params():
	walk_speed = walk_speeds[current_size]
	jump_speed = jump_speeds[current_size]
	gravity_multiplier = grav_multipliers[current_size]
	glide_effect = glide_effects[current_size]

func start_swimming():
	is_swimming = true
	if velocity.y > 0:
		velocity.y *= 0.3
	

func stop_swimming():
	is_swimming = false

func _on_surface_detector_area_entered(area: Area2D) -> void:
	head_above_water = false

func _on_surface_detector_area_exited(area: Area2D) -> void:
	head_above_water = true
