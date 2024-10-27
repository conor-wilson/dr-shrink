extends Node2D

signal victory
signal game_over
signal potion_picked_up
signal first_shrink
signal second_shrink
signal third_shrink

const bullet_scene : PackedScene = preload("res://scenes/levels/bullet.tscn")

func _on_player_fire_bullet(pos:Vector2, dir:Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.position = pos
	bullet.set_direction(dir)
	bullet.set_sprite_size(pow(2, $Player.current_size))
	$Bullets.add_child(bullet)

func _on_player_shrink_me() -> void:
	victory.emit()


func _on_water_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		body.start_swimming()


func _on_water_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		body.stop_swimming()


func _on_player_shrank() -> void:
	reset_level()
	if $Player.current_size == 3:
		first_shrink.emit()
	elif $Player.current_size == 2:
		second_shrink.emit()
	elif $Player.current_size == 1: 
		third_shrink.emit()

func reset_level():
	$PotionMachine.has_red = false
	$Items/Gun.show()
	$PotionMachine.set_sprite()
	for enemy in $Enemies.get_children():
		enemy.show()
		enemy.reset_health()
	

func _on_player_victory() -> void:
	victory.emit()


func _on_player_dead() -> void:
	game_over.emit()


func _on_visibility_changed() -> void:
	if visible:
		$Player.show()
		reset_level()


func _on_gun_potion_picked_up() -> void:
	potion_picked_up.emit()
