# Camera2D controller with zoom-adaptive panning

# To still be tested with a mouse and on Windows
# Still to implement a bounding box of some sort to prevent panning into the void

extends Camera2D

# Config. variables (gladly tinker with them)
@export var zoom_speed: float = 1.05
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0
@export var zoom_smoothing_speed: float = 8.0
@export var pan_sensitivity: float = 1.2
@export var pan_smoothing_speed: float = 15.0


# Internal state vars
var is_panning: bool = false
var target_zoom: Vector2 
var target_position: Vector2 


func _ready() -> void:
	# To activate the camera
	make_current()

	target_zoom = zoom
	target_position = position


func _unhandled_input(event: InputEvent) -> void:
	# Zooming logic

	# Mouse section: Please test as I do not own a mouse :(
	
	# Check if the input event was a mouse button press.
	if event is InputEventMouseButton:
		# If the mouse wheel was scrolled up, zoom in.
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			# We call our zoom function with a factor less than 1.0 to zoom in.
			zoom_towards_point(1.0 / zoom_speed, event.position)
		# If the mouse wheel was scrolled down, zoom out.
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			# We call our zoom function with a factor greater than 1.0 to zoom out.
			zoom_towards_point(zoom_speed, event.position)

	# Trackpad logic
	if event is InputEventMagnifyGesture:
		# The 'event.factor' tells us how much the user pinched or spread their fingers.
		# We pass this directly to our zoom function.
		zoom_towards_point(event.factor, event.position)

	# Handling panning (I'd rather pan for gold than be doing this rn)

	# Check if the right mouse button was pressed or released.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		# Set our 'is_panning' flag to true when pressed, and false when released.
		is_panning = event.is_pressed()
		# Change the mouse cursor to a "dragging" hand icon when panning.
		Input.set_default_cursor_shape(Input.CURSOR_DRAG if is_panning else Input.CURSOR_ARROW)

	# Check if the mouse is moving AND we are currently panning.
	if event is InputEventMouseMotion and is_panning:
		# This is a cool formula!
		# We move the camera by the amount the mouse moved (event.relative).
		# importantly, we DIVIDE by the current zoom level. This makes the panning feel
		# consistent: when you're zoomed in (e.g., zoom.x = 0.5), the world moves faster.
		# When you're zoomed out (e.g., zoom.x = 2.0), the world moves slower. 
		#TODO: panning is still very fast when zoomed in and slow when out.
		target_position -= event.relative * pan_sensitivity * zoom.x

	# Check for trackpad input
	if event is InputEventPanGesture:
		# Same idea!
		target_position -= event.delta * pan_sensitivity * zoom.x


# 'delta' is the time that has passed since the last frame. 
func _process(delta: float) -> void:
	# Another cool formula!
	# This is where the smoothing happens. Instead of instantly jumping to the target,
	# we use lerp to move the camera's actual properties part of the way towards their target values each frame.
	position = position.lerp(target_position, pan_smoothing_speed * delta)
	zoom = zoom.lerp(target_zoom, zoom_smoothing_speed * delta)


# This function contains all the logic for zooming towards a specific point on the screen.
func zoom_towards_point(amount: float, screen_point: Vector2) -> void:
	var old_zoom = target_zoom
	# Calculate the new zoom level by multiplying by the 'amount' factor.
	# Use clamp to make sure the new zoom doesn't go outside our min/max limits
	var new_zoom = (target_zoom * amount).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	
	if new_zoom == old_zoom:
		return
	
	# This is the most complicated part: making the zoom happen at the cursor's location.
	# To do this, we must find out what point in the map is below the mouse.
	
	# 1. Get the viewport's total transformation matrix.
	var canvas_transform = get_viewport().get_canvas_transform()
	
	# 2. Use the affine_inverse() of that transform to convert the mouse's position on the screen (screen_point) 
	# into a position in the game world (point_in_world).
	var point_in_world = canvas_transform.affine_inverse() * screen_point
	
	# 3. This is the key mathematical formula to calculate the new camera position.
	#    It calculates the ratio of the old zoom to the new zoom.
	var ratio = old_zoom.x / new_zoom.x
	#    Then, it calculates the vector from the point under the mouse to the camera's
	#    current position, scales it by the zoom ratio, and adds it back to the
	#    point under the mouse. This ensures the point you're zooming in on
	#    stays in the same place on the screen.
	target_position = point_in_world + (target_position - point_in_world) * ratio
	
	# 4. Finally, we set our new target zoom.
	target_zoom = new_zoom
