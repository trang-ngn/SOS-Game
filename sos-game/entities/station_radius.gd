extends Node2D

# get parent node
@onready var RadiusSizeNode: CollisionShape2D = get_node("../RadiusSize")

var color: Color = Color(1,1,1,0.18)


# built_in function to draw shape
func _draw() -> void:
	# get scale, radius, position from RadiusSize (for easy debug)
	var circle: CircleShape2D = RadiusSizeNode.shape
	var c_scale = RadiusSizeNode.transform.get_scale().x
	var radius: float = circle.radius * c_scale
	var c_position: Vector2 = RadiusSizeNode.position

	draw_circle(c_position, radius, color)
