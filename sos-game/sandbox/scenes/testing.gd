extends Node2D

@onready var station = $StationSandbox


func _on_button_pressed() -> void:
	station.cover_houses()
