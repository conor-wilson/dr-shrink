extends CanvasLayer

@onready var player:Player = get_tree().get_first_node_in_group('Player')

func _process(delta: float) -> void:
	$MarginContainer/ProgressBar.value = player.health
