@tool
extends GridContainer

@export var width := 5 :
	set(value) :
		width = value
		
		create_grid()

@export var height := 5 :
	set(value) :
		height = value
		
		create_grid()

@export var cell_width := 100 :
	set(value) :
		cell_width = value
		
		create_grid()

@export var cell_height := 100 :
	set(value) :
		cell_height = value
		
		create_grid()

@export var border_size := 0:
	set(value):
		border_size = value
		create_grid()
		

const GRID_CELL = preload("res://Scenes/Sandbox_Grid/gird_cell.tscn")


func _ready() -> void:
	create_grid()
	
func create_grid() -> void :
	remove_grid()
	
	
	add_theme_constant_override("h_separation", border_size)
	add_theme_constant_override("v_separation", border_size)
	
	columns = width
	
	for i in width * height :
		var grid_cell_node = GRID_CELL.instantiate()
		grid_cell_node.custom_minimum_size = Vector2(cell_width,cell_height)
		add_child(grid_cell_node)

func remove_grid() -> void :
	for node in get_children() :
		node.queue_free()
