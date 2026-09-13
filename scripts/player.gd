extends CharacterBody2D
## The fox. Runs, jumps, bounces off slimes and respawns at the last safe
## spot whenever it gets hurt.

const SPEED := 260.0
const ACCELERATION := 2000.0
const GROUND_FRICTION := 2800.0
const AIR_FRICTION := 700.0
const JUMP_VELOCITY := -720.0
const STOMP_VELOCITY := -540.0
const MAX_FALL_SPEED := 900.0

# Small helpers that make the jump feel fair instead of frustrating.
const COYOTE_TIME := 0.10      # you may still jump just after leaving a ledge
const JUMP_BUFFER := 0.12      # a jump pressed just before landing still counts
const JUMP_CUT := 0.45         # releasing the key early makes a shorter hop

const INVINCIBLE_TIME := 1.2
const DEATH_HEIGHT := 760.0    # fall below this and you lose a life

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var dust: CPUParticles2D = $Dust

# Pulled from Project Settings > Physics > 2D > Default Gravity.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", 2200.0)

var safe_position: Vector2
var _coyote := 0.0
var _buffer := 0.0
var _invincible := 0.0
var _safe_timer := 0.0


func _ready() -> void:
	add_to_group("player")
	safe_position = global_position


func _physics_process(delta: float) -> void:
	_tick_timers(delta)

	if not is_on_floor():
		velocity.y = minf(velocity.y + gravity * delta, MAX_FALL_SPEED)

	if Game.state == Game.State.PLAYING:
		_handle_movement(delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, GROUND_FRICTION * delta)

	move_and_slide()
	_update_animation()

	if global_position.y > DEATH_HEIGHT:
		hurt()


func _tick_timers(delta: float) -> void:
	_coyote = COYOTE_TIME if is_on_floor() else maxf(0.0, _coyote - delta)
	_buffer = maxf(0.0, _buffer - delta)
	_invincible = maxf(0.0, _invincible - delta)
	# Blink while invincible so it is obvious you cannot be hurt right now.
	sprite.modulate.a = 0.45 if _invincible > 0.0 and int(_invincible * 12) % 2 == 0 else 1.0

	# Remember where we were standing, to respawn there after getting hurt.
	if is_on_floor() and _invincible <= 0.0:
		_safe_timer += delta
		if _safe_timer >= 0.35:
			_safe_timer = 0.0
			safe_position = global_position
	else:
		_safe_timer = 0.0


func _handle_movement(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		var friction := GROUND_FRICTION if is_on_floor() else AIR_FRICTION
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	if Input.is_action_just_pressed("jump"):
		_buffer = JUMP_BUFFER
	if _buffer > 0.0 and _coyote > 0.0:
		_jump()
	# Let go of the jump key early to jump lower.
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= JUMP_CUT


func _jump() -> void:
	velocity.y = JUMP_VELOCITY
	_buffer = 0.0
	_coyote = 0.0
	Game.play("jump")


func _update_animation() -> void:
	if velocity.x > 5.0:
		sprite.flip_h = false
	elif velocity.x < -5.0:
		sprite.flip_h = true

	if not is_on_floor():
		sprite.play("jump" if velocity.y < 0.0 else "fall")
	elif absf(velocity.x) > 15.0:
		sprite.play("run")
	else:
		sprite.play("idle")

	dust.emitting = is_on_floor() and absf(velocity.x) > 80.0


## Called by slimes when you land on them.
func bounce() -> void:
	velocity.y = STOMP_VELOCITY
	_coyote = 0.0


## Called by thorns, slimes and the bottom of the level.
func hurt() -> void:
	if _invincible > 0.0 or Game.state != Game.State.PLAYING:
		return
	_invincible = INVINCIBLE_TIME
	Game.lose_life()
	global_position = safe_position
	velocity = Vector2.ZERO
