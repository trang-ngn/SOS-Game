class_name ObjectsDeleter
extends ObjectSandbox

var collided_object:ObjectSandbox = null
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $DeleteDesign
@onready var root : Node2D = $"../.."


func switch_deleter(value : bool) -> void :
	collision.disabled = !value
	sprite.visible = value


func _on_area_entered(area: ObjectSandbox) -> void:
	if area is HouseSandbox or StationSandbox:
		collided_object = area
		area.set_collision_indicator(true)

	#debug purpose
	#print(area.name + " entered")


func _on_area_exited(area: ObjectSandbox) -> void:
	if area is HouseSandbox or StationSandbox:
		collided_object = null
		area.set_collision_indicator(false)

	#debug purpose
	#print(area.name + " quit")
