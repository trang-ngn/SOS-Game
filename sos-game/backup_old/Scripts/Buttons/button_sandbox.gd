extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(660, 562) 

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Sandbox/sandbox.tscn")
