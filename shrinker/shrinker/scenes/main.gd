extends Node

func _on_level_victory() -> void:
	# TODO: Prevent the player from being able to continue moving around in the background
	$Level.hide()
	$UI.hide()
	$Music.stop()
	$VictoryScreen.show()


func _on_level_game_over() -> void:
	$Level.hide()
	$UI.hide()
	$Music.stop()
	$GameOverScreen.show()


func _on_game_over_screen_restart() -> void:
	print("RESTARTING!!!")
	$GameOverScreen.hide()
	$UI.show()
	$Music.play()
	$Level.show()


func _on_victory_screen_restart() -> void:
	print("RESTARTING!!!")
	$VictoryScreen.hide()
	$UI.show()
	$Music.play()
	$Level.show()
