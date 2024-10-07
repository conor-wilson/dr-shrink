extends Node2D

signal victory

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
	$PotionMachine.has_red = false
	$Items/Gun.enable()
	$PotionMachine.set_sprite()
	$Items.queue_redraw()


func _on_player_victory() -> void:
	victory.emit()
