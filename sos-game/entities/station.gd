@tool
extends Node2D
class_name Station

# Constants
const TEXTURE_OPTIONS := {
	"2": preload("uid://b55x4ix5nu4aa"),
	"3": preload("uid://bp4f24vtvqyxg"),
	"4": preload("uid://8jekb2tcjxi6")
}
var BUILD_STATION_SHADER := load("uid://p7q2vflbay8j")

# Editor Properties
@export var cost: int:
	set(value):
		cost = value

		if plot:
			plot.text = str(id) + "\n" + str(cost) + "M €"

@export_enum("2", "3", "4") var texture_choice: String = "2":
	set(value):
		texture_choice = value

		if design:
			design.texture = TEXTURE_OPTIONS.get(texture_choice)

# Node References
@onready var design: Sprite2D = $Design
@onready var plot: Button = $Plot
@onready var optimal_marker: TextureRect = $OptimalMarker
@onready var radius_area: Area2D = $Radius
@onready var radius_size: CollisionShape2D = $Radius/RadiusSize
@onready var radius_visual: Node2D = $Radius/RadiusVisual

# State
var id: int
var covered_houses: Array[House] = []
var is_built: bool = false
var is_optimal: bool = false

# Signals
signal stations_updated


func _ready() -> void:
	id = get_index()

	if radius_size and radius_size.shape:
		radius_size.shape = radius_size.shape.duplicate(true)

	radius_visual.visible = false
	radius_visual.z_index = 100
	design.z_index = 200
	radius_area.body_entered.connect(_on_radius_area_body_entered)

	plot.text = str(id) + "\n" +str(cost) + "M €"
	plot.button_up.connect(_on_plot_button_up)
	plot.mouse_entered.connect(_on_plot_mouse_entered)
	plot.mouse_exited.connect(_on_plot_mouse_exited)
	design.texture = TEXTURE_OPTIONS.get(texture_choice)

	if not Engine.is_editor_hint():
		_setup_shader_material()
		design.set_instance_shader_parameter("progress", 1.0)


func _setup_shader_material():
	design.material = ShaderMaterial.new()
	design.material.shader = BUILD_STATION_SHADER


func _on_radius_area_body_entered(body: Node) -> void:
	if body is House:
		covered_houses.append(body)


func change_state(built_state: bool = not is_built) -> void:
	is_built = built_state # change state
	_play_animation()
	_update_house_coverage_count(is_built)
	emit_signal("stations_updated")


func _on_plot_button_up() -> void:
	change_state()


func _play_animation()-> void:
	design.set_instance_shader_parameter("wiggle_strength", 2.4)
	var total_time:float = 0.25
	var interval: float = 0.05
	var elapsed: float = 0.0

	while elapsed <= total_time:
		var raw_progress = elapsed / total_time

		var shader_progress = raw_progress if not is_built else(1.0 - raw_progress)
		design.set_instance_shader_parameter("progress", shader_progress)
		await get_tree().create_timer(interval).timeout
		elapsed += interval

	# Disable wiggle after reveal
	design.set_instance_shader_parameter("wiggle_strength", 0.0)


func _update_house_coverage_count(station_is_built: bool) -> void:
	for house in covered_houses:
		house.update_num_covering_stations(+1 if station_is_built else -1)


func _on_plot_mouse_entered() -> void:
	toggle_radius_visibility(true)


func _on_plot_mouse_exited() -> void:
	toggle_radius_visibility(false)


func toggle_radius_visibility(value: bool) -> void:
	radius_visual.visible = value


func hide_plot() -> void:
	plot.visible = false
	plot.disabled = true


func get_covered_houses() -> Array:
	var bodies: Array = radius_area.get_overlapping_bodies()
	var house_indices: Array = []

	for body in bodies:
		if body is House:
			house_indices.append(body.id)

	return house_indices


func set_optimal(state: bool) -> void:
	optimal_marker.visible = state
