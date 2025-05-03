class_name RescueStation
extends Node2D

#amount of house can be added as needed
@export var houses : Array[House]
@export var cost : int
@export var id : int
var built : bool = false


func _ready() -> void:
	$Sprite2D.visible = false
	$Button.text = str(id) + " : " +str(cost)
	$TextEdit.visible = false
	$TextEdit.editable =false

func _on_button_button_up() -> void:
	if(!built) :
		built = true
	else :
		built = false
	
	change_state()


func change_state()->void :
	$Sprite2D.visible = built
	$TextEdit.visible = built
	cover_houses(built)

func cover_houses(value : bool)->void :
	for i in houses :
		i.covered = value

func is_built()->bool :
	return built

	
