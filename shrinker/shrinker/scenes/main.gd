extends Node

func _ready() -> void:
	$Level.show()
	$Music.play()
	$UI.show()
	$UI.show_first_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()
	$UI.show_second_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()

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
	$UI.show_first_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()
	$UI.show_second_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()


func _on_victory_screen_restart() -> void:
	print("RESTARTING!!!")
	$VictoryScreen.hide()
	$UI.show()
	$Music.play()
	$Level.show()
	$UI.show_first_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()
	$UI.show_second_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()


func _on_level_potion_picked_up() -> void:
	$UI.show_potion_instructions()
	await $UI.done_dialogue
	$UI.hide_potion_instructions()


func _on_level_first_shrink() -> void:
	$UI.show_first_shrink_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()


func _on_level_second_shrink() -> void:
	$UI.show_second_shrink_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()


func _on_level_third_shrink() -> void:
	$UI.show_third_shrink_dialogue()
	await $UI.done_dialogue
	$UI.hide_all_dialogue()
