class_name RescueStation
extends Node2D

var houses : Array[House]
@export var cost : int
var id : int

@onready var sprite = $Sprite2D
@onready var radius_size : CollisionShape2D = $Radius/RadiusSize
@export var radius : float : 
	set(value):
		radius = value
		if radius_size and radius_size.shape :
			radius_size.shape.radius = radius
		
var built : bool = false
var optimal : bool = false #show-results

signal stations_updated


func _ready() -> void:
	id = get_index()
	initialize()

func hide_plot() :
	$Plot.visible = false
	$Plot.disabled = true

func _on_button_button_up() -> void:
	if (!built):
		built = true
	else:
		built = false

	change_state()

func play_animation()-> void :
	
	sprite.set_instance_shader_parameter("wiggle_strength", 2.4)
	var total_time :float = 0.4
	var interval : float = 0.05
	var elapsed : float = 0.0
	var new_progress : float = 0.0
	
	
	while elapsed <= total_time:
		var raw_progress = elapsed / total_time
		var shader_progress = raw_progress if !built else (1.0 - raw_progress)
		sprite.set_instance_shader_parameter("progress", shader_progress)
		await get_tree().create_timer(interval).timeout
		elapsed += interval
		

	# Disable wiggle after reveal
	sprite.set_instance_shader_parameter("wiggle_strength", 0.0)

func change_state()->void:
	play_animation()
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
	#print("index_array: ", index_array)
	return index_array


func is_built()->bool:
	return built

#show-results
func set_optimal(state: bool) -> void:
	$OptResult/HighlightRect.visible = state


func initialize() -> void:
	sprite.set_instance_shader_parameter("progress",1.0)
	$Plot.text = str(id) + "\n" +str(cost) + "M €"
	$StationNumber.visible = false
	$StationNumber.editable =false
	$Radius/RadiusSize.visible = false


func _on_area_2d_body_entered(body: Node) -> void:
	if body is House:
		houses.append(body)

func toggle_radius(value : bool) -> void:
	$Radius/RadiusSize.visible = value
	$Radius/RadiusVisual.visible = value

func _on_button_mouse_entered() -> void:
	toggle_radius(true)

func _on_button_mouse_exited() -> void:
	toggle_radius(false)
