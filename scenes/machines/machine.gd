class_name Machine extends StaticBody2D

var coord: Vector2i

func setup(pos: Vector2, _level: Node2D, parent: Node2D):
	coord = pos / Data.TILE_SIZE
	position = pos
	parent.add_child(self)
