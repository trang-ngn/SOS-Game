@tool
class_name RescueStation
extends Node2D

var houses : Array[House]
@export var cost : int
@export var id : int

@onready var radius_size : CollisionShape2D = $Radius/RadiusSize
@export var radius : float : 
	set(value):
		radius = value
		if radius_size and radius_size.shape :
			radius_size.shape.radius = radius
		
var built : bool = false

signal stations_updated



#For sandbox
@export var rect: Rect2

func get_global_rect():
	return Rect2(
		global_position - rect.size / 2,
		rect.size
	)
func set_on_place():
	modulate.a = 1


func _ready() -> void:
	initialize()


func _on_button_button_up() -> void:
	if (!built):
		built = true
	else:
		built = false

	change_state()


func change_state()->void:
	$Sprite2D.visible = built
	#$TextEdit.visible = built
	cover_houses(built)
	emit_signal("stations_updated")


func cover_houses(value: bool)->void:
	for h in houses:
		if (value == true):
			h.num_stat_cover += 1
			h.set_outline()
		elif(value == false && h.num_stat_cover == 0):
			h.num_stat_cover = 0
			h.set_outline()
		else:
			h.num_stat_cover -= 1
			h.set_outline()

func get_covered_houses() -> Array:
	var bodies: Array = $Radius.get_overlapping_bodies()
	var index_array: Array = []

	for body in bodies:
		if body is House:
			index_array.append(body.id)

	return index_array


func is_built()->bool:
	return built


func initialize() -> void:
	$Sprite2D.visible = false
	$Plot.text = str(id) + " : " +str(cost)
	$StationNumber.visible = false
	$StationNumber.editable =false
	$Radius/RadiusSize.visible = false


func _on_area_2d_body_entered(body: House) -> void:
	houses.append(body)


func _on_button_mouse_entered() -> void:
	$Radius/RadiusSize.visible = true


func _on_button_mouse_exited() -> void:
	$Radius/RadiusSize.visible = false
