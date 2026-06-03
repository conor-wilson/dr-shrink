extends CanvasLayer

signal restart

var waiting_for_space:bool = false
@export var space_action_text:String = "START"

func _process(delta: float) -> void:
	
	$PressAnyKey.text = "PRESS " + Global.interact_button_text + " TO " + space_action_text
	
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
		
