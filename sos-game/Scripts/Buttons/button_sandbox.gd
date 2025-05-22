extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(660, 562) 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Sandbox/sandbox.tscn")
