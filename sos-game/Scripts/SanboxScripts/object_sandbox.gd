class_name ObjectSandbox
extends Node2D

var collision_count : int = 0

func is_colliding() -> bool :
	return (collision_count > 0)
