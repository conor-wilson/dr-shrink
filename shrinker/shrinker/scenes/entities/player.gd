extends CharacterBody2D

signal glide
signal shoot

@export var walk_speed         := 300.0
@export var jump_speed         := 600.0
@export var gravity_multiplier := 1.0
@export var glide_effect       := 0.5

var direction_x := 0.0

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement()
	handle_shoot()
	move_and_slide()

func apply_gravity(delta: float):
	if not is_on_floor():
		var vel_due_to_gravity:Vector2 = get_gravity() * gravity_multiplier * delta
		if velocity.y > 0 && Input.is_action_pressed("Jump"):
			vel_due_to_gravity *= glide_effect
			glide.emit()
		
		velocity += vel_due_to_gravity


func handle_jump():
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -jump_speed

# TODO: Create a handle_input() function

func handle_movement():
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

func handle_shoot():
	if Input.is_action_pressed("Shoot"):
		shoot.emit()


func _on_glide() -> void:
	$Label.text = "GLIDE"


func _on_shoot() -> void:
	$Label.text = "BANG!"
