extends Area2D

@export var float_amplitude := 10.0
@export var float_rate      := 0.005

func _process(delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() * float_rate) * float_amplitude * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player && visible:
		body.has_gun = true
		hide()
		$CollectSound.play()
