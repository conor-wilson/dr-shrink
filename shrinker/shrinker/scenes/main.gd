extends Node

func _on_level_victory() -> void:
	# TODO: Prevent the player from being able to continue moving around in the background
	$UI.hide()
	$Music.stop()
	$VictoryScreen.show()


func _on_level_game_over() -> void:
	$UI.hide()
	$Music.stop()
	$GameOverScreen.show()
