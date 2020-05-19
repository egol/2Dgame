extends Node

export var windDirection = Vector2(1, 0) setget set_wind_direction

signal wind_direction_changed(value)

func set_wind_direction(value):
	windDirection = value
	emit_signal("wind_direction_changed")
