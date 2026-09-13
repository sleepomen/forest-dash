extends Area2D
## Thorn bushes. Touching them costs a life.


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hurt()
