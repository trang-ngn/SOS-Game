@tool ## For live editor
class_name House
extends StaticBody2D

@onready var design: Sprite2D = $Design

# Preload the textures
const TEXTURE_OPTIONS := {
	"brown": preload("uid://bphrnn6loor1g"),
	"green": preload("uid://3rfyasgsx360"),
	"red": preload("uid://ctevmmeisshde"),
	"white": preload("uid://cqiguguw1o4kq"),
	"lightb": preload("uid://ca18pjm6f2lqn")
}

@export_enum("brown", "green", "red", "white", "lightb") var texture_choice: String = "brown":
	set(value):
		texture_choice = value
		_update_texture()

var num_covering_stations: int = 0
var is_covered: bool = false
var id: int = 0


func _ready() -> void:
	id = get_index()
	_update_texture()
	_set_outline(false)


func _update_texture() -> void:
	if design:
		design.texture = TEXTURE_OPTIONS.get(texture_choice, null)


## For live editor
func _notification(what):
	if what == NOTIFICATION_READY and Engine.is_editor_hint():
		_update_texture()


func _set_outline(value: bool) -> void:
	design.set_instance_shader_parameter("active", value)


func update_num_covering_stations(value: int) -> void:
	num_covering_stations = max(0, num_covering_stations + value)
	is_covered = num_covering_stations > 0
	_set_outline(is_covered)
