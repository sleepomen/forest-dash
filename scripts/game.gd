extends Node
## Global game state. Autoloaded as "Game", so every other script can just
## call Game.collect_berry(), Game.play("jump"), Game.lives, and so on.

signal stats_changed
signal state_changed(new_state: int)

enum State { PLAYING, WON, LOST }

const MAX_LIVES := 3
const BERRY_POINTS := 10
const STOMP_POINTS := 25
const LIFE_BONUS := 50

const SOUNDS := {
	"jump": preload("res://assets/audio/jump.wav"),
	"collect": preload("res://assets/audio/collect.wav"),
	"stomp": preload("res://assets/audio/stomp.wav"),
	"hurt": preload("res://assets/audio/hurt.wav"),
	"win": preload("res://assets/audio/win.wav"),
}

var score := 0
var lives := MAX_LIVES
var berries_collected := 0
var berries_total := 0
var state := State.PLAYING

var _sfx_players: Array[AudioStreamPlayer] = []
var _next_player := 0


func _ready() -> void:
	for child in $Sfx.get_children():
		_sfx_players.append(child)
	# The .wav files are not marked as looping, so restart the music by hand.
	$Music.finished.connect(func() -> void: $Music.play())
	$Music.play()


## Plays one of the sounds in SOUNDS. Several players take turns so that
## overlapping sounds (a jump while a berry pops) do not cut each other off.
func play(sound: String) -> void:
	if not SOUNDS.has(sound) or _sfx_players.is_empty():
		return
	var player := _sfx_players[_next_player]
	_next_player = (_next_player + 1) % _sfx_players.size()
	player.stream = SOUNDS[sound]
	player.play()


## Every berry calls this when the level loads, so the HUD knows the total.
func register_berry() -> void:
	berries_total += 1
	stats_changed.emit()


func collect_berry() -> void:
	berries_collected += 1
	score += BERRY_POINTS
	play("collect")
	stats_changed.emit()


func stomp_enemy() -> void:
	score += STOMP_POINTS
	play("stomp")
	stats_changed.emit()


func lose_life() -> void:
	if state != State.PLAYING:
		return
	lives -= 1
	play("hurt")
	stats_changed.emit()
	if lives <= 0:
		lives = 0
		state = State.LOST
		state_changed.emit(state)


func win() -> void:
	if state != State.PLAYING:
		return
	state = State.WON
	score += lives * LIFE_BONUS
	play("win")
	stats_changed.emit()
	state_changed.emit(state)


## Wipes the score and reloads the level from the beginning.
func restart() -> void:
	score = 0
	lives = MAX_LIVES
	berries_collected = 0
	berries_total = 0
	state = State.PLAYING
	stats_changed.emit()
	state_changed.emit(state)
	get_tree().reload_current_scene()
