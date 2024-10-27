extends CanvasLayer

signal restart

var waiting_for_space:bool = false

func _process(delta: float) -> void:
	
	if visible:
		$DrShrink.rotate(delta)
	
	if Input.is_action_just_pressed("Shoot") && waiting_for_space:
		restart.emit()
		waiting_for_space = false
		

func display():
	show()
	await get_tree().create_timer(1).timeout
	

func _on_visibility_changed() -> void:
	if visible: 
		$PressAnyKey.hide()
		await get_tree().create_timer(1).timeout
		$PressAnyKey.show()
		waiting_for_space = true
		
