class_name RescueStation
extends Node2D

@export var house1 : House
@export var house2 : House
@export var house3 : House
@export var house4 : House
@export var house5 : House

@export var houses : Array[House]
var built : bool = false

func _ready() -> void:
	$Sprite2D.visible = false

func _on_button_button_up() -> void:
	if(!built) :
		built = true
	else :
		built = false
	
	change_state()


func change_state()->void :
	$Sprite2D.visible = built
	cover_houses(built)

func cover_houses(value : bool)->void :
	for i in houses :
		i.covered = value

func is_built()->bool :
	return built

	
