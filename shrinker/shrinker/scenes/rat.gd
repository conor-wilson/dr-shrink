extends CharacterBody2D

var health := 2
var direction_x := 1
@export var speed := 100

func _process(delta : float):
	position.x += speed * direction_x * delta

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta: float):
	if not is_on_floor():
		var vel_due_to_gravity:Vector2 = get_gravity() * delta
		velocity += vel_due_to_gravity

func _on_boarder_area_body_entered(body: Node2D) -> void:
	if body is not CharacterBody2D:
		direction_x = -direction_x
