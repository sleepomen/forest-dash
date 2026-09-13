extends CanvasLayer
## Score, berries, hearts, and the win / game over panels.

@onready var hearts: HBoxContainer = $Root/Top/Hearts
@onready var berry_label: Label = $Root/Top/BerryLabel
@onready var score_label: Label = $Root/Top/ScoreLabel
@onready var hint: Label = $Root/Hint
@onready var overlay: Control = $Root/Overlay
@onready var overlay_title: Label = $Root/Overlay/Panel/Title
@onready var overlay_text: Label = $Root/Overlay/Panel/Text


func _ready() -> void:
	Game.stats_changed.connect(_refresh)
	Game.state_changed.connect(_on_state_changed)
	overlay.hide()
	_refresh()

	# The controls hint fades away once you have had a look at it.
	var fade := create_tween()
	fade.tween_interval(4.0)
	fade.tween_property(hint, "modulate:a", 0.0, 1.0)


func _refresh() -> void:
	score_label.text = "SCORE  %d" % Game.score
	berry_label.text = "%d / %d" % [Game.berries_collected, Game.berries_total]
	for i in hearts.get_child_count():
		var heart := hearts.get_child(i) as TextureRect
		heart.modulate = Color(1, 1, 1, 1) if i < Game.lives else Color(0, 0, 0, 0.35)


func _on_state_changed(new_state: int) -> void:
	if new_state == Game.State.PLAYING:
		overlay.hide()
		return

	if new_state == Game.State.WON:
		overlay_title.text = "YOU MADE IT HOME!"
		overlay_text.text = "Berries %d / %d      Score %d\n\nPress R to play again" % [
			Game.berries_collected, Game.berries_total, Game.score]
	else:
		overlay_title.text = "OUT OF HEARTS"
		overlay_text.text = "Score %d\n\nPress R to try again" % Game.score

	overlay.modulate.a = 0.0
	overlay.show()
	create_tween().tween_property(overlay, "modulate:a", 1.0, 0.4)
