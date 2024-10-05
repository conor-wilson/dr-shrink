extends CharacterBody2D

@export var walk_speed         := 300.0
@export var jump_speed         := 600.0
@export var gravity_multiplier := 1.0
@export var glide_effect       := 0.5

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_input()
	move_and_slide()

func apply_gravity(delta: float):
	if not is_on_floor():
		var vel_due_to_gravity:Vector2 = get_gravity() * gravity_multiplier * delta
		if velocity.y > 0 && Input.is_action_pressed("Jump"):
			vel_due_to_gravity *= glide_effect
			print("GLIDING!")
		
		velocity += vel_due_to_gravity

func handle_input(): 
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump()
	if Input.is_action_just_pressed("Shoot") and $ShootCooldown.is_stopped():
		shoot()
	var direction := Input.get_axis("Left", "Right")
	move(direction)

func jump():
	velocity.y = -jump_speed

func shoot():
	print("SHOOT!")
	$ShootCooldown.start()

func move(direction:float):
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
