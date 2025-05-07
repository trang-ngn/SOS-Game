class_name House
extends Node2D

var covered : bool = false
var built : bool = false

func is_covered() -> bool :
	return covered

func _ready() -> void:
	$TextEdit.visible = false
	$Sprite2D.visible = false

func _on_button_button_up() -> void:
	if(!built) :
		built = true
	else :
		built = false
	
	change_state()
	
func change_state()->void :
	$Sprite2D.visible = built
	$TextEdit.visible = built
