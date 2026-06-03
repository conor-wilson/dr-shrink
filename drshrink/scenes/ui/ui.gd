extends CanvasLayer

signal done_dialogue

@onready var player:Player = get_tree().get_first_node_in_group('Player')

var waiting_for_input : bool = false

func _ready() -> void:
	player.advance_dialogue.connect(_on_player_advance_dialogue)

func _process(delta: float) -> void:
	
	$PotionInstructions/Label.text = "["+Global.interact_button_text+"] TO THROW SHRINK CATALYST"
	$ShrinkInstructions/Label.text = "["+Global.interact_button_text+"] TO DRINK POTION"
	
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
	if $DialogueRect/PressSpace.text == Global.prompt_spaces + "[" + Global.interact_button_text + "]":
		$DialogueRect/PressSpace.text = Global.prompt_spaces + "[" + Global.interact_button_text + "] ."
	elif $DialogueRect/PressSpace.text == Global.prompt_spaces + "[" + Global.interact_button_text + "] .":
		$DialogueRect/PressSpace.text = Global.prompt_spaces + "[" + Global.interact_button_text + "] .."
	elif $DialogueRect/PressSpace.text == Global.prompt_spaces + "[" + Global.interact_button_text + "] ..":
		$DialogueRect/PressSpace.text = Global.prompt_spaces + "[" + Global.interact_button_text + "] ..."
	else:
		$DialogueRect/PressSpace.text = Global.prompt_spaces + "[" + Global.interact_button_text + "]"
