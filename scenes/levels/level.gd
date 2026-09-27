extends Node2D

var used_cells: Array[Vector2i]
var plant_scene = preload("res://scenes/objects/plant.tscn")
var plant_info_scene = preload("res://scenes/ui/plant_info.tscn")
var raining: bool:
	set(value):
		raining = value
		$Overlay/RaindropsParticles.emitting = value
		$Layers/RainFloorParticles.emitting = value
var sleep: bool:
	set(value):
		sleep = value
@onready var player = $Objects/Player
@onready var daytransition_material = $Overlay/CanvasLayer/DaytransitionLayer.material
@export var daytime_color: Gradient
@export var rain_color: Color
func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE),int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	var has_soil = grid_coord in $Layers/DirtLayer.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			var cell = $Layers/GrassLayer.get_cell_tile_data(grid_coord) as TileData
			if cell and cell.get_custom_data('farmable'):
				$Layers/DirtLayer.set_cells_terrain_connect([grid_coord], 0, 0)
				if raining:
					$Layers/SoilLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2), 0))
		Enum.Tool.WATER:
			if has_soil:
				$Layers/SoilLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2), 0))
		Enum.Tool.FISH:
			if not grid_coord in $Layers/GrassLayer.get_used_cells():
				$Objects/Player.start_fishing()
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant_res = PlantResource.new()
				plant_res.setup($Objects/Player.current_seed)
				var plant = plant_scene.instantiate()
				plant.setup(grid_coord,$Objects, plant_res, plant_death)
				used_cells.append(grid_coord)
				
				print(used_cells)
				var plant_info = plant_info_scene.instantiate()
				plant_info.setup(plant_res)
				$Overlay/CanvasLayer/PlantInfoContainer.add(plant_info)
		Enum.Tool.AXE, Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos) < 20:
					object.hit(tool)
func _on_player_diagnose() -> void:
	$Overlay/CanvasLayer/PlantInfoContainer.visible = not $Overlay/CanvasLayer/PlantInfoContainer.visible
func _on_player_day_change() -> void:
	day_restart()
func _process(_delta: float) -> void:
	var daytime_point = 1 - ($Timers/DaylightTimer.time_left / $Timers/DaylightTimer.wait_time)
	var color = daytime_color.sample(daytime_point).lerp(rain_color, 0.5 if raining else 0.0)
	$Overlay/DaytimeColor.color = color
	
func _ready() -> void:
	Data.forecast_rain = [true, false].pick_random()
func day_restart():
	var tween = create_tween()
	tween.tween_property(daytransition_material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property(daytransition_material, "shader_parameter/progress", 0.0, 1.0)
func level_reset():
	for plant in get_tree().get_nodes_in_group("Plants"):
		plant.grow(plant.coord in $Layers/SoilLayer.get_used_cells())
	$Layers/SoilLayer.clear()
	$Overlay/CanvasLayer/PlantInfoContainer.update_all()
	
	$Timers/DaylightTimer.start()
	for object in get_tree().get_nodes_in_group("Objects"):
		if 'reset' in object:
			object.reset()
			
	raining = Data.forecast_rain
	Data.forecast_rain = [true,false].pick_random()
	print("will rain" if Data.forecast_rain else "sunny")
	
	if raining:
		for cell in $Layers/DirtLayer.get_used_cells():
			$Layers/SoilLayer.set_cell(cell, 0, Vector2i(randi_range(0,2), 0))
func plant_death(coord: Vector2i):
	used_cells.erase(coord)
	print(used_cells)
