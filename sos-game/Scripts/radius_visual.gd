extends Node2D

@onready var RadiusSizeNode: CollisionShape2D = get_node("../RadiusSize")

@export var color : Color

func _draw() -> void:
	var circle: CircleShape2D = RadiusSizeNode.shape
	var scale = RadiusSizeNode.transform.get_scale().x
	var radius: float = circle.radius * scale
	var position: Vector2 = RadiusSizeNode.position
	draw_circle(position, radius, color)
