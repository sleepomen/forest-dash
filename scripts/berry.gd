extends Area2D
## A berry the fox can pick up. Bobs gently, pops when collected.

@onready var sprite: Sprite2D = $Sprite
@onready var pop: CPUParticles2D = $Pop

var _collected := false


func _ready() -> void:
	Game.register_berry()
	body_entered.connect(_on_body_entered)

	var bob := create_tween().set_loops()
	bob.tween_property(sprite, "position:y", -5.0, 0.8) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bob.tween_property(sprite, "position:y", 0.0, 0.8) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_body_entered(body: Node2D) -> void:
	if _collected or not body.is_in_group("player"):
		return
	_collected = true
	Game.collect_berry()

	sprite.hide()
	$Shape.set_deferred("disabled", true)
	pop.emitting = true
	await get_tree().create_timer(0.8).timeout
	queue_free()
