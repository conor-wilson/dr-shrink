extends Area2D

# TODO: This de-duplicate the enemy code

var health := 3

func _process(delta: float) -> void:
	check_death()

func check_death(): 
	if health == 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	health -= 1
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($Sprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($Sprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health -= 1
