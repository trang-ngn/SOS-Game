extends Node2D

@export var stations : Array[RescueStation]
@onready var button : TextureButton = $TextureButton
@onready var label : Label = $TextureButton/Label
@onready var template : Sprite2D = $Template

var current_station : int = -1
var num_of_stations : int = 0

func _ready() -> void:
	num_of_stations = len(stations)
	initialize_stations()

func initialize_stations() -> void :
	for s in stations :
		s.hide_plot()
		s.position = template.global_position + Vector2(0,11)
	template.visible = false

func set_text() -> void :
	if current_station == num_of_stations :
		label.text = "--------------" + "\n" + " xx : xM €"
		return
	label.text = "\n" + str(stations[current_station].id) + " : " + str(stations[current_station].cost) + "M €"

func change_current_station() -> void :
	current_station =  (current_station + 1) % (num_of_stations + 1)

#someone clean this pls
func _on_texture_button_button_up() -> void:
	change_current_station()
	print(current_station)
	if current_station == 0 :
		stations[current_station].built = true
		stations[current_station].change_state()
		stations[current_station].toggle_radius(true)
		
	elif current_station > 0 and current_station < 3 :
		stations[current_station - 1].built = false
		stations[current_station - 1].toggle_radius(false)
		stations[current_station - 1].change_state()
		
		
		stations[current_station].built = true
		stations[current_station].change_state()
		stations[current_station].toggle_radius(true)
	else :
		stations[current_station - 1].built = false
		stations[current_station - 1].change_state()
		stations[current_station - 1].toggle_radius(false)
	
	set_text()


func _on_texture_button_mouse_entered() -> void:
	if current_station == num_of_stations or current_station == -1 :
		return
	stations[current_station].toggle_radius(true)

func _on_texture_button_mouse_exited() -> void:
	if current_station == num_of_stations or current_station == -1 :
		return
	stations[current_station].toggle_radius(false)
