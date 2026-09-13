extends Node2D

func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE),int(pos.y / Data.TILE_SIZE))
	match tool:
		Enum.Tool.HOE:
			$Layers/DirtLayer.set_cells_terrain_connect([grid_coord], 0, 0)
		
		Enum.Tool.WATER:
			var cell = $Layers/DirtLayer.get_cell_tile_data(grid_coord) as TileData
			if cell:
				$Layers/SoilLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2), 0))
