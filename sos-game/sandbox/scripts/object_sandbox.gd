class_name ObjectSandbox
extends Node2D

var collision_count: int = 0


func is_colliding() -> bool:
	return(collision_count > 0)


func change_sprite(direction: bool) -> void:
	pass


func set_collision_indicator(value: bool) -> void:
	pass
