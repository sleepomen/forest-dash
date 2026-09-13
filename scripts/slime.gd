extends Area2D
## A slime that paces back and forth. Land on top of it to squash it,
## walk into its side and the fox gets hurt.

const SPEED := 52.0
const STOMP_MARGIN := 14.0   # how far above the slime the fox has to be

## How far the slime walks from its starting point, in pixels.
@export var patrol_distance := 96.0

@onready var sprite: AnimatedSprite2D = $Sprite

var _start_x := 0.0
var _direction := 1.0
var _squashed := false


func _ready() -> void:
	_start_x = global_position.x
	sprite.play("move")
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if _squashed or Game.state != Game.State.PLAYING:
		return

	global_position.x += _direction * SPEED * delta
	if absf(global_position.x - _start_x) >= patrol_distance * 0.5:
		_direction = -_direction
		global_position.x = _start_x + signf(global_position.x - _start_x) \
			* patrol_distance * 0.5
	sprite.flip_h = _direction < 0.0


func _on_body_entered(body: Node2D) -> void:
	if _squashed or not body.is_in_group("player"):
		return

	var stomped: bool = body.velocity.y > 0.0 \
		and body.global_position.y < global_position.y - STOMP_MARGIN
	if stomped:
		_squash()
		body.bounce()
	else:
		body.hurt()


func _squash() -> void:
	_squashed = true
	Game.stomp_enemy()
	sprite.play("hit")
	$Shape.set_deferred("disabled", true)

	var fade := create_tween()
	fade.tween_interval(0.35)
	fade.tween_property(sprite, "modulate:a", 0.0, 0.25)
	fade.tween_callback(queue_free)
