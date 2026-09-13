@tool
extends StaticBody2D
## A ground block that you can resize by the tile in the Inspector.
## The top row is grass, everything under it is dirt.
##
## The node's origin is its top-left corner, so a platform placed at
## (320, 352) starts on the tile grid at column 10, row 11.

const TILE := 32

@export_range(1, 80) var tiles_wide: int = 4:
	set(value):
		tiles_wide = maxi(1, value)
		_rebuild()

@export_range(1, 40) var tiles_high: int = 2:
	set(value):
		tiles_high = maxi(1, value)
		_rebuild()


func _ready() -> void:
	_rebuild()


func _rebuild() -> void:
	if not is_inside_tree():
		return
	var grass := get_node_or_null("Grass") as Sprite2D
	var dirt := get_node_or_null("Dirt") as Sprite2D
	var shape := get_node_or_null("Shape") as CollisionShape2D
	if grass == null or dirt == null or shape == null:
		return

	var w := tiles_wide * TILE
	var h := tiles_high * TILE

	grass.region_rect = Rect2(0, 0, w, TILE)
	dirt.position = Vector2(0, TILE)
	dirt.region_rect = Rect2(0, 0, w, maxf(TILE, h - TILE))
	dirt.visible = tiles_high > 1

	shape.position = Vector2(w * 0.5, h * 0.5)
	var rect := shape.shape as RectangleShape2D
	if rect != null:
		rect.size = Vector2(w, h)
