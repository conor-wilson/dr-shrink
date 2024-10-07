extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func display():
	show()
	await get_tree().create_timer(1).timeout
	

func _on_visibility_changed() -> void:
	if visible: 
		$PressAnyKey.hide()
		await get_tree().create_timer(1).timeout
		$PressAnyKey.show()
