class_name House
extends Node2D

var covered : bool = false

func is_covered() -> bool :
	return covered

func _ready() -> void:
	$TextEdit.visible = false
	
