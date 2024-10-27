extends CanvasLayer

signal done_dialogue

@onready var player:Player = get_tree().get_first_node_in_group('Player')

var waiting_for_input : bool = false

func _process(delta: float) -> void:
	$MarginContainer/ProgressBar.value = player.health
	
	if waiting_for_input:
		if Input.is_action_just_pressed("Shoot"):
			done_dialogue.emit()

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
