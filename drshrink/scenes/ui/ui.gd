extends CanvasLayer

signal done_dialogue

@onready var player:Player = get_tree().get_first_node_in_group('Player')

var waiting_for_input : bool = false

func _ready() -> void:
	player.advance_dialogue.connect(_on_player_advance_dialogue)

func _process(delta: float) -> void:
	
	$MarginContainer/ProgressBar.value = player.health
	
	if player.visible && player.can_shrink:
		$ShrinkInstructions.show()
		$PotionInstructions.hide()
	else:
		$ShrinkInstructions.hide()

func show_first_dialogue():
	hide_all_dialogue()
	$DialogueRect.show()
	$Dialogue1.show()
	waiting_for_input = true

func show_second_dialogue():
	hide_all_dialogue()
	$DialogueRect.show()
	$Dialogue2.show()
	waiting_for_input = true

func hide_all_dialogue():
	$DialogueRect.hide()
	$Dialogue1.hide()
	$Dialogue2.hide()
	$FirstShrinkDialogue.hide()
	$SecondShrinkDialogue.hide()
	$ThirdShrinkDialogue.hide()

func show_potion_instructions():
	hide_all_dialogue()
	$PotionInstructions.show()
	waiting_for_input = true

func hide_potion_instructions():
	$PotionInstructions.hide()

func show_first_shrink_dialogue():
	hide_all_dialogue()
	$DialogueRect.show()
	$FirstShrinkDialogue.show()
	waiting_for_input = true

func show_second_shrink_dialogue():
	hide_all_dialogue()
	$DialogueRect.show()
	$SecondShrinkDialogue.show()
	waiting_for_input = true

func show_third_shrink_dialogue():
	hide_all_dialogue()
	$DialogueRect.show()
	$ThirdShrinkDialogue.show()
	waiting_for_input = true

func _on_player_advance_dialogue():
	if waiting_for_input:
		done_dialogue.emit()

func _on_timer_timeout() -> void:
	# NOTE: Lmao this is funilly coded but it works so I'm keeping it ¯\_(ツ)_/¯
	if $DialogueRect/PressSpace.text == "[SPACE]":
		$DialogueRect/PressSpace.text = "[SPACE] ."
	elif $DialogueRect/PressSpace.text == "[SPACE] .":
		$DialogueRect/PressSpace.text = "[SPACE] .."
	elif $DialogueRect/PressSpace.text == "[SPACE] ..":
		$DialogueRect/PressSpace.text = "[SPACE] ..."
	else:
		$DialogueRect/PressSpace.text = "[SPACE]"
