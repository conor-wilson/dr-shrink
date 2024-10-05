extends CharacterBody2D

@export var walk_speed         : float = 300.0
@export var jump_speed         : float = 600.0
@export var gravity_multiplier : float = 1.0
@export var glide_effect       : float = 0.5

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	apply_gravity(delta)

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

	move_and_slide()

func apply_gravity(delta: float):
	if not is_on_floor():
		var vel_due_to_gravity:Vector2 = get_gravity() * gravity_multiplier * delta
		if velocity.y > 0 && Input.is_action_pressed("Jump"):
			vel_due_to_gravity *= glide_effect
			$Label.text = "GLIDING"
		else:
			$Label.text = "NOT GLIDING"
		
		velocity += vel_due_to_gravity
	else:
		$Label.text = "NOT GLIDING"
