extends Node2D

@export var stations: Array[Station]
@onready var plot: TextureButton = $Plot
@onready var label : Label = $Plot/Label
@onready var template : Sprite2D = $Template

var current_station : int = -1
var num_of_stations : int = 0
var BUILD_STATION_SHADER := load("uid://p7q2vflbay8j")


func _ready() -> void:
	num_of_stations = len(stations)
	initialize_stations()
	_setup_shader_material()
	plot.button_up.connect(_on_plot_button_up)
	plot.mouse_entered.connect(_on_plot_mouse_entered)
	plot.mouse_exited.connect(_on_plot_mouse_exited)


func initialize_stations() -> void:
	for s in stations:
		s.hide_plot()
		#s.position = template.global_position + Vector2(0,11)

	template.visible = false


func set_text() -> void:
	if current_station == num_of_stations:
		label.text = "--------------" + "\n" + " xx : xM €"
		return

	label.text = "\n" + str(stations[current_station].id) + " : " + str(stations[current_station].cost) + "M €"


func change_current_station() -> void:
	current_station = (current_station + 1) % (num_of_stations + 1)


func _setup_shader_material():
	template.material = ShaderMaterial.new()
	template.material.shader = BUILD_STATION_SHADER


# someone clean this pls
func _on_plot_button_up() -> void:
	change_current_station()
	if current_station == 0:
		stations[current_station].change_state(true)
		stations[current_station].toggle_radius_visibility(true)

	elif current_station > 0 and current_station < num_of_stations:
		stations[current_station - 1].toggle_radius_visibility(false)
		stations[current_station - 1].change_state(false)
		stations[current_station].change_state(true)
		stations[current_station].toggle_radius_visibility(true)
	else:
		stations[current_station - 1].change_state(false)
		stations[current_station - 1].toggle_radius_visibility(false)

	set_text()


func _on_plot_mouse_entered() -> void:

	if current_station == num_of_stations or current_station == -1:
		return

	stations[current_station].toggle_radius_visibility(true)


func _on_plot_mouse_exited() -> void:
	if current_station == num_of_stations or current_station == -1:
		return

	stations[current_station].toggle_radius_visibility(false)
