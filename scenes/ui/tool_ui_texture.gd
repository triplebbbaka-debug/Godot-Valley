extends Control

var tool_enum: Enum.Tool

func setup(new_tool_enum: Enum.Tool, main_texture: Texture2D):
	tool_enum = new_tool_enum
	$TextureRect.texture = main_texture
