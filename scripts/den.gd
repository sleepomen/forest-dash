extends Area2D
## The fox's den at the end of the level. Reaching it wins the game.


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	var glow := create_tween().set_loops()
	glow.tween_property($Sprite, "modulate", Color(1.15, 1.1, 1.0), 1.0) \
		.set_trans(Tween.TRANS_SINE)
	glow.tween_property($Sprite, "modulate", Color(1, 1, 1), 1.0) \
		.set_trans(Tween.TRANS_SINE)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Game.win()
