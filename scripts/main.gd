extends Node2D
## Sets up the level: keeps the camera inside the map and listens for restarts.

## Left, top, right and bottom edge of the level in pixels.
@export var camera_bounds := Rect2(-60, -260, 3960, 780)

@onready var camera: Camera2D = $Player/Camera


func _ready() -> void:
	camera.limit_left = int(camera_bounds.position.x)
	camera.limit_top = int(camera_bounds.position.y)
	camera.limit_right = int(camera_bounds.end.x)
	camera.limit_bottom = int(camera_bounds.end.y)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Game.restart()
